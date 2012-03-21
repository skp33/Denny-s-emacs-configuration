;; -*- coding: utf-8 -*-
;; File: gnus-setting.el
;;
;; Author: Denny Zhang(markfilebat@126.com)
;; Created: 2009-08-01
;; Updated: Time-stamp: <2012-03-21 14:56:36>
;; --8<-------------------------- §separator§ ------------------------>8--
(require 'gnus)
(setq mail-parent-directory-var (concat DENNY_CONF "../gnus_data/"))
(setq gnus-startup-file (concat mail-parent-directory-var ".newsrc")
      gnus-home-directory (concat mail-parent-directory-var "Mail")
      gnus-default-directory (concat mail-parent-directory-var "Mail")
      gnus-article-save-directory (concat mail-parent-directory-var "Mail/save")
      gnus-kill-files-directory (concat mail-parent-directory-var "Mail/trash")
      gnus-agent-directory (concat mail-parent-directory-var "Mail/agent")
      gnus-cache-directory (concat mail-parent-directory-var "Mail/cache")
      mail-source-directory (concat mail-parent-directory-var "Mail/incoming")
      nnmail-message-id-cache-file (concat mail-parent-directory-var "Mail/.nnmail-cache")
      nnml-newsgroups-file (concat mail-parent-directory-var "Mail/")
      message-directory (concat mail-parent-directory-var "Mail")
      nndraft-directory (concat mail-parent-directory-var "Mail/drafts/")
      message-auto-save-directory (concat mail-parent-directory-var "Mail/drafts/"))
;; --8<-------------------------- §separator§ ------------------------>8--
;; set the default location when saving mail's attachments
(setq mm-default-directory (concat mail-parent-directory-var "Attachment/"))
;; make the directory, if it doesn't exist
(unless (file-exists-p mm-default-directory) (make-directory mm-default-directory t))
;; --8<-------------------------- §separator§ ------------------------>8--
(setq gnus-save-newsrc-file nil
      gnus-read-newsrc-file nil
      gnus-use-dribble-file nil
      gnus-save-killed-list nil)
(setq gnus-interactive-exit nil) ;; No confirmation when exiting Gnus.
;; --8<-------------------------- §separator§ ------------------------>8--
;; view mail, and skip nntp newsgroup
(setq gnus-select-method '(nnml ""))
;; TODO: 126 imap没法读取邮件,　单独的python可以通过imap协议来操作,　应该是集成的问题
;; (setq gnus-select-method
;; '(nnimap "126"
;; (nnimap-address "imap.126.com")
;; (nnimap-server-port 143)
;; (nnimap-authinfo-file "~/backup/essential/Dropbox/private_data/emacs_stuff/emacs_data/filebat.authinfo")
;; ;;(nnimap-authinfo-file (concat DENNY_CONF "emacs_data/filebat.authinfo"))
;; ))
;; (setq gnus-secondary-select-methods
;; '((nnml "") ;; set mail reader
;; (nnimap "gmail"
;; (nnimap-address "imap.gmail.com")
;; (nnimap-server-port 993)
;; (nnimap-authinfo-file "~/backup/essential/Dropbox/private_data/emacs_stuff/emacs_data/filebat.authinfo")
;; ;;(nnimap-authinfo-file (concat DENNY_CONF "emacs_data/filebat.authinfo"))
;; (nnimap-stream ssl))
;; ))
(setq imap-log t) ;;Debugging IMAP
;; set pop server
(setq mail-sources ;; TODO, denny
      '(
        (pop :server "pop.126.com" ;; 在这里设置 pop3 服务器
             :user "markfilebat@126.com"
             :port 110
             :password "filetxt") ;; TODO: more secure
        (pop :server "mail.shopex.cn"
             :user "zhangwei"
             :port 110
             :password "markfilebat1") ;; TODO: more secure
        ;; ;; ;; (imap :server "imap.gmail.com" ;; 在这里设置 imap 服务器
        ;; ;; ;; :user "filebat.mark@gmail.com" ;; 用户名
        ;; ;; ;; :port 993
        ;; ;; ;; :stream ssl
        ;; ;; ;; :password mail-gmail-pwd)
        ;; ;; (pop :server "pop.gmail.com" ;; 在这里设置 pop3 服务器
        ;; ;; :user "filebat.mark@gmail.com"
        ;; ;; :port 995
        ;; ;; :stream ssl
        ;; ;; :password mail-gmail-pwd)
        ;; ;;
        ))
;; --8<-------------------------- §separator§ ------------------------>8--
;; setup multiple smtp account with the help of msmtp
(setq my-msmtp-config-file (concat "'" DENNY_CONF "emacs_data/filebat.msmtprc" "'"))
;; (setq sendmail-program (concat "msmtp -C " my-msmtp-config-file)) ;;TODO, enhance
(setq message-signature-file (concat DENNY_CONF "emacs_data/filebat.signature"))
(setq sendmail-program "msmtp")
(setq message-sendmail-envelope-from 'header)
(setq send-mail-function 'mailclient-send-it)
(setq message-send-mail-function 'message-send-mail-with-sendmail)
;; (setq mail-host-address "126.com")
(setq compose-mail-user-agent-warnings nil)
;; Use different mail accounts, when sending mails
(setq gnus-parameters
      ;;Use gmail id for all INBOX mails
      '((".*INBOX"
         (posting-style
          (address "fileba.mark@gmail.com")
          (name "filebat.mark")
          ;;(body "")
          (eval (setq message-sendmail-extra-arguments '("-a" "gmail")))
          (user-mail-address "filebat.mark@gmail.com")))
        ;;use 126 id for all other mails
        (".*"
         (posting-style
          (address "markfilebat@126.com")
          (name "markfilebat126")
          ;;(body "")
          (eval (setq message-sendmail-extra-arguments '("-a" "126")))
          (user-mail-address "markfilebat@126.com")))))
;; --8<-------------------------- §separator§ ------------------------>8--
;; group configuration
(setq gnus-group-line-format "%M\%S\%p\%P\ %4N/%4t :%B%(%g%)%O\n")
(setq gnus-summary-gather-subject-limit 'fuzzy) ;聚集题目用模糊算法
(setq gnus-summary-line-format "%4P %U%R%z%O %{%5k%} %{%14&user-date;%} %{%-20,20n%} %{%ua%} %B %(%I%-60,60s%)\n")
(setq gnus-summary-mode-line-format "Gnus: %p [%A / Sc:%4z] %Z")
(defun gnus-user-format-function-a (header) ;用户的格式函数 `%ua'
  (let ((myself (concat "<" user-mail-address ">"))
        (references (mail-header-references header))
        (message-id (mail-header-id header)))
    (if (or (and (stringp references)
                 (string-match myself references))
            (and (stringp message-id)
                 (string-match myself message-id)))
        "X" "│")))
(setq gnus-user-date-format-alist ;用户的格式列表 `user-date'
      '(((gnus-seconds-today) . "TD %H:%M") ;当天
        (604800 . "W%w %H:%M") ;七天之内
        ((gnus-seconds-month) . "%d %H:%M") ;当月
        ((gnus-seconds-year) . "%m-%d %H:%M") ;今年
        (t . "%y-%m-%d %H:%M"))) ;其他
;; --8<-------------------------- §separator§ ------------------------>8--
;; 线程的可视化外观, `%B'
(setq gnus-summary-same-subject "")
(setq gnus-sum-thread-tree-indent " ")
(setq gnus-sum-thread-tree-single-indent "◎ ")
(setq gnus-sum-thread-tree-root "● ")
(setq gnus-sum-thread-tree-false-root "☆")
(setq gnus-sum-thread-tree-vertical "│")
(setq gnus-sum-thread-tree-leaf-with-other "├─► ")
(setq gnus-sum-thread-tree-single-leaf "╰─► ")
;; --8<-------------------------- §separator§ ------------------------>8--
;; 时间显示
(add-hook 'gnus-article-prepare-hook 'gnus-article-date-local) ;将邮件的发出时间转换为本地时间
(add-hook 'gnus-select-group-hook 'gnus-group-set-timestamp) ;跟踪组的时间轴
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode) ;新闻组分组
;; All headers that do not match this regexp will be hidden
(setq gnus-visible-headers
      (mapconcat 'regexp-quote
                 '("From:" "Newsgroups:" "Subject:" "Date:"
                   "Organization:" "To:" "Cc:" "Followup-To" "Gnus-Warnings:" "Reply-To:"
                   "Summary:" "Keywords:" "BCc:" "GCc:" "FCc:" "Posted-To:" "Mail-Copies-To:"
                   "Mail-Followup-To:" "Apparently-To:" "Gnus-Warning:" "Resent-From:"
                   "X-Sent:" "X-URL:" "User-Agent:" "X-Newsreader:"
                   "X-Mailer:" "Reply-To:" "X-Spam:" "X-Spam-Status:" "X-Now-Playing" "X-Gnus-Delayed:"
                   "X-Attachments" "X-Diagnostic")
                 "\\|"))
;; Specify the order of the header lines
(setq gnus-sorted-header-list '("^From:" "^Subject:" "^Summary:" "^Keywords:" "^Newsgroups:" "^Followup-To:" "^To:" "^Cc:" "^Date:" "^User-Agent:" "^X-Mailer:" "^X-Newsreader:"))
;; --8<-------------------------- §separator§ ------------------------>8--
(setq gnus-group-sort-function '(gnus-group-sort-by-alphabet gnus-group-sort-by-unread))
;; on the fly spell checking
(add-hook 'message-mode-hook (lambda () (flyspell-mode 1)))
;; --8<-------------------------- §separator§ ------------------------>8--
;; How to save articles
(setq gnus-default-article-saver 'gnus-summary-save-in-file)
;; article configuration
;; set mail the default mail sorting rules
(add-hook 'gnus-select-group-hook 'set-dynamic-thread-sort-functions)
(defun set-dynamic-thread-sort-functions ()
  (if (string= gnus-newsgroup-name "nnfolder:mail.sent.mail")
      (setq gnus-thread-sort-functions '((not gnus-thread-sort-by-number)))
    (setq gnus-thread-sort-functions
          '(gnus-thread-sort-by-author (not gnus-thread-sort-by-date)))
    ))
(setq gnus-use-cache 'passive)
(setq gnus-asynchronous 't) ;;异步操作
;; --8<-------------------------- §separator§ ------------------------>8--
(gnus-delay-initialize) ;; support sending messages with delay mechanism
(setq gnus-delay-default-delay "1d")
;;when start gnus, open the specific group, before fetching news/mails
;;(gnus-fetch-group "nndraft:delayed")
;; 显示设置
(setq mm-text-html-renderer 'w3m) ;用W3M显示HTML格式的邮件
;; Do not use the html part of a message, use the text part if possible!
(setq mm-discouraged-alternatives '("text/html" "text/richtext"))
(setq mm-inline-large-images t) ;显示内置图片
(auto-image-file-mode t) ;自动加载图片
(setq mm-inline-text-html-with-images t)
(setq mm-w3m-safe-url-regexp nil)
;; (setq mm-w3m-safe-url-regexp
;; (concat "\\(\\`cid:\\|"
;; "\\`http://www\\.shopex\\.com\\|"))
;;(add-to-list 'mm-attachment-override-types "image/*") ;附件显示图片
;; --8<-------------------------- §separator§ ------------------------>8--
;; hook bbdb to gnus
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-message)
(add-hook 'message-setup-hook 'bbdb-define-all-aliases)
;; --8<-------------------------- §separator§ ------------------------>8--
;; 加载随机签名
(load-file (concat DENNY_CONF "/emacs_conf/signature-motto.el"))
(setq gnus-posting-styles
      '((".*" ; Matches all groups of messages
         (signature get-motto)) ;; 使用随机签名
        ("mail.p0"
         (signature get-motto))
        ((header "from" "sophiazhang8709@126.com\\|bz-zhangchengfeng@163.com\\|06300260051@fudan.edu.cn\\|sophiazhang8709@gmail.com")
         (signature get-motto))))
;; --8<-------------------------- §separator§ ------------------------>8--
;; category mails by bbdb group, which is defined by bbdb alias
(defun category-gnus-mail-by-bbdb-alias()
  (let (mail-alias-group net-list)
    (dolist (mail-alias (bbdb-get-mail-aliases))
      ;; get email address list by mail alias
      (setq net-list (mapconcat '(lambda(mail) (concat "From:.*" mail))
                                (get-net-list-by-mail-alias (car mail-alias))
                                "\\|"))
      ;; set the mail filter rule
      (setq mail-alias-group mail-alias)
      (add-to-list 'mail-alias-group net-list t)
      ;; append the rule to nnmail-split-methods
      (setq nnmail-split-methods (cons mail-alias-group nnmail-split-methods))
      ))
  )
;;　category pop3 mails
(setq nnmail-split-methods
      '(("mail.junk" "From:.*editors.Chinese@dowjones.com.*\\|Subject:.*糯米网.*\\|Subject:.*《华尔街日报》中文网.*\\|Subject:.*Rent the Runway.*\\|Subject:.*去哪儿网.*")
        ("mail.ci.success" "Subject:.*Successful.*\\|Subject:.*Fixed.*")
        ("mail.ci.fail" "Subject:.*Fail.*")
        ("Daily_Journal" "Subject:.*Emacs Daily Journal.*")
        ("myself" "From:.*markfilebat@126.com.*\\|From:.*zhangwei@shopex.cn.*")
        ("mail.shopex" "From:.*shopex.*")
        ("mail.misc" "")))
;; category mails by bbdb group
(category-gnus-mail-by-bbdb-alias)
;; category imap mails
;; --8<-------------------------- §separator§ ------------------------>8--
(gnus-compile) ;编译一些选项, 加快速度
(setq gnus-default-charset 'utf-8)
(setq gnus-article-charset 'utf-8)
(add-to-list 'gnus-group-charset-alist
             '("\\(^\\|:\\)cn\\>\\|\\<chinese\\>" utf-8))
(setq gnus-summary-show-article-charset-alist
      '((1 . utf-8)
        (2 . big5)
        (3 . gbk)
        (4 . utf-7)))
;; --8<-------------------------- §separator§ ------------------------>8--
;; store news and mails which are sent into mail.sent.news and mail.sent.mail respectively
(setq gnus-message-archive-group
      '((if (message-news-p)
            "nnfolder:mail.sent.news"
          "nnfolder:mail.sent.mail")))
;; --8<-------------------------- §separator§ ------------------------>8--
;;set expiration time for mails to be deleted
(setq nnmail-expiry-wait 3)
;; --8<-------------------------- §separator§ ------------------------>8--
(defun gnus-send-groupmail-by-template (name-mail-list subject mail-content from-mail marker)
  "send group mails based on template.
 We send mails to each recipient a mail with subject and
 content specified by the variables of subject and mail-content.
 Before sending mails, we replace the marker in mail-content by the recipient's name.
 name-mail-list containing names should be a list of two-element lists,
 in the format (\"Name\" \"email address\").
"
  (dolist (name-mail-entry name-mail-list)
    (compose-mail (nth 1 name-mail-entry) ;; to address
                  subject
                  `(("From" . ,from-mail)) ;; all other headers
                  nil nil nil nil) ;; don't remember
    (insert mail-content)
    ;; move to the beginning of buffer, and perform in replacement
    (goto-char (point-min))
    (perform-replace marker (nth 0 name-mail-entry) nil nil nil) ; insert name
    (message-send-and-exit)))
(defun gnus-send-template-mail()
  "Parse current buffer as a mail template, then send mails by send-groupmail-by-mailbuffer."
  (interactive)
  (save-excursion
    (let (start-point end-point string-temp
                      (to-marker "To: ") (subject-marker "Subject: ")
                      (from-marker "From: ") (content-marker "--text follows this line--\n")
                      marker (name-mail-list '()) subject mail-content from-mail)
      ;; set default the marker for name replacement
      (setq marker "{name}")
      ;; obtain name and mail address list of recipients by searching: XXX <>
      (goto-char (point-min))
      (search-forward to-marker nil nil)
      (setq start-point (point))
      (forward-line 1)
      (backward-char 1)
      (setq end-point (point))
      (setq string-temp (buffer-substring-no-properties start-point end-point))
      ;; obtain name list
      (setq name-mail-list
            (mapcar (lambda (x)
                      (list (let ((name (replace-regexp-in-string "<\.*>" "" x)))
                              (bbdb-string-trim (replace-regexp-in-string "\"" "" name)))
                            (let ((net x))
                              (bbdb-string-trim (replace-regexp-in-string ">" "" (replace-regexp-in-string "\.*<" "" net))))))
                    (split-string string-temp ",")))
      ;; Obtain subject by searching: Subject: XXX
      (goto-char (point-min))
      (search-forward subject-marker nil nil)
      (setq start-point (point))
      (forward-line 1)
      (backward-char 1)
      (setq end-point (point))
      (setq subject (buffer-substring-no-properties start-point end-point))
      ;; Obtain from by searching: From: XXX
      (goto-char (point-min))
      (search-forward from-marker nil nil)
      (setq start-point (point))
      (forward-line 1)
      (backward-char 1)
      (setq end-point (point))
      (setq from-mail (buffer-substring-no-properties start-point end-point))
      ;; Obtain mail content by searching: --text follows this line--
      (goto-char (point-min))
      (search-forward content-marker nil nil)
      (setq start-point (point))
      (setq end-point (point-max))
      (setq mail-content (buffer-substring-no-properties start-point end-point))
      ;; send mails based on template
      (gnus-send-groupmail-by-template name-mail-list subject mail-content from-mail marker)
      )
    )
  )
;; --8<-------------------------- §separator§ ------------------------>8--
;; search content of gnus mails
;; (cd ~/backup/essential/Dropbox/private_data/gnus_data/Mail && swish-e -i . -f ../index.swish -e -v 2)
(require 'nnir)
(setq nnir-search-engine 'swish-e)
(setq nnir-swish-e-index-files (list (expand-file-name (concat mail-parent-directory-var "index.swish"))))
;; --8<-------------------------- §separator§ ------------------------>8--
;; (setq display-time-use-mail-icon t) ;;use an icon as mail indicator in modeline
;; (setq gnus-demon-timestep 20)
;; (gnus-demon-add-handler 'gnus-group-get-new-news 2 t)
;; (gnus-demon-add-handler 'gnus-demon-scan-news 2 t)
;; (gnus-demon-add-handler 'gnus-demon-scan-mail 2 t)
;; (gnus-demon-init)
;; (defadvice gnus-demon-scan-news (around gnus-demon-timeout activate)
;; "Timeout for Gnus."
;; (with-timeout (30 (message "Gnus timed out.")) ad-do-it))
;; ;; --8<-------------------------- §separator§ ------------------------>8--
;; (load-file (concat EMACS_VENDOR "/gnus-notify/gnus-desktop-notify.el"))
;; (require 'gnus-desktop-notify)
;; (gnus-desktop-notify-mode)
;; (gnus-demon-add-scanmail)
;; (load-file (concat EMACS_VENDOR "/gnus-notify/gnus-notify+.el"))
;; (require 'gnus-notify+)
;; (add-hook 'gnus-summary-exit-hook 'gnus-notify+)
;; (add-hook 'gnus-group-catchup-group-hook 'gnus-notify+)
;; (add-hook 'mail-notify-pre-hook 'gnus-notify+)
;; (setq gnus-notify+-timeout 40)
;; --8<-------------------------- §separator§ ------------------------>8--
(setq gnus-novice-user nil) ;; no confirmation is required
;; --8<-------------------------- §separator§ ------------------------>8--
(defun check-from-mail ()
  "Check whether I am sending from company's email adress, when coping with work stuff"
  (interactive)
  (save-excursion
    (let ((working-mail "@shopex.cn")
          (confirm-msg "Are you sure sending from markfilebat@126.com for shopex emails? Press C-g to stop")
          )
      (goto-char (point-min))
      (when (search-forward-regexp (regexp-quote working-mail) nil t)
        ;; make sure we are senging from company's email address
        (goto-char (point-min))
        (unless (search-forward-regexp (format "\\(From: .*%s\\)" working-mail) nil t)
          (yes-or-no-p confirm-msg))
        ))
    ))
(add-hook 'message-send-mail-hook 'check-from-mail)
(defun confirm-for-delayed-mail ()
  "Ask for confirmation, before sending delayed mail"
  (interactive)
  (save-excursion
    (if (string= gnus-newsgroup-name "nndraft:delayed")
        (yes-or-no-p "Are you sure to sending this delayed mail? Press C-g to stop"))
    ))
(add-hook 'message-send-mail-hook 'confirm-for-delayed-mail)
;; --8<-------------------------- §separator§ ------------------------>8--
(define-key gnus-summary-mode-map "d" '(lambda()
                                         (interactive)
                                         (gnus-summary-delete-article 1)
                                         (forward-line 1)))
;; --8<-------------------------- §separator§ ------------------------>8--
;; score down any mails which I don't like
(setq gnus-use-adaptive-scoring t)
(setq gnus-score-expiry-days 14)
(setq gnus-default-adaptive-score-alist
      '((gnus-unread-mark)
        (gnus-ticked-mark (from 4))
        (gnus-dormant-mark (from 5))
        (gnus-saved-mark (from 20) (subject 5))
        (gnus-del-mark (from -2) (subject -5))
        (gnus-read-mark (from 2) (subject 1))
        (gnus-killed-mark (from 0) (subject -3))))
(setq gnus-score-decay-constant 1)
(setq gnus-score-decay-scale 0.03)
(setq gnus-decay-scores t)
;; Use a global score file to filter some spam mails
(setq gnus-global-score-files (list (concat mail-parent-directory-var "all.SCORE")))
;; all.SCORE contains:
;;(("xref"
;; ("gmane.spam.detected" -1000 nil s)))
(setq gnus-summary-expunge-below -999)
;; Increase the score for followups to a sent article.
(add-hook 'message-sent-hook 'gnus-score-followup-article)
(add-hook 'message-sent-hook 'gnus-score-followup-thread)
;; --8<-------------------------- §separator§ ------------------------>8--
(setq mail-source-delete-incoming 30) ;; Keep a backup of the received mails for 30 days
(setq mail-source-delete-old-incoming-confirm 't) ;; ask for confirmation before deleting old mails
(setq nnmail-expiry-wait 35) ;; Expireable articles will be deleted after 35 days.
;; --8<-------------------------- §separator§ ------------------------>8--
(setq message-generate-headers-first t)
;; When composing a mail, start the auto-fill-mode.
(add-hook 'message-mode-hook 'turn-on-auto-fill)
;; --8<-------------------------- §separator§ ------------------------>8--
;; Use the gnus registry
(setq gnus-registry-install 't)
(require 'gnus-registry)
(gnus-registry-initialize)
;; --8<-------------------------- §separator§ ------------------------>8--
;; (setq message-kill-buffer-on-exit t)
;; --8<-------------------------- §separator§ ------------------------>8--
;; File: gnus-setting.el ends here
