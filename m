Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F14C48BE9
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 12:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38EBA2133F
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 12:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="huspOoeZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbfFXM2V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 08:28:21 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33252 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbfFXM2V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 08:28:21 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so109181iop.0
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jun 2019 05:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=iHhEopAtJJY/WNHGWVIoZ5OVrcQ0mpcYvwXCwwMai5E=;
        b=huspOoeZ0GDK7q9wPXg4eYRZZV333XSQZOxrrXp9lqXCsmxlJ2SYX+G9xX/XH4n9Fi
         0V4ggeSOgH7YFXIlIL4XtBrY2QXddp7srbqcW0WDGIoMG9i1ZlepWfiBueI8cRUQ1GVb
         kZseZEj/YRyG/yCuY8Dd1xhEwUDEMRqu3hMW/judHZ9iEwMkBJl8x7TvoaB/6vgp+hsz
         Z2nC+kc+yu11ydydHgNfqu7TwXmH9X1WrkMPBCdjPPXfE+49vMNT/ONdzCgi7sqSlkdX
         ECDcMRMVz8DH4WUg8dzmy5msRxCVPu0FtYCe2iXpGcGmMfl0Hd+JGeHclHHUy3dNLB9P
         RG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=iHhEopAtJJY/WNHGWVIoZ5OVrcQ0mpcYvwXCwwMai5E=;
        b=mjKsIdXIbqWlDK/fKx7X1N+SQJhOjBpRzcRO3A5kU3SiPLfF4LXoKO+wDMnBU3pzpk
         0jJFLJeI3yqYEHFcJqs+GkTzj+L++f/jaMyFOId1TyqcnTiB+F7ojiPGn1JfsDnFLjAF
         /5z1Mp73DvOohl9mhBUKS6zCTEqqz1SP114h7734CymuCEFQ0cBISkiEiN08iI8esgaM
         e6apoa+LPRobQOI4EoG7Yc0hI5JRZg+CpPR/Zeio53haZxG7J1LU5WRLmDmWffbYqa8g
         SMj81BB+uSz3H1xAwT+EM452ACSk2kMrh810Ia/JweRjQJqGF6hRaOMmbAY/1RgNjvCR
         NYgw==
X-Gm-Message-State: APjAAAU5dQAo77xmzkBa0rj/pUMHjcPYslnNLhW7dx9FowmXSNvJMAY9
        lmhAzsGK6FNSetDqaN9+tr7Q1tDPG6298aze22mlDnGcCsI=
X-Google-Smtp-Source: APXvYqzt6nBuGii6vR037Q1tDqgWW4pR7bxz1jsuwWSTGsfLVm7HLYP+I9ZvHYXCOYuhvpDSU9JCye2HlfOnoD7Q2ek=
X-Received: by 2002:a02:c00f:: with SMTP id y15mr16266648jai.132.1561379298959;
 Mon, 24 Jun 2019 05:28:18 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Mon, 24 Jun 2019 15:28:07 +0300
Message-ID: <CAK6Qs9k_bdU9ZL4WRXBGYdtfnP_qhot0hzC=uMQG6C_pkz3+2w@mail.gmail.com>
Subject: [PATCH] netfilter: synproxy: erroneous TCP mss option fixed.
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Syn proxy isn't setting mss value correctly on client syn-ack packet.

It was sending same mss value with client send instead of the value
user set in iptables rule.
This patch fix that wrong behavior by passing client mss information
to synproxy_send_client_synack correctly.

Signed-off-by: Ibrahim Ercan <ibrahim.metu@gmail.com>

diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c
b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 64d9563..e0bd504 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -69,13 +69,13 @@ synproxy_send_tcp(struct net *net,
 static void
 synproxy_send_client_synack(struct net *net,
                            const struct sk_buff *skb, const struct tcphdr *th,
-                           const struct synproxy_options *opts)
+                           const struct synproxy_options *opts, const
u16 client_mssinfo)
 {
        struct sk_buff *nskb;
        struct iphdr *iph, *niph;
        struct tcphdr *nth;
        unsigned int tcp_hdr_size;
-       u16 mss = opts->mss;
+       u16 mss = client_mssinfo;

        iph = ip_hdr(skb);

@@ -264,6 +264,7 @@ synproxy_tg4(struct sk_buff *skb, const struct
xt_action_param *par)
        struct synproxy_net *snet = synproxy_pernet(net);
        struct synproxy_options opts = {};
        struct tcphdr *th, _th;
+       u16 client_mssinfo;

        if (nf_ip_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
                return NF_DROP;
@@ -283,6 +284,8 @@ synproxy_tg4(struct sk_buff *skb, const struct
xt_action_param *par)
                        opts.options |= XT_SYNPROXY_OPT_ECN;

                opts.options &= info->options;
+               client_mssinfo = opts.mss;
+               opts.mss = info->mss;
                if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
                        synproxy_init_timestamp_cookie(info, &opts);
                else
@@ -290,7 +293,7 @@ synproxy_tg4(struct sk_buff *skb, const struct
xt_action_param *par)
                                          XT_SYNPROXY_OPT_SACK_PERM |
                                          XT_SYNPROXY_OPT_ECN);

-               synproxy_send_client_synack(net, skb, th, &opts);
+               synproxy_send_client_synack(net, skb, th, &opts,
client_mssinfo);
                consume_skb(skb);
                return NF_STOLEN;
        } else if (th->ack && !(th->fin || th->rst || th->syn)) {
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c
b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 41325d5..676de53 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -83,13 +83,13 @@ synproxy_send_tcp(struct net *net,
 static void
 synproxy_send_client_synack(struct net *net,
                            const struct sk_buff *skb, const struct tcphdr *th,
-                           const struct synproxy_options *opts)
+                           const struct synproxy_options *opts, const
u16 client_mssinfo)
 {
        struct sk_buff *nskb;
        struct ipv6hdr *iph, *niph;
        struct tcphdr *nth;
        unsigned int tcp_hdr_size;
-       u16 mss = opts->mss;
+       u16 mss = client_mssinfo;

        iph = ipv6_hdr(skb);

@@ -278,6 +278,7 @@ synproxy_tg6(struct sk_buff *skb, const struct
xt_action_param *par)
        struct synproxy_net *snet = synproxy_pernet(net);
        struct synproxy_options opts = {};
        struct tcphdr *th, _th;
+       u16 client_mssinfo;

        if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
                return NF_DROP;
@@ -297,6 +298,8 @@ synproxy_tg6(struct sk_buff *skb, const struct
xt_action_param *par)
                        opts.options |= XT_SYNPROXY_OPT_ECN;

                opts.options &= info->options;
+               client_mssinfo = opts.mss;
+               opts.mss = info->mss;
                if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
                        synproxy_init_timestamp_cookie(info, &opts);
                else
@@ -304,7 +307,7 @@ synproxy_tg6(struct sk_buff *skb, const struct
xt_action_param *par)
                                          XT_SYNPROXY_OPT_SACK_PERM |
                                          XT_SYNPROXY_OPT_ECN);

-               synproxy_send_client_synack(net, skb, th, &opts);
+               synproxy_send_client_synack(net, skb, th, &opts,
client_mssinfo);
                consume_skb(skb);
                return NF_STOLEN;
