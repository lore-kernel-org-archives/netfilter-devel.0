From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Fri, 4 Jul 2008 22:49:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807042236340.4142@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu>
 <200807031044.37410.ludwig.nussel@suse.de> <Pine.LNX.4.64.0807031504180.1816@blackhole.kfki.hu>
 <200807041553.41535.ludwig.nussel@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48538 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbYGDUtZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:49:25 -0400
In-Reply-To: <200807041553.41535.ludwig.nussel@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 4 Jul 2008, Ludwig Nussel wrote:

> Do you have any plans to also support ipv6?

Yes! A major rewriting of ipset is ongoing, with the following goals:

+ (nf)netlink as communication channel instead of sockopt
+ library-based userspace tool with flexible input and output interfaces
+ IPv6 support
+ besides single (IP address) and double (IP+port) data storage,
  new set types with triples (IP+port+IP)
+ linear set type with other sets as elements ("union" of sets)
+ timeout support, possibly for every set type
- bindings as a dead end will be dropped

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
