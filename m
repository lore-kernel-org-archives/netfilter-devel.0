From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: -p udp marking tcp packets ?
Date: Sun, 3 May 2009 18:08:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905031806430.5046@blackhole.kfki.hu>
References: <beb91d720905012257h51bcb936v3326c13bd57e707e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33321 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZECQI7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2009 12:08:59 -0400
In-Reply-To: <beb91d720905012257h51bcb936v3326c13bd57e707e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2 May 2009, Salatiel Filho wrote:

> i was having a strange behaviour marking packets in a new and updated
> router with kernel 2.6.29 and iptables 1.4.3 using an old script ,
> while it worked just fine on an old router.
> Trying to debug i found out this:
> 
> # iptables  -p udp -t mangle -A PREROUTING -m state --state NEW -j LOG
[...] 
> In the logs i can see: [Why are TCP packets being marked by that rule ?]

What about all the other tables (filter, nat, raw)? Isn't there any 
logging rule in them? Why don't you add a log prefix, which would 
identify the logging rule?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
