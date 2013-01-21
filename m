From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next] iptables: add xt_bpf match
Date: Mon, 21 Jan 2013 12:42:20 +0100
Message-ID: <20130121114220.GB8541@breakpoint.cc>
References: <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
 <1358529450-32413-1-git-send-email-willemb@google.com>
 <20130121112838.GA2907@1984>
 <20130121113328.GA3698@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51150 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544Ab3AULmV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:42:21 -0500
Content-Disposition: inline
In-Reply-To: <20130121113328.GA3698@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 21, 2013 at 12:28:38PM +0100, Pablo Neira Ayuso wrote:
> > Hi Willem,
> > 
> > I have applied this patch to my nf-next tree with minor changes.

[..]

> diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
> index 08f555f..8b4bd36 100644
> --- a/include/uapi/linux/netfilter/Kbuild
> +++ b/include/uapi/linux/netfilter/Kbuild
> @@ -35,6 +35,7 @@ header-y += xt_TCPOPTSTRIP.h
>  header-y += xt_TEE.h
>  header-y += xt_TPROXY.h
>  header-y += xt_addrtype.h
> +header-y += xt_bpf.h

Good catch. I forgot about that too, so xt_connlabel.h is also missing.
