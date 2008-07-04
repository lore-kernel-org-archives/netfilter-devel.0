From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP connection stalls under 2.6.24.7
Date: Fri, 4 Jul 2008 22:58:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807042251500.4142@blackhole.kfki.hu>
References: <47EA0DAB.7080205@securenet.de> <Pine.LNX.4.64.0803261941460.1905@blackhole.kfki.hu>
 <47F08A52.9070802@securenet.de> <200807041654.15591.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Sven Riedel <sr@securenet.de>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:60206 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbYGDU6L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:58:11 -0400
In-Reply-To: <200807041654.15591.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, 4 Jul 2008, Thomas Jarosch wrote:

> we upgraded from kernel 2.6.23.16 to 2.6.24.7 and are now seeing
> stalling (smtp) TCP connections on two boxes. We still have the old kernel
> on a "rescue" partition. If I boot it up, the connections work immediately.
> 
> The connection work fine if the transmitted data is smaller than ~220kb,
> so you still can send small messages. I've sent a tcpdump to Patrick in 
> private as it contained sensitive information. The picture is similar to 
> Sven's issue reported backed in march: Some ACK packets
> are missing (as if the remote side never sent them).
> 
> I downgraded the box to 2.6.24 to make sure it was
> not caused by any -stable patch. Same thing.
> 
> Did any default TCP settings change from 2.6.23.16 to 2.6.24?

A TCP reopening fix was added to 2.6.24, but as it says, the patch affects 
only TCP connection reopening.

> I also tried to disable path MTU discovery, TCP window scaling and
> lowered the MTU of the ppp0 interface to 1400 (DSL connection).
> This had no visible effect.

Have you got SACK enabled? If yes, try to disable it: TCP connection 
tracking has got some trouble with SACK support. :-(
 
> @Sven: Were you able to test 2.6.24.2?
> 
> Patrick suggested to enable nf_conntrack_log_invalid.
> I enabled it via "echo 255 > /proc/sys/net/netfilter/nf_conntrack_log_invalid"
> but that change didn't print anything to syslog.

You have got a netfilter logging module loaded in, don't you? If yes and 
nf_conntrack_log_invalid produces no output, then I'd say it's not a 
netfilter related problem.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
