From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: Add helper array register/unregister functions
Date: Wed, 20 Jul 2016 08:51:17 +0800
Message-ID: <CAML_gOeTMwf2fDTwwJ9MbjPvnSSx8PDxBy55xE+7EMo5yy5UcA@mail.gmail.com>
References: <1468813163-18139-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:32941 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbcGTAvT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 20:51:19 -0400
In-Reply-To: <1468813163-18139-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-07-18 11:39 GMT+08:00  <fgao@ikuai8.com>:
> From: Gao Feng <fgao@ikuai8.com>
>
> Add nf_ct_helper_init, nf_conntrack_helpers_register/unregister
> functions to enhance the conntrack helper codes.

I think this patch is breaking something ...

This irc:
> -               if (ports[i] == IRC_PORT)
> -                       sprintf(irc[i].name, "irc");
> -               else
> -                       sprintf(irc[i].name, "irc-%u", i);
> -
> -               ret = nf_conntrack_helper_register(&irc[i]);
> +               nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, "irc",
> +                                 IRC_PORT, ports[i], &irc_exp_policy, 0, 0,
> +                                 help, NULL, THIS_MODULE);
> +       }

This sip:
> -                       if (ports[i] == SIP_PORT)
> -                               sprintf(sip[i][j].name, "sip");
> -                       else
> -                               sprintf(sip[i][j].name, "sip-%u", i);

And this tftp:
> -                       if (ports[i] == TFTP_PORT)
> -                               sprintf(tftp[i][j].name, "tftp");
> -                       else
> -                               sprintf(tftp[i][j].name, "tftp-%u", i);

For example, if the user install the nf_conntrack_tftp module an
specify the ports to "69,10069",
then the helper name is "tftp" and "tftp-1".

But apply this patch, the helper name will be changed to "tftp" and
"tftp-10069", this may break the
existing iptables rules which used the helper match or CT target.

And this was already discussed  at https://patchwork.ozlabs.org/patch/622238/
