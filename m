From: =?ISO-8859-15?Q?Kadlecsik_J=F3zsef?=
	<kadlecsik.jozsef@wigner.mta.hu>
Subject: Re: [PATCH] ipset tool: Fix link with libtool >= 2.4.4
Date: Sat, 9 Jan 2016 21:13:19 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1601092112550.19537@mentat.kfki.hu>
References: <1452122469-22209-1-git-send-email-dev@blino.org> <alpine.DEB.2.10.1601070847180.15530@blackhole.kfki.hu> <m3bn8xsh0i.fsf@euphor.blino.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Olivier Blin <dev@blino.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:39775 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbcAIUTV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jan 2016 15:19:21 -0500
In-Reply-To: <m3bn8xsh0i.fsf@euphor.blino.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 7 Jan 2016, Olivier Blin wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> writes:
> 
> > On Thu, 7 Jan 2016, Olivier Blin wrote:
> >
> >> This is a simple patch to fix link of ipset with latest libtool
> >> versions.
> >
> > Is the patch compatible with non-latest libtool versions?
> 
> I have tested this with libtool 2.4.2 and 2.4.6 versions, ipset builds
> fine with both.
> 
> The only downside is that -ldl is now passed twice with older libtool
> versions, but this should not be a problem.

The patch is applied, thank you.

Best regards,
Jozsef
--
E-mail : kadlecsik.jozsef@wigner.mta.hu
PGP key: http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address: Wigner Research Centre for Physics, Hungarian Academy of Sciences
         H-1525 Budapest 114, POB. 49, Hungary
