From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Target extension with nf_hooks
Date: Sun, 11 Nov 2012 18:15:09 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211111802590.6241@nerf07.vanv.qr>
References: <CAGuaRCtEa2VGPb3-jYvuK9+t++L44xTeOm15xpsFXmzLHoui3g@mail.gmail.com> <alpine.LNX.2.01.1211111434430.6241@nerf07.vanv.qr> <CAGuaRCsgOhwaUf8Pn+gu=axd7O1M4tYPoBje_gMT+LmQzMeNOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:47018 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab2KKRPP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Nov 2012 12:15:15 -0500
In-Reply-To: <CAGuaRCsgOhwaUf8Pn+gu=axd7O1M4tYPoBje_gMT+LmQzMeNOw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2012-11-11 15:47, Aft nix wrote:
>
>Thanks for the reply. Now mangle tables has this:
>
>include/uapi/linux/netfilter_ipv4.h:    NF_IP_PRI_MANGLE = -150,
>
>What i get from this list that which table will get priority.
>
>But i'm trying to know which function will be called first?

The one with a lower numerical value.
What is to happen when two hooks have the same priority value
is unspecified.

>But i'm still confused about which function (one registered with
>struct xt_target , another registered with struct nf_hook_ops) will
>get priority?

Those are two very different things.

>How does a table associated with different chains?

