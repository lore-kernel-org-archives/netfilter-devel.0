Return-Path: <SRS0=UdzR=75=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A66C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jun 2020 09:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6181D20707
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jun 2020 09:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgFPJdo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jun 2020 05:33:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40393 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFPJdn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jun 2020 05:33:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id r15so2322571wmh.5
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 02:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=zpLID4YVy99yNU8FoRKsFZL6OOUH6vw32URgB2OXjnk=;
        b=qCM69h+e1sddn19c6noYhYZ38XYykQw4hTxVp9f4jlmtKFpgap4MAj42KXsrtVacTW
         XWkps2KcPbIiExxrUasBcBwm5Ixp/V0rEaX5YdpX+A079SpaOR4TeqcCVlxz5kNThg0g
         3ysUOWUgK6bKUzNZvr5O56+vccvPawwZHh+Prrq5rXf3+2p7onl6LlhHqFMQseRei0L1
         jWoTIfk2rOWy6f8rwL0V5Rm2pC8/yi1gHaP3VxkX14bXdmnMKswdxVcn9CzwiZsGZNaG
         tuycX1KI9rg098xNDN5oCL7m177yMwsEFyPnfjyKFbIliV8tijSxUZkBXyzYGn0IyWgR
         Kbkg==
X-Gm-Message-State: AOAM532U3q62bg+0d7uSLnuuvEC744CSKUsedHOmCkDWlyrPCxXMMc+/
        Hep7BQT77PdQkkLGhbDtd7IrcmRkz/dvVg==
X-Google-Smtp-Source: ABdhPJyMTtHetdwGJPW+JC6TEDa6NLDy34fQArnPDR1gmdXFk45OQLzhRP58y+qZ9g9MC6BWNWRIjA==
X-Received: by 2002:a1c:9d53:: with SMTP id g80mr2360948wme.13.1592300021373;
        Tue, 16 Jun 2020 02:33:41 -0700 (PDT)
Received: from localhost (217.216.74.49.dyn.user.ono.com. [217.216.74.49])
        by smtp.gmail.com with ESMTPSA id w1sm3065614wmi.13.2020.06.16.02.33.40
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 02:33:40 -0700 (PDT)
Subject: [iptables PATCH] xtables-translate: don't fail if help was requested
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Tue, 16 Jun 2020 11:33:39 +0200
Message-ID: <159230001954.62609.10203108901931558446.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the user called `iptables-translate -h` then we have CMD_NONE and we should gracefully handle
this case in do_command_xlate().

Before this patch, you would see:

 user@debian:~$ sudo iptables-translate -h
 [..]
 nft Unsupported command?
 user@debian:~$ echo $?
 1

After this patch:

 user@debian:~$ sudo iptables-translate -h
 [..]
 user@debian:~$ echo $?
 0

Fixes: d4409d449c10fa ("nft: Don't exit early after printing help texts")
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 iptables/xtables-translate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 5aa42496..363c8be1 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -249,7 +249,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 
 	cs.restore = restore;
 
-	if (!restore)
+	if (!restore && p.command != CMD_NONE)
 		printf("nft ");
 
 	switch (p.command) {
@@ -310,6 +310,9 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		break;
 	case CMD_SET_POLICY:
 		break;
+	case CMD_NONE:
+		ret = 1;
+		break;
 	default:
 		/* We should never reach this... */
 		printf("Unsupported command?\n");

