From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [1/2] ipset 3.0 changes audit: printf types
Date: Thu, 28 May 2009 10:23:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905281019480.26723@blackhole.kfki.hu>
References: <alpine.LSU.2.00.0905271400540.26986@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:44365 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724AbZE1IXW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2009 04:23:22 -0400
In-Reply-To: <alpine.LSU.2.00.0905271400540.26986@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Wed, 27 May 2009, Jan Engelhardt wrote:

> today I looked at the changes introduced by 3.0, and noticed a few bits 
> that warranted patches.
[...]

Thanks, I pulled all of your patches.

I'm going to release a new version at the weekend because 

a. I "successfully" broke the iptables set/SET match and target by 
   the new protocol version in ipset
b. This is a good opportunity to get rid of the deprecated functionality 
   (binding) and adding forward-compatibility in the match and target.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
