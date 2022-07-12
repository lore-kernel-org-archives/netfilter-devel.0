Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5747C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jul 2022 20:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiGLUtS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 16:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiGLUtR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 16:49:17 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538A9252AA
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2022 13:49:16 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id k7-20020a17090a62c700b001ef9c16ba10so80795pjs.1
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2022 13:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cuvq4bUWwZbFcbUnzZRr8NI/5HR3fBjcZcaAmfqVlFU=;
        b=aEc24jtNuGsFPRPw10yY+5J9BC4+vKg5SgzAyA5BOyeeAZtp1qVYQuov9ZQE9tVSbq
         OyVFIkB4pTY9mG42431wVtIjYTTcusxsK4JI63nPZTrMa9FB+es4cpteK1w3F/lvIR5E
         QUUl+GUxAxs1n4gyikaBH7XIWARwYDpWsOxBz7uXOWFTCwvO4X0+TE2/i8ucGrOa9SF0
         jilaHXW3a+P3hllpuVwfzpRwD/HCeKL9nFtnuCnULaVz6oSEGrXpaG4E7fWRV9n8PjnH
         Ffz+KnvuTlWzBFFrew6SPbOMLvQ7lxyiYlzMa2JTPXsLxDSFijK571xoMS0T7pkQ8+Um
         aQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cuvq4bUWwZbFcbUnzZRr8NI/5HR3fBjcZcaAmfqVlFU=;
        b=qNVDk1nGHt6TrYLj48qh3DjMRJduXQ91p2mk3VBlYJS24CiaC7nHgA+PqDZ1K5BxTR
         M6DBopyMK/jZqq+dZZUla0Fdij/jSQJM0O3NLKJf7jLz7M9JWrASMoHAJPDo/acOsIop
         zjheUhj/jQaOfp6JqNSfAv2X09/7IBaQDMxG/WUGs0tFn6sMXDEh8wfhVUU3H/aIxWoI
         ziwfxqb9Ze1leIfAYhbxW/iCF/f2hR7KxBV4o4SyhR9DIzUChl6bKL/EkV6fi8erf+Ki
         1D006xM6T+2qXX1HM16dNE7vAIzfLAvOC6mq7u2UM/k90Xh7CYV6/QP7oInRvsKEi165
         oxYg==
X-Gm-Message-State: AJIora9rWCKsZqF2NfUkAsmlDMH6U3WO6PjC8AYssf4pzSKrpWrj+DeK
        F2ngZ97vdwjOZbbimClsYt51E4Y1A3EFe5yDiQ==
X-Google-Smtp-Source: AGRyM1tbq3ODEHrZNuPHyvvTyeeSArRQcxH/uOHsUPcJw0jQTZ/lUTlEFAAhYIuV6hDuQsMcDrDKTmKIu8fb3tMhoQ==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:b1e8:210d:ae12:d0df])
 (user=justinstitt job=sendgmr) by 2002:a05:6a00:a26:b0:528:9831:d935 with
 SMTP id p38-20020a056a000a2600b005289831d935mr24956851pfh.25.1657658955901;
 Tue, 12 Jul 2022 13:49:15 -0700 (PDT)
Date:   Tue, 12 Jul 2022 13:49:00 -0700
In-Reply-To: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X>
Message-Id: <20220712204900.660569-1-justinstitt@google.com>
Mime-Version: 1.0
References: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2] netfilter: xt_TPROXY: remove pr_debug invocations
From:   Justin Stitt <justinstitt@google.com>
To:     nathan@kernel.org
Cc:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, justinstitt@google.com, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, ndesaulniers@google.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, trix@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pr_debug calls are no longer needed in this file.

Pablo suggested "a patch to remove these pr_debug calls". This patch has
some other beneficial collateral as it also silences multiple Clang
-Wformat warnings that were present in the pr_debug calls.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
diff from v1 -> v2:
* converted if statement one-liner style
* x == NULL is now !x

 net/netfilter/xt_TPROXY.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 459d0696c91a..e4bea1d346cf 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -74,18 +74,10 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~mark_mask) ^ mark_value;
-
-		pr_debug("redirecting: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
-			 iph->protocol, &iph->daddr, ntohs(hp->dest),
-			 &laddr, ntohs(lport), skb->mark);
-
 		nf_tproxy_assign_sock(skb, sk);
 		return NF_ACCEPT;
 	}
 
-	pr_debug("no socket, dropping: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
-		 iph->protocol, &iph->saddr, ntohs(hp->source),
-		 &iph->daddr, ntohs(hp->dest), skb->mark);
 	return NF_DROP;
 }
 
@@ -122,16 +114,12 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	int tproto;
 
 	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0) {
-		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
+	if (tproto < 0)
 		return NF_DROP;
-	}
 
 	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
-	if (hp == NULL) {
-		pr_debug("unable to grab transport header contents in IPv6 packet, dropping\n");
+	if (!hp)
 		return NF_DROP;
-	}
 
 	/* check if there's an ongoing connection on the packet
 	 * addresses, this happens if the redirect already happened
@@ -168,19 +156,10 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
-
-		pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
-			 tproto, &iph->saddr, ntohs(hp->source),
-			 laddr, ntohs(lport), skb->mark);
-
 		nf_tproxy_assign_sock(skb, sk);
 		return NF_ACCEPT;
 	}
 
-	pr_debug("no socket, dropping: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
-		 tproto, &iph->saddr, ntohs(hp->source),
-		 &iph->daddr, ntohs(hp->dest), skb->mark);
-
 	return NF_DROP;
 }
 
-- 
2.37.0.144.g8ac04bfd2-goog

