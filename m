From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter kernel modules question
Date: Mon, 14 Dec 2009 21:17:07 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912142115290.14355@obet.zrqbmnf.qr>
References: <4B2657B7.5070405@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tobias Koeck <tobias.koeck@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58361 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758171AbZLNURJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:17:09 -0500
In-Reply-To: <4B2657B7.5070405@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-12-14 16:20, Tobias Koeck wrote:

> I have two netfilter kernel modules (xt_RQS.c, xt_RQD.c, both include a header
> file with a data structure in it).
>
> Does both kernel modules use the same datastructures or do they use seperate
> ones (in normal C programming I know that but I'm not sure about the kernel
> scopes).

You decide whether they do. This does not change just because you are in 
kernel space.



Jan

