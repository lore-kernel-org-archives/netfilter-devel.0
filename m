From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Target extension with nf_hooks
Date: Sun, 11 Nov 2012 14:36:27 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211111434430.6241@nerf07.vanv.qr>
References: <CAGuaRCtEa2VGPb3-jYvuK9+t++L44xTeOm15xpsFXmzLHoui3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:46385 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2KKNg3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Nov 2012 08:36:29 -0500
In-Reply-To: <CAGuaRCtEa2VGPb3-jYvuK9+t++L44xTeOm15xpsFXmzLHoui3g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2012-11-11 11:56, Aft nix wrote:
>
>static struct xt_target obsf_tg_reg __read_mostly = {
>
>        .name = "OBSF",
>        .family = NFPROTO_UNSPEC,
>        .target = obsf_tg,
>        .checkentry = obsf_tg_check,
>        .targetsize = sizeof(struct xt_OBSF_tginfo),
>        .me = THIS_MODULE,
>};
>
>static struct nf_hook_ops inward_obsf_ops __read_mostly = {
>    .pf = NFPROTO_IPV4,
>    .priority = 1,
>    .hooknum = NF_INET_PRE_ROUTING,
>    .hook = ibss_obsf_inward_begin,
>};
>
>a) Between ibss_obsf_inward_begin() and obsf_tg() who will be called first?

The filter,mangle,etc. tables all have a specific and different priority
assigned (git grep NF_IP_PRI_ include/).
