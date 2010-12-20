From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-5: buncha patches
Date: Mon, 20 Dec 2010 13:16:06 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012201315330.13904@blackhole.kfki.hu>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:59407 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab0LTMQI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:16:08 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 19 Dec 2010, Jan Engelhardt wrote:

> The following changes since commit 06366c172c487b3038b52e8fe640747b4092a544:
> 
>   Prevent calling Makefile directly in the kernel/ subdirectory (2010-12-19 00:56:03 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/ipset master
> 
> Jan Engelhardt (11):
>       build: enable parallel building
>       xt_set: avoid user types in exported kernel headers
>       kernel: do not mix const and __read_mostly
>       kernel: use __read_mostly for registration-type structures
>       kernel: const annotations
>       kernel: use EXPORT_SYMBOL_GPL  (suggesting)
>       libipset: ipset_strncpy is really a strlcpy-type operation
>       libipset: remove redundant indirection via union name
>       libipset: remove redundant casts
>       libipset: const annotations
>       libipset: static annotations

Pulled and pushed, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
