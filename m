Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D75C636D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Feb 2023 17:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbjBURTx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 12:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbjBURTq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 12:19:46 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D590265A6
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 09:19:45 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id d7so5038649qtr.12
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 09:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=59sQ4IQ/6RpMzL0t46+GlUGXNHnLnzIjaaSJWU0/3To=;
        b=LQ2nUrdqGRWtfX/2/YkpWvALBgOQjZ4rxVsvInAn+pKuFoHK/25uS8gQkrdoTAKxnZ
         bPD739Fc5GsmzAnIv8mWqr/KsrJG2jL0g71Q+vJwXJxh24OW7sY5i3rFJ0RzN2/9vkuo
         IvXkPN89lJ/3DFWhaz38fSuAx267S7kEOkxxW7A2Nt+wEL0RO1tmI7yY94QoZmOZqPJI
         rXZn31YXV9A2y4PT71pbAFJm8NYGqGEfz7JAOuc50F/w4ShfLEKcwFCLFR7e5snzqScD
         uNjgpdliFzzGaZ0eGXlHD2YOrriaG6YArVEObXilOsU33zYpyNvNXa6PGLNsc7+4lYMX
         Ggmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=59sQ4IQ/6RpMzL0t46+GlUGXNHnLnzIjaaSJWU0/3To=;
        b=BE4ORcqBWSNXNr1ihoWrAxEaOb9jCiXE1emCslloSJmL+FwgWwne0Mxw6TPiX14iT/
         peTMpN28QoAzLRSs6vQTK5Oku3Udh3gQzIiggJb51cUcKnI4Uig4eBeDr0cSH+CBckj2
         aRHM/8WIegHUbAnAAqsrvDuBjMfiIhHerzJpUAdi7/IAM4AthLdC8XdRjBP/OCWuff7x
         sfA0+cWcIgVcSUVQNGgo3aCtIbOJ+mGEw+8s2zxznB/I1nMBjgbjP+cNu3sNabnJnAJN
         fzAJ9nUPs/tEv7Bs4QyXOncQSu03CmjxmgUXr/jXzVC0OVJVh7rgQ/BHoQVh7mEVM2TF
         z/Kw==
X-Gm-Message-State: AO0yUKVg7vuryGoBxMBNaFIL8/Ub098wDm5RzxuUPILZNlHkk+TNo6oW
        urHSoWD9jmPVX+4QR/sxQ4kIuIjG5CtAww==
X-Google-Smtp-Source: AK7set/LEc3Tld37rL0UncaokvG5eAXyM0Z/efR3Rlwjeg8hksT+x5k6azz3qRrgQX3FtV8+MW4VXA==
X-Received: by 2002:ac8:5c82:0:b0:3b8:67c4:b11d with SMTP id r2-20020ac85c82000000b003b867c4b11dmr23289158qta.49.1676999984059;
        Tue, 21 Feb 2023 09:19:44 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c8-20020ac80548000000b003ba19e53e43sm1142818qth.25.2023.02.21.09.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 09:19:43 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Yuxuan Luo <luoyuxuan.carl@gmail.com>
Subject: [PATCH iptables] xt_sctp: add the missing chunk types in sctp_help
Date:   Tue, 21 Feb 2023 12:19:42 -0500
Message-Id: <dc19760b55dfa9a91171bfecc316ba1592959f27.1676999982.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add the missing chunk types in sctp_help(), so that the help cmd can
display these chunk types as below:

  # iptables -p sctp --help

  chunktypes - ... I_DATA RE_CONFIG PAD ... I_FORWARD_TSN ALL NONE

Fixes: 6b04d9c34e25 ("xt_sctp: support a couple of new chunk types")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 extensions/libxt_sctp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index fe5f5621..6e2b2745 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -50,7 +50,7 @@ static void sctp_help(void)
 " --dport ...\n" 
 "[!] --chunk-types (all|any|none) (chunktype[:flags])+	match if all, any or none of\n"
 "						        chunktypes are present\n"
-"chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK FORWARD_TSN ALL NONE\n");
+"chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE I_DATA RE_CONFIG PAD ASCONF ASCONF_ACK FORWARD_TSN I_FORWARD_TSN ALL NONE\n");
 }
 
 static const struct option sctp_opts[] = {
-- 
2.39.1

