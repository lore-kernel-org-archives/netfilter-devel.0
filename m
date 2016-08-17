From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/2] xtables-translate: add escape_quotes option
 to comment_xlate
Date: Wed, 17 Aug 2016 16:23:17 +0200
Message-ID: <20160817142317.GA9755@salvia>
References: <20160816174433.28272-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54628 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbcHQOXY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 10:23:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 429BAD1622
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:23:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 30CB29663D
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:23:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01253DA3B0
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:23:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160816174433.28272-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 16, 2016 at 07:44:32PM +0200, Pablo M. Bermudo Garay wrote:
> The comment_xlate function was not supporting this option that is
> necessary in some situations.

I have applied what I'm attaching to this email, that is more simple
than this and makes sure buffer is nul-terminated (given snprintf
doesn't guarantee this).

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

commit 3317b14f0d6fa0e460e4e758b7e3010f940d07bc
Author: Pablo M. Bermudo Garay <pablombg@gmail.com>
Date:   Tue Aug 16 19:44:32 2016 +0200

    xtables-translate: add escape_quotes option to comment_xlate
    
    The comment_xlate function was not supporting this option that is
    necessary in some situations.
    
    Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 0e31edd..b635d16 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -52,9 +52,18 @@ static int comment_xlate(struct xt_xlate *xl,
 			 const struct xt_xlate_mt_params *params)
 {
 	struct xt_comment_info *commentinfo = (void *)params->match->data;
+	char comment[XT_MAX_COMMENT_LEN];
 
 	commentinfo->comment[XT_MAX_COMMENT_LEN - 1] = '\0';
-	xt_xlate_add_comment(xl, commentinfo->comment);
+	if (params->escape_quotes)
+		snprintf(comment, XT_MAX_COMMENT_LEN, "\\\"%s\\\"",
+			 commentinfo->comment);
+	else
+		snprintf(comment, XT_MAX_COMMENT_LEN, "\"%s\"",
+			 commentinfo->comment);
+
+	comment[XT_MAX_COMMENT_LEN - 1] = '\0';
+	xt_xlate_add_comment(xl, comment);
 
 	return 1;
 }

--k+w/mQv8wyuph6w0--
