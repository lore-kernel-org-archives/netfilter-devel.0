From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/13] hash:ip set type support
Date: Tue, 01 Feb 2011 15:39:19 +0100
Message-ID: <4D481B17.5060600@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-4-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-5-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-6-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-7-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43437 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab1BAOjV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:39:21 -0500
In-Reply-To: <1296514388-20900-7-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:53, schrieb Jozsef Kadlecsik:
> The module implements the hash:ip type support in four flavours:
> for IPv4 or IPv6, both without and with timeout support.
> 
> All the hash types are based on the "array hash" or ahash structure
> and functions as a good compromise between minimal memory footprint
> and speed. The hashing uses arrays to resolve clashes. The hash table
> is resized (doubled) when searching becomes too long. Resizing can be
> triggered by userspace add commands only and those are serialized by
> the nfnl mutex. During resizing the set is read-locked, so the only
> possible concurrent operations are the kernel side readers. Those are
> protected by RCU locking.
> 
> Because of the four flavours and the other hash types, the functions
> are implemented in general forms in the ip_set_ahash.h header file
> and the real functions are generated before compiling by macro expansion.
> Thus the dereferencing of low-level functions and void pointer arguments
> could be avoided: the low-level functions are inlined, the function
> arguments are pointers of type-specific structures.

Applied, thanks Jozsef.
