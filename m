From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: helpers register for a specific port, but work anyway
Date: Thu, 28 Feb 2008 10:42:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802281039430.14348@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0802271528310.15321@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802271534551.12047@blackhole.kfki.hu>
 <Pine.LNX.4.64.0802271758460.5388@fbirervta.pbzchgretzou.qr>
 <47C59A08.9080802@trash.net> <Pine.LNX.4.64.0802272346160.5388@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802280814270.14171@blackhole.kfki.hu>
 <Pine.LNX.4.64.0802281012020.4324@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:49490 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031AbYB1JmL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:42:11 -0500
In-Reply-To: <Pine.LNX.4.64.0802281012020.4324@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 28 Feb 2008, Jan Engelhardt wrote:

> >> >> The 300 proto=6 line comes from conntrack -E --- but if nf_conntrack_ftp
> >> >> does not parse streams to port 2121 by default, how could it have
> >> >> set up the expectation?
> >> >
> >> > When NATing packets the helper lookup is repeated based
> >> > on the final tuple.
> >> 
> >> But the machine I am running conntrack -E and ftp from do not
> >> see the NATting taking place higher up in the routing chain, do they?
> >
> >You had to load the nf_conntrack_ftp module on the client machine too.
> >By which module parameters was it loaded?
> 
> The module was certainly loaded, otherwise `conntrack -E` would
> not have printed anything.
> No parameters were specified, just `modprobe nf_conntrack_ftp`,
> like I said. There is no way it should have analyzed port 2121 ftp.

Any long forgotten nf_conntrack_ftp related option setting under 
/etc/modprobe.d/ or in /etc/modprobe.conf?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
