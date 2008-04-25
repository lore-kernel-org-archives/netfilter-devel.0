From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Invalid SACK numbers in NAT'ed packets
Date: Fri, 25 Apr 2008 11:02:29 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0804251059510.5340@blackhole.kfki.hu>
References: <funk78$srq$1@ger.gmane.org> <Pine.LNX.4.64.0804232126040.28881@blackhole.kfki.hu>
 <00c101c8a5ea$d83213f0$5101a8c0@csltd.intranet>
 <Pine.LNX.4.64.0804241130040.30382@blackhole.kfki.hu>
 <006b01c8a6b1$884da030$5101a8c0@csltd.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Leonid Zeitlin <lz@csltd.com.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:56684 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYDYJCb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:02:31 -0400
In-Reply-To: <006b01c8a6b1$884da030$5101a8c0@csltd.intranet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 25 Apr 2008, Leonid Zeitlin wrote:

> It appears that short of writing a custom netfilter extension, there's no way
> to turn off SACKs on a particular connection. Is this right?

Yes, exactly. Actually, writing a new extension to erase any TCP option 
isn't that hard: just replace the option with noop and recalculate the 
checksum.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
