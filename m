From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP LAST ACK incorrectly treated as invalid
Date: Thu, 23 Oct 2014 10:04:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410230948180.11401@blackhole.kfki.hu>
References: <CAC=w+U7t8K2yjKtj7NDfS-xrCLRxoZ_hPxBU=EiD57v+eQnCMA@mail.gmail.com> <alpine.DEB.2.10.1410210852310.27469@blackhole.kfki.hu> <CAC=w+U5v6oj0zJFTZvjPomyf+pFdFCJrXgdWVG7QQDuttuhC1g@mail.gmail.com> <alpine.DEB.2.10.1410212037070.32297@blackhole.kfki.hu>
 <CAC=w+U7h2njKOB74XwP-C-Y37kcTDLKw2vGCUuK+afzCueqpQg@mail.gmail.com> <alpine.DEB.2.10.1410212228290.741@blackhole.kfki.hu> <alpine.DEB.2.10.1410212248510.938@blackhole.kfki.hu> <CAC=w+U6j+V6zLvdVBQKYjBSRq6YXshLPzXyg3G-NYZvk23CCEQ@mail.gmail.com>
 <alpine.DEB.2.10.1410222039170.7882@blackhole.kfki.hu> <CAC=w+U5K_=-o9t3Q=E_n12XoHuZG77Wm-VUgymU4qbtmG9vjnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: vDev <vijaypas@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:51340 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaJWIDm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:03:42 -0400
In-Reply-To: <CAC=w+U5K_=-o9t3Q=E_n12XoHuZG77Wm-VUgymU4qbtmG9vjnw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 22 Oct 2014, vDev wrote:

> Thanks, Jozsef. Attached is the new packet capture and trace with patch 
> applied.

Thanks, now packets and conntrack states can be compared.

Up to packet 6 everything is normal. However, look at packet 7:

16:20:21.653783 IP (tos 0x0, ttl 52, id 24152, offset 0, flags [DF],
    proto TCP (6), length 40)
    Remote_Server.63001 > Linux_Router.1039: Flags [F.], cksum 0x567b 
    (correct), seq 3661860393, ack 2561327135, win 14600, length 0

This is the first FIN packet, and the kernel debug log says:

[  376.950000] tcp_packet: 
[  376.950000] dir=1, seq=3661860393 ack=2561327135 win=14600 end=3661860394
[  376.950000] tcp_conntracks: 
[  376.950000] syn=0 ack=1 fin=1 rst=0 old=3 new=4

The previous conntrack state is in "old=3", i.e. 
TCP_CONNTRACK_ESTABLISHED. The new=4 means TCP_CONNTRACK_FIN_WAIT. However 
between

[  376.950000] tcp_packet:
[  376.950000] dir=1, seq=3661860393 ack=2561327135 win=14600 end=3661860394

and

[  376.950000] tcp_conntracks:
[  376.950000] syn=0 ack=1 fin=1 rst=0 old=3 new=4

there is a missing the call to tcp_in_window()! Therefore the internal 
counters of conntrack is not updated and later packets won't match the 
wrong internal states.

Why the call to tcp_in_window() is missing? Looking at tcp_packet(), 
there's nothing which could cause skipping it: the big switch about the 
new_state does not divert the handling of TCP_CONNTRACK_FIN_WAIT.

So, what's your kernel version number? You have got the source:
please post net/netfilter/nf_conntrack_proto_tcp.c

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
