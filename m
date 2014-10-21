From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP LAST ACK incorrectly treated as invalid
Date: Tue, 21 Oct 2014 22:49:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410212248510.938@blackhole.kfki.hu>
References: <CAC=w+U7t8K2yjKtj7NDfS-xrCLRxoZ_hPxBU=EiD57v+eQnCMA@mail.gmail.com> <alpine.DEB.2.10.1410210852310.27469@blackhole.kfki.hu> <CAC=w+U5v6oj0zJFTZvjPomyf+pFdFCJrXgdWVG7QQDuttuhC1g@mail.gmail.com> <alpine.DEB.2.10.1410212037070.32297@blackhole.kfki.hu>
 <CAC=w+U7h2njKOB74XwP-C-Y37kcTDLKw2vGCUuK+afzCueqpQg@mail.gmail.com> <alpine.DEB.2.10.1410212228290.741@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: vDev <vijaypas@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:53224 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095AbaJUUtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:49:13 -0400
In-Reply-To: <alpine.DEB.2.10.1410212228290.741@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 21 Oct 2014, Jozsef Kadlecsik wrote:

> On Tue, 21 Oct 2014, vDev wrote:
> 
> > OK. Here it is. Please look for III=0 and subsequent res=0.
> 
> This is not the dump of the TCP stream. Please send a tcpdump recording!

And do not send it as an ascii dump but as a pcap file...

Best regards,
Joysef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
