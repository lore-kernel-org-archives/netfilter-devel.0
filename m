Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5495EC43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 11:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BF5321530
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 11:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfFULKZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 07:10:25 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42310 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbfFULKZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 07:10:25 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1heHQz-0007LI-Kl; Fri, 21 Jun 2019 13:10:21 +0200
Date:   Fri, 21 Jun 2019 13:10:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     =?utf-8?Q?=C4=B0brahim?= Ercan <ibrahim.metu@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Is this possible SYN Proxy bug?
Message-ID: <20190621111021.2nqtvdq3qq2gbfqy@breakpoint.cc>
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc>
 <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc>
 <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
 <20190618124026.4kvpdkbstdgaluij@breakpoint.cc>
 <CAK6Qs9nak4Aes9BXGsHC8SGGXmWGGrhPwAPQY5brFXtUzLkd-A@mail.gmail.com>
 <CAK6Qs9=E9r_hPB6QX+P5Dx+fGetM5pcgxBsrDt+XJBeZhUcimQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK6Qs9=E9r_hPB6QX+P5Dx+fGetM5pcgxBsrDt+XJBeZhUcimQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

İbrahim Ercan <ibrahim.metu@gmail.com> wrote:
> I modified your patch as below and now synproxy send mss values as it
> should be. Soom I will test it on real environment.
> I also have another question. When I don't provide --wscale option,
> both client syn-ack an server syn packets have empty wscale. When I
> don't provide --mss option, I realized firewall not set mss value on
> client syn-ack, but it sets mss on server syn. Is that what suppose to
> happen?

The SYN sent to server should reflect/match the SYN received from
client (mss might be smaller due to msstab encoding).

> diff -rupN a/net/ipv4/netfilter/ipt_SYNPROXY.c
> b/net/ipv4/netfilter/ipt_SYNPROXY.c
> --- a/net/ipv4/netfilter/ipt_SYNPROXY.c       2019-06-19
> 09:51:40.163633231 +0300
> +++ b/net/ipv4/netfilter/ipt_SYNPROXY.c      2019-06-20 13:32:18.893025129 +0300
> @@ -71,13 +71,13 @@ free_nskb:
>  static void
>  synproxy_send_client_synack(struct net *net,
>                             const struct sk_buff *skb, const struct tcphdr *th,
> -                           const struct synproxy_options *opts)
> +                           const struct synproxy_options *opts, const
> u16 *client_mssinfo)
>  {
>         struct sk_buff *nskb;
>         struct iphdr *iph, *niph;
>         struct tcphdr *nth;
>         unsigned int tcp_hdr_size;
> -       u16 mss = opts->mss;
> +       u16 mss = *client_mssinfo;

Yes, something like this is needed, i.e. we need to pass two
mss values -- one from info->mss ("server") that we need to
place in the tcp options sent to client and one containing
the clients mss that we should encode into the cookie.

I think you can pass "u16 client_mssinfo" instead of u16* pointer.
