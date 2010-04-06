From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Prerouting hook doesn't "see" all packets
Date: Wed, 7 Apr 2010 01:28:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004070122000.31132@obet.zrqbmnf.qr>
References: <y2yefcd93941004061610n9f6b0a90lec0209b794d5bc14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: K-Gen <alphakgen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48840 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757695Ab0DFX2T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:28:19 -0400
In-Reply-To: <y2yefcd93941004061610n9f6b0a90lec0209b794d5bc14@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-04-07 01:10, K-Gen wrote:

>Hi there.
>I'm trying to see TCP packets passing through a router using a
>netfilter module (in order to eventually alter them).
>
>I have a hook on PREROUTING, and it doesn't quite work as expected.
>The only packets I see, are the TCP handshake (3 packets). Any packets
>in an established connection do not get to my hook.
>The TCP connections in question all pass via NAT before reaching my
>hook. I've thus given my hook the priority NF_IP_PRI_LAST.
>I've tried setting nfcache to NFC_UNKNOWN for every TCP packet, and
>this didn't help.
>
>The kernel version on the router is 2.6.8.1, the router itself is
>based on a BCM board. I did not try to the same on another machine.

The stable series did not exist before 2.6.11, so 2.6.8.1 did not 
exist. Assuming you meant 2.6.8, I'd say it's time to update.

nfcache is long gone.

>I'm obviously doing something wrong, so please tell my why is this happening.

You need to post your code, because we don't have magic orbs (let alone 
that, if such existed, the law would probably prohibit their use for 
obvious reasons of unwanted privacy invasion).
