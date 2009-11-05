From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Problem with ipset on sparc64
Date: Thu, 5 Nov 2009 09:31:08 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911050924280.13373@blackhole.kfki.hu>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net> <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Chini, Georg (HP App Services)" <georg.chini@hp.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:55972 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZKEIbF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:31:05 -0500
In-Reply-To: <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 4 Nov 2009, Jan Engelhardt wrote:

> On Wednesday 2009-11-04 22:50, Chini, Georg (HP App Services) wrote:
> >>
> >>I'm using ipset 3.2 on a sparc64 system (ultra2), kernel 2.6.31.5, Debian 5.
> >>Everything works fine, but the -L option shows strange values for a portmap.
> >
> >
> >If you explicitly compile ipset as a 64-bit program rather than the
> >32-bit default that is used on sparc, will the correct values be
> >shown?
> >
> >Thanks for the fast reply. I added -m64 to cc and ld options and
> >recompiled. Is that correct? If yes, I now get a bus error instead
> >of a wrong listing. Or do I have to change anything else?
> 
> Bus error means something was not quite correctly aligned
> (yet another ipset bug).
> 
> The lack of cheap access to big-endian, alignment-sensitive hardware
> means many codes do not get the testing they deserve :-/

Yes, that's exaxtly. Funnily enough a few years ago I toyed the idea to 
buy a thrown out SPARCCenter2000 but I didn't have enough power in my 
place to boot up such a machine...
 
> To workaround the alignedness issue, you could take an x86_64 machine
> and compile a strictly 32-bit ipset on it, and see whether the values
> are also off.

I'll work on fixing the bug.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
