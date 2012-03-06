From: Florian Westphal <fw@strlen.de>
Subject: Re: NFQUEUE in bridge mode performance poor in the last kernels
Date: Tue, 6 Mar 2012 22:23:37 +0100
Message-ID: <20120306212337.GA19133@Chamillionaire.breakpoint.cc>
References: <CA+qZnSTG+_5y=6dGFqoJwRj0LxMvr2qtmyvykFjfnVgaYgbNPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: tingwei liu <tingw.liu@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55984 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755634Ab2CFVXi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:23:38 -0500
Content-Disposition: inline
In-Reply-To: <CA+qZnSTG+_5y=6dGFqoJwRj0LxMvr2qtmyvykFjfnVgaYgbNPA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tingwei liu <tingw.liu@gmail.com> wrote:
> In the past few days, I have puzzled by NFQUEUE in bridge mode.
> I have take some test with five kernels.
> 2.6.24.4
> 2.6.36.4
> 2.6.38
> 3.0.8
> 3.1.10
>=20
> The result is : 2.6.24.4,2.6.26.4,2.6.38 have a goog performance;
> 3.0.8 and 3.1.10 have a poor performance.
> Next is copy from suricata maillist(=A0eric@regit.org=A0)
>=20
> I'm having a look at it. There has been some changes between the two
> kernel versions (bringing more performances) but it seems there is so=
me
> side effects with bridge.

Might be the 'gro+nfqueue eats MAC header' problem, you could try
commit a8db7b2d197a0d624baab83f0c810b0edbc4ffd0 (netfilter: nf_queue: f=
ix
queueing of bridged gro skbs). Or, disable gro on all bridge ports via
ethtool -K $device gro off

If its not gro related, please provide more information about your
machine, setup, ... etc.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
