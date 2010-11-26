From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 26 Nov 2010 20:01:37 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:57960 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0KZTBj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:01:39 -0500
In-Reply-To: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Wed, 24 Nov 2010, Jan Engelhardt wrote:

> By request of Pablo, I am posting the Xtables2 Netlink interface 
> specification for review. Additionally, further documentation and 
> toolchain around it is available through the temporary project page at
> 
> 	http://jengelh.medozas.de/projects/xtables/
> 
> which currently includes
> 
>  * User Documentation Chapter 1: Architectural Differences
> 
>  * Developer Documentation Part 1: Netlink interface (WIP)
>    This is copied below to facilitate inline replies
> 
>  * Runnable Linux source tree
> 
>  * Runnable userspace library (libnetfilter_xtables)
>    with small test-and-debug program
[...]

Please add fine-grained error reporting to the protocol: in my opinion the 
main shortcoming of the current kernel-userspace xtables protocol is the 
lack of the proper error reporting. I mean, the new protocol should be 
able to carry back which rule caused the error, in the rule whether it was 
a general kind of error (ENOMEM), or a table, chain, match or target error 
and exactly what was the error at table/chain/match/target level.

Say, the TCPMSS target should be able to report back that it cannot be 
used outside of FORWARD, OUTPUT and POSTROUTING. Or that the rule must 
match TCP SYN packets.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
