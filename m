From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: iptables release plans
Date: Mon, 21 Mar 2011 22:09:58 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1103212207450.23334@blackhole.kfki.hu>
References: <4D879D96.2000904@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:46747 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab1CUVKA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:10:00 -0400
In-Reply-To: <4D879D96.2000904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 21 Mar 2011, Patrick McHardy wrote:

> About a potential iptables release for 2.6.38 - we don't have any
> new features in the kernel that would require a new release.
> However we've had a lot of other changes that would be good to
> get out for wider testing.
> 
> Unfortunately due some confusion at the time of the last kernel
> release, all patches for the upcoming feature in 2.6.39 have been
> added to the master branch. I don't want to release extensions
> for new kernel features while we're in the -rc phase since we
> might still decide to change the userspace API.
> 
> So the options basically are:
> 
> - branch off the current HEAD, remove all new extension for upcoming
>   features and release that branch
> 
> - skip the release for 2.6.38
> 
> Any opinions?

I don't really like either one, but if we have to choose then the first 
one seems better. At least the release will contain the bugfixes.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
