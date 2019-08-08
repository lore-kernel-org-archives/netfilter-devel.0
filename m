Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7897EC0650F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 05:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 577D72089E
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 05:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbfHHFnb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 01:43:31 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:52936 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726187AbfHHFnb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 01:43:31 -0400
Received: from mr4.cc.vt.edu (smtp.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x785hTH8023835
        for <netfilter-devel@vger.kernel.org>; Thu, 8 Aug 2019 01:43:29 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        by mr4.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x785hOGo020546
        for <netfilter-devel@vger.kernel.org>; Thu, 8 Aug 2019 01:43:29 -0400
Received: by mail-qt1-f198.google.com with SMTP id f28so84623315qtg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Aug 2019 22:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=c6yvSjRSPSPtd7WKVRhn/33mlt2UI1aeE4hr0QgnAWg=;
        b=KttXjyFgz9k+tOEHHawJa9YpEwjs5jukWpAH9ZtFTkjV1TsZVZ8aCf6LBJ6yghAa3P
         FLFJ/k5KWEQ2Bu/KdxwDVMwzfODZO26iJVPhneCZ5BRtMW3uQYrG1VDOheVk8MDPvxRt
         5h54qzxb/JQem1zDggYkR55Q6n/KMkjuelQtILZAukZaw0Lc8fguR+2qcl8PCYSQTegX
         g5RjLx3wypzPLVEhqmXu1X8Khi47BLoBiMeyhuGwjRNwO1XWSXyTRdRPNdl/96+tc783
         AfZwEdz/edrleJhJ8IPsGDN/zNdSouw/Y2rD+4cRPQDl9KQuQALV4oHGtzt1xLdPHW1F
         FZ8A==
X-Gm-Message-State: APjAAAWb5BfwR/Psl2/zPQJ+uP3ZUTvRxFgbDC/ScaMJ1XbwZMwY4rvo
        oEoLHB5iGfNfeKoFOaB+5BXLFstCoR+uodWVxGzfseaVYSrgFhYnSUVVtg4ZZurX3ZhoHy4AmjV
        4RAUZU2bQmEZ//uy5nMtviJUslz4Xnyu1kU8/l6s=
X-Received: by 2002:a37:dcc7:: with SMTP id v190mr12012688qki.169.1565243004366;
        Wed, 07 Aug 2019 22:43:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzKldRnyI5SL9XuBns9hAd6WuyGhSYe29+X/2gQVf84YuCE8HdYQj3/BaWF8ziX92uInHbLyQ==
X-Received: by 2002:a37:dcc7:: with SMTP id v190mr12012675qki.169.1565243004139;
        Wed, 07 Aug 2019 22:43:24 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::359])
        by smtp.gmail.com with ESMTPSA id h18sm36284621qkj.134.2019.08.07.22.43.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 22:43:23 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/netfilter/nf_nat_proto.c - make tables static
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Thu, 08 Aug 2019 01:43:22 -0400
Message-ID: <55481.1565243002@turing-police>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sparse warns about two tables not being declared.

  CHECK   net/netfilter/nf_nat_proto.c
net/netfilter/nf_nat_proto.c:725:26: warning: symbol 'nf_nat_ipv4_ops' was not declared. Should it be static?
net/netfilter/nf_nat_proto.c:964:26: warning: symbol 'nf_nat_ipv6_ops' was not declared. Should it be static?

And in fact they can indeed be static.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 7ac733ebd060..0a59c14b5177 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -722,7 +722,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
-const struct nf_hook_ops nf_nat_ipv4_ops[] = {
+static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	/* Before packet filtering, change destination */
 	{
 		.hook		= nf_nat_ipv4_in,
@@ -961,7 +961,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
-const struct nf_hook_ops nf_nat_ipv6_ops[] = {
+static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	/* Before packet filtering, change destination */
 	{
 		.hook		= nf_nat_ipv6_in,

