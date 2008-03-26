From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Transfer stalls with NAT under 2.6.24.3
Date: Wed, 26 Mar 2008 19:45:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803261941460.1905@blackhole.kfki.hu>
References: <47EA0DAB.7080205@securenet.de> <47EA1653.3080300@trash.net>
 <47EA2399.1080201@securenet.de> <47EA7023.3000405@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sven Riedel <sr@securenet.de>, netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:38919 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbYCZSpg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:45:36 -0400
In-Reply-To: <47EA7023.3000405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 26 Mar 2008, Patrick McHardy wrote:

> > During a run with stalls:
> > 
> > nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN= OUT=
> > SRC=100.100.100.100 DST=200.200.200.200 LEN=80 TOS=0x00 PREC=0x00 TTL=56
> > ID=44105
> > DF PROTO=TCP SPT=22 DPT=35858 SEQ=4160349927 ACK=596614326 WINDOW=49248
> > RES=0x00 ACK URGP=0 OPT
> > (0101080A4558793C1B13CE350101051A491E8751491E8CA9491E7B71491E81F9491E40A9491E5B61) 
> > 
> Thanks, can you send a binary tcpdump (... -w file) of a connection
> that triggers these messages please?

Yes, a tcpdump of a full session which is stalled could help a lot.

But it almost look like as a SACK related problem: isn't there a (new) 
device between the communicating parties which performs ISN randomization 
and fails to adjust SACK?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
