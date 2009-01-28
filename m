From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: install patch-o-matic on fedora10
Date: Wed, 28 Jan 2009 17:14:35 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901281711530.20921@fbirervta.pbzchgretzou.qr>
References: <E1LSBtG-0006O1-2y@web07.mi6.kiev.ua>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Alex Ivanov <handler@ua.fm>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36448 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZA1QOg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:14:36 -0500
In-Reply-To: <E1LSBtG-0006O1-2y@web07.mi6.kiev.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2009-01-28 15:59, Alex Ivanov wrote:

>Hello!
>I download patch-o-matic-20031219.tar.bz2, unpack it
>To do:
>./runme extra
>Hey! KERNEL_DIR is not set.
>Where is your kernel? [/usr/src/linux]  /usr/src/kernels/2.6.27.5-117.fc10.i686/
>Testing... nth.patch ALREADY APPLIED (0 rejects out of 2 hunks).


You seem to be stuck in a temporal vortex, may I help you out
by mentioning the presence of
/lib/modules/$VERSION/kernel/net/netfilter/xt_statistic.ko :-)
