Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AD9C31E49
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 09:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04844206BF
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 09:27:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tm2HLn5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731410AbfFSJ1B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 05:27:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34491 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfFSJ1B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 05:27:01 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so6437398iot.1;
        Wed, 19 Jun 2019 02:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYASPS9gmPkEPb3xpWAp9nTgZ274vq0zsdir5tDgDcY=;
        b=Tm2HLn5/IyE1UqWEI30QLZ4VRNMYO+UVtd83Rz+jvYIOK4ixOn6LRYVUsRAv0hoMhv
         w8ORWEEuNeRR+SAliAYkTulbNW1syJCjwpecm2IiSCog35f+DEIelqoIUC+C/Ib5FMRn
         AfanEjPLjnZDE4QtV9Be+zZSfHPweFDMNCrxH/m0SsNUTqZ/04C1oCeDE56pgkUiC/QX
         0+KrgipHmuVjKnjmudEmu37Sd+Z6K9JRjfSCA6i3AqlqkRZVIcBJ/pWiyEDCibAMQAxv
         WVoTgLqCrXdhjbzLSb9P4xEn7gG3PQuCs8g4xWIHac3XtFNQ1V3l/OwIH/33u7CwFomV
         duzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYASPS9gmPkEPb3xpWAp9nTgZ274vq0zsdir5tDgDcY=;
        b=H8KpyJDweJJOdWwf11gnmnHMEAr4ej9j4ptIAofZri7enawX9AeKYzsMKpv5ckgO8+
         rV2PP7s0FRav5P+i/2oVOvBvTO4nSjUx2ayBSEtouwH2RdwLpKGdoDrlzvSoxzNLGjZY
         FgnVnCjKupKbxuvrsPEcJu4HjElO/Ap00yeHGRC827YnWmHE3GyDZgF8uDLe2jxTLs4M
         p1UlGp3zPQRGq2p5z6HUQM2XS66hfC2axo7L+3cXLdcUjW5M4v/Jkb6MWKQt5sBKbDWM
         aA0nv+U1wOL/pCu45i+vJpRgXzkPkX6Dj9Q7XYCWotfRztqy3mIcQAXGI332dEnPJSaY
         HPVA==
X-Gm-Message-State: APjAAAW6e9OfSPfFe1fjwvCFlP+XmuwW/lyfqqQcn3ns4QR1JQO8mC0G
        sSW6AXxqCtwZTFO/A4cJtt+UkzGNnmdmRjXL07BNUEZfZrtn7g==
X-Google-Smtp-Source: APXvYqwBLavC4njNXnnw8DfHCafH1xcOTzNvDrExVEVslwKmLxkZENmXg6l6jfTsr/+WrC3KztPhg7ljwBF9zAWvXhY=
X-Received: by 2002:a02:85ef:: with SMTP id d102mr9401791jai.63.1560936420187;
 Wed, 19 Jun 2019 02:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc> <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc> <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
 <20190618124026.4kvpdkbstdgaluij@breakpoint.cc>
In-Reply-To: <20190618124026.4kvpdkbstdgaluij@breakpoint.cc>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Wed, 19 Jun 2019 12:26:48 +0300
Message-ID: <CAK6Qs9nak4Aes9BXGsHC8SGGXmWGGrhPwAPQY5brFXtUzLkd-A@mail.gmail.com>
Subject: Re: Is this possible SYN Proxy bug?
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 3:40 PM Florian Westphal <fw@strlen.de> wrote:
>
> Does this patch fix the problem for you?
>
> diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
> --- a/net/ipv4/netfilter/ipt_SYNPROXY.c
> +++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
> @@ -286,6 +286,7 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
>                         opts.options |= XT_SYNPROXY_OPT_ECN;
>
>                 opts.options &= info->options;
> +               opts.mss = info->mss;
>                 if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
>                         synproxy_init_timestamp_cookie(info, &opts);
>                 else
> diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
> --- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
> +++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
> @@ -300,6 +300,7 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
>                         opts.options |= XT_SYNPROXY_OPT_ECN;
>
>                 opts.options &= info->options;
> +               opts.mss = info->mss;
>                 if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
>                         synproxy_init_timestamp_cookie(info, &opts);
>                 else

I applied this patch and did same test with same setup.
On External interface mss value seems correct. But This time on
internal interface firewall set mss value to 1460 on syn packet rather
than 536.
Here is samples.

External
10.0.0.215.60812 > 10.0.1.213.80: Flags [S], seq 1275328749, win
25200, options [mss 1260,sackOK,TS val 183998290 ecr 0,nop,wscale 7],
length 0
10.0.1.213.80 > 10.0.0.215.60812: Flags [S.], seq 584730658, ack
1275328750, win 0, options [mss 1460,sackOK,TS val 193047 ecr
183998290,nop,wscale 2], length 0

Internal
10.0.0.215.60812 > 10.0.1.213.80: Flags [S], seq 1275328749, win 197,
options [mss 1460,sackOK,TS val 183998290 ecr 193047,nop,wscale 7],
length 0
10.0.1.213.80 > 10.0.0.215.60812: Flags [S.], seq 3022386930, ack
1275328750, win 14480, options [mss 1460,sackOK,TS val 101024266 ecr
183998290,nop,wscale 2], length 0
