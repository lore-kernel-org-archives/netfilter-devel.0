Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA0EC43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 07:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41A7E2083B
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 07:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cVEVVMe6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfFUHA4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 03:00:56 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:43438 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfFUHAz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 03:00:55 -0400
Received: by mail-io1-f45.google.com with SMTP id k20so675054ios.10;
        Fri, 21 Jun 2019 00:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SBasg8DMzjFC6lQRRDdVqEvvkpbJO6cMApM3DmpaFo4=;
        b=cVEVVMe6pmUmSVz+K2VQLjq8u7mwda56AWXFYshd9pRGPYCgA/Ce34BIqJkDS/s9at
         8kVMwZlgFgQweVWRRiB16SuPBrGqJwBeIsSbHZfYKTHSIWWIsBO7jdREkEfxYBTAB67i
         tQuRcxsaXRB3AsRr5EvV42BzsEAWB6POXoWH38iwtKpnCOi8n8r/fFjO0D+PLQ2lzEjE
         eXkpt9HF+x1onY5ySUnj1JrJLv3toxXCghU0xCh0VaqrYphNCVi48bg4RvbcUBV8wOHj
         edcsYECIGlNYNGZt8uIN0kd7QQTZ498ohs6Ci3uMV65Bi8mgot8Y4ctDENL1NAZWva1V
         GW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SBasg8DMzjFC6lQRRDdVqEvvkpbJO6cMApM3DmpaFo4=;
        b=bVfCZNcHCoromNpHiemzjOjSBaO5ACqSP5qE7R0Ay+w9wNaoKigevKu/tmvnHZ3lfn
         qb8hm47lXyuCRO0p6PhjBUWJwJ24OLSmxhXOGUyR0neNU4St4QPF8DUiPnyeV52HTXve
         WVes5B4cRoKF2EArAx0b3BEFN4/uIZlza7qWqB1UCRmOr2Go6ikj3PBGl+iinc5khePi
         zUHeUHQMez9YzUCq6iLzW9HnfPpxy1UCQDuWg+qF6Vl7mkRlVIGetAKRTK48N0iEnDbj
         0F2ACrSvGy//C7c6GeMeDKmRog0FwpvzB+h8OHSyKyWMNcqL+514tPPZXo4zUY0FI7za
         sTxQ==
X-Gm-Message-State: APjAAAWeOyQIUovxN3hAm4Lb/RtXJO3joEEhMZapoykQqMpc7gt/xjSy
        1wb55cy7SZPQAN4/eHEHQ716HPS65nio7AbykWlcVro+HPE=
X-Google-Smtp-Source: APXvYqz1Jj/Q98dIicwc8gtbhc45ODf2rY+WFTo9W0/F0b+5nD2D2ukcxGn2Rx3zVWJqGUhjwlEtH/rVd6T0GE3GhJE=
X-Received: by 2002:a6b:7401:: with SMTP id s1mr36330732iog.67.1561100454856;
 Fri, 21 Jun 2019 00:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc> <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc> <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
 <20190618124026.4kvpdkbstdgaluij@breakpoint.cc> <CAK6Qs9nak4Aes9BXGsHC8SGGXmWGGrhPwAPQY5brFXtUzLkd-A@mail.gmail.com>
In-Reply-To: <CAK6Qs9nak4Aes9BXGsHC8SGGXmWGGrhPwAPQY5brFXtUzLkd-A@mail.gmail.com>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Fri, 21 Jun 2019 10:00:43 +0300
Message-ID: <CAK6Qs9=E9r_hPB6QX+P5Dx+fGetM5pcgxBsrDt+XJBeZhUcimQ@mail.gmail.com>
Subject: Re: Is this possible SYN Proxy bug?
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi again.
I modified your patch as below and now synproxy send mss values as it
should be. Soom I will test it on real environment.
I also have another question. When I don't provide --wscale option,
both client syn-ack an server syn packets have empty wscale. When I
don't provide --mss option, I realized firewall not set mss value on
client syn-ack, but it sets mss on server syn. Is that what suppose to
happen?

diff -rupN a/net/ipv4/netfilter/ipt_SYNPROXY.c
b/net/ipv4/netfilter/ipt_SYNPROXY.c
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c       2019-06-19
09:51:40.163633231 +0300
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c      2019-06-20 13:32:18.893025129 +0300
@@ -71,13 +71,13 @@ free_nskb:
 static void
 synproxy_send_client_synack(struct net *net,
                            const struct sk_buff *skb, const struct tcphdr *th,
-                           const struct synproxy_options *opts)
+                           const struct synproxy_options *opts, const
u16 *client_mssinfo)
 {
        struct sk_buff *nskb;
        struct iphdr *iph, *niph;
        struct tcphdr *nth;
        unsigned int tcp_hdr_size;
-       u16 mss = opts->mss;
+       u16 mss = *client_mssinfo;

        iph = ip_hdr(skb);
@@ -266,6 +265,7 @@ synproxy_tg4(struct sk_buff *skb, const
        struct synproxy_net *snet = synproxy_pernet(net);
        struct synproxy_options opts = {};
        struct tcphdr *th, _th;
+        u16 client_mssinfo;

        if (nf_ip_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
                return NF_DROP;
@@ -285,6 +285,8 @@ synproxy_tg4(struct sk_buff *skb, const
                        opts.options |= XT_SYNPROXY_OPT_ECN;

                opts.options &= info->options;
+                client_mssinfo = opts.mss;
+               opts.mss = info->mss;
                if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
                        synproxy_init_timestamp_cookie(info, &opts);
                else
@@ -292,7 +294,7 @@ synproxy_tg4(struct sk_buff *skb, const
                                          XT_SYNPROXY_OPT_SACK_PERM |
                                          XT_SYNPROXY_OPT_ECN);

-               synproxy_send_client_synack(net, skb, th, &opts);
+               synproxy_send_client_synack(net, skb, th, &opts,
&client_mssinfo);
                consume_skb(skb);
                return NF_STOLEN;
        } else if (th->ack && !(th->fin || th->rst || th->syn)) {
