From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP LAST ACK incorrectly treated as invalid
Date: Tue, 21 Oct 2014 20:39:56 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410212037070.32297@blackhole.kfki.hu>
References: <CAC=w+U7t8K2yjKtj7NDfS-xrCLRxoZ_hPxBU=EiD57v+eQnCMA@mail.gmail.com> <alpine.DEB.2.10.1410210852310.27469@blackhole.kfki.hu> <CAC=w+U5v6oj0zJFTZvjPomyf+pFdFCJrXgdWVG7QQDuttuhC1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: vDev <vijaypas@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CAC=w+U5v6oj0zJFTZvjPomyf+pFdFCJrXgdWVG7QQDuttuhC1g@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 21 Oct 2014, vDev wrote:

> Thanks, Jozsef. I see sequence number compensation in
> segment_seq_plus_len() but does that not cover the ACK sequence
> numbers. The variables (sack and receiver->td_end) are off by 1. It
> seems like receiver->td_end must be incremented by 1 for last ACK.
> Here's a trace:
> 
> [  775.980000] seq=726609914 ack=94044192+(0) sack=94044192+(0)
> win=14600 end=726609914
> [  775.980000] tcp_in_window: sender end=726609914 maxend=726611414
> maxwin=14600 scale=0 receiver end=94044191 maxend=94058791 maxwin=1500
> scale=0
> [  775.980000] tcp_in_window: I=1 II=1 III=0 IV=1
> [  775.980000] tcp_in_window: res=0 sender end=726609914
> maxend=726611414 maxwin=14600 receiver end=94044191 maxend=94058791
> maxwin=1500
> 
> As you can see above sack is 94044192 and receiver end is 94044191. As
> a result III is 0 and res=0 which causes -NF_ACCEPT to be returned.

It's a single packet, it doesn't tell anything about the TCP stream.
A full TCP stream dump is required from the very first SYN to the very 
last packet.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
