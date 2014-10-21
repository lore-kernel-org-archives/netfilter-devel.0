From: vDev <vijaypas@gmail.com>
Subject: Re: TCP LAST ACK incorrectly treated as invalid
Date: Tue, 21 Oct 2014 14:48:46 -0500
Message-ID: <CAC=w+U7h2njKOB74XwP-C-Y37kcTDLKw2vGCUuK+afzCueqpQg@mail.gmail.com>
References: <CAC=w+U7t8K2yjKtj7NDfS-xrCLRxoZ_hPxBU=EiD57v+eQnCMA@mail.gmail.com>
	<alpine.DEB.2.10.1410210852310.27469@blackhole.kfki.hu>
	<CAC=w+U5v6oj0zJFTZvjPomyf+pFdFCJrXgdWVG7QQDuttuhC1g@mail.gmail.com>
	<alpine.DEB.2.10.1410212037070.32297@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63846 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaJUTsr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:48:47 -0400
In-Reply-To: <alpine.DEB.2.10.1410212037070.32297@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

OK. Here it is. Please look for III=0 and subsequent res=0.

<7>[ 2238.060000] tcp_new: sender end=4004184065 maxend=4004184065
maxwin=1500 scale=0 receiver end=0 maxend=0 maxwin=0 scale=0
<7>[ 2238.060000] tcp_in_window: START
<7>[ 2238.060000] tcp_in_window:
<7>[ 2238.060000] seq=4004184064 ack=0+(0) sack=0+(0) win=1500 end=4004184065
<7>[ 2238.060000] tcp_in_window: sender end=4004184065
maxend=4004184065 maxwin=1500 scale=0 receiver end=0 maxend=0 maxwin=0
scale=0
<7>[ 2238.060000] tcp_in_window:
<7>[ 2238.060000] seq=4004184064 ack=0+(0) sack=0+(0) win=1500 end=4004184065
<7>[ 2238.060000] tcp_in_window: sender end=4004184065
maxend=4004184065 maxwin=1500 scale=0 receiver end=0 maxend=0 maxwin=0
scale=0
<7>[ 2238.060000] tcp_in_window: I=1 II=1 III=1 IV=1
<7>[ 2238.060000] tcp_in_window: res=1 sender end=4004184065
maxend=4004184065 maxwin=1500 receiver end=0 maxend=1500 maxwin=0
<7>[ 2238.060000] tcp_conntracks:
<7>[ 2238.060000] syn=1 ack=0 fin=0 rst=0 old=0 new=1
<7>[ 2238.110000] tcp_in_window: START
<7>[ 2238.110000] tcp_in_window:
<7>[ 2238.110000] seq=201772607 ack=4004184065+(0) sack=4004184065+(0)
win=14600 end=201772608
<7>[ 2238.110000] tcp_in_window: sender end=0 maxend=1500 maxwin=0
scale=0 receiver end=4004184065 maxend=4004184065 maxwin=1500 scale=0
<7>[ 2238.110000] tcp_in_window:
<7>[ 2238.110000] seq=201772607 ack=4004184065+(0) sack=4004184065+(0)
win=14600 end=201772608
<7>[ 2238.110000] tcp_in_window: sender end=201772608 maxend=201772608
maxwin=14600 scale=0 receiver end=4004184065 maxend=4004184065
maxwin=1500 scale=0
<7>[ 2238.110000] tcp_in_window: I=1 II=1 III=1 IV=1
<7>[ 2238.110000] tcp_in_window: res=1 sender end=201772608
maxend=201772608 maxwin=14600 receiver end=4004184065
maxend=4004198665 maxwin=1500
<7>[ 2238.110000] tcp_conntracks:
<7>[ 2238.110000] syn=1 ack=1 fin=0 rst=0 old=1 new=2
<7>[ 2238.120000] tcp_in_window: START
<7>[ 2238.120000] tcp_in_window:
<7>[ 2238.120000] seq=4004184065 ack=201772608+(0) sack=201772608+(0)
win=1500 end=4004184065
<7>[ 2238.120000] tcp_in_window: sender end=4004184065
maxend=4004198665 maxwin=1500 scale=0 receiver end=201772608
maxend=201772608 maxwin=14600 scale=0
<7>[ 2238.120000] tcp_in_window:
<7>[ 2238.120000] seq=4004184065 ack=201772608+(0) sack=201772608+(0)
win=1500 end=4004184065
<7>[ 2238.120000] tcp_in_window: sender end=4004184065
maxend=4004198665 maxwin=1500 scale=0 receiver end=201772608
maxend=201772608 maxwin=14600 scale=0
<7>[ 2238.120000] tcp_in_window: I=1 II=1 III=1 IV=1
<7>[ 2238.120000] tcp_in_window: res=1 sender end=4004184065
maxend=4004198665 maxwin=1500 receiver end=201772608 maxend=201774108
maxwin=14600
<7>[ 2238.120000] tcp_conntracks:
<7>[ 2238.120000] syn=0 ack=1 fin=0 rst=0 old=2 new=3
<7>[ 2238.810000] tcp_in_window: START
<7>[ 2238.810000] tcp_in_window:
<7>[ 2238.810000] seq=4004184065 ack=201772608+(0) sack=201772608+(0)
win=1500 end=4004184095
<7>[ 2238.810000] tcp_in_window: sender end=4004184065
maxend=4004198665 maxwin=1500 scale=0 receiver end=201772608
maxend=201774108 maxwin=14600 scale=0
<7>[ 2238.810000] tcp_in_window:
<7>[ 2238.810000] seq=4004184065 ack=201772608+(0) sack=201772608+(0)
win=1500 end=4004184095
<7>[ 2238.810000] tcp_in_window: sender end=4004184065
maxend=4004198665 maxwin=1500 scale=0 receiver end=201772608
maxend=201774108 maxwin=14600 scale=0
<7>[ 2238.810000] tcp_in_window: I=1 II=1 III=1 IV=1
<7>[ 2238.810000] tcp_in_window: res=1 sender end=4004184095
maxend=4004198665 maxwin=1500 receiver end=201772608 maxend=201774108
maxwin=14600
<7>[ 2238.810000] tcp_conntracks:
<7>[ 2238.810000] syn=0 ack=1 fin=0 rst=0 old=3 new=3
<7>[ 2238.870000] tcp_in_window: START
<7>[ 2238.870000] tcp_in_window:
<7>[ 2238.870000] seq=201772608 ack=4004184095+(0) sack=4004184095+(0)
win=14600 end=201772608
<7>[ 2238.870000] tcp_in_window: sender end=201772608 maxend=201774108
maxwin=14600 scale=0 receiver end=4004184095 maxend=4004198665
maxwin=1500 scale=0
<7>[ 2238.870000] tcp_in_window:
<7>[ 2238.870000] seq=201772608 ack=4004184095+(0) sack=4004184095+(0)
win=14600 end=201772608
<7>[ 2238.870000] tcp_in_window: sender end=201772608 maxend=201774108
maxwin=14600 scale=0 receiver end=4004184095 maxend=4004198665
maxwin=1500 scale=0
<7>[ 2238.870000] tcp_in_window: I=1 II=1 III=1 IV=1
<7>[ 2238.870000] tcp_in_window: res=1 sender end=201772608
maxend=201774108 maxwin=14600 receiver end=4004184095
maxend=4004198695 maxwin=1500
<7>[ 2238.870000] tcp_conntracks:
<7>[ 2238.870000] syn=0 ack=1 fin=0 rst=0 old=3 new=3
<7>[ 2238.870000] tcp_in_window: START
<7>[ 2238.870000] tcp_in_window:
<7>[ 2238.870000] seq=201772608 ack=4004184095+(0) sack=4004184095+(0)
win=14600 end=201772626
<7>[ 2238.870000] tcp_in_window: sender end=201772608 maxend=201774108
maxwin=14600 scale=0 receiver end=4004184095 maxend=4004198695
maxwin=1500 scale=0
<7>[ 2238.870000] tcp_in_window:
<7>[ 2238.870000] seq=201772608 ack=4004184095+(0) sack=4004184095+(0)
win=14600 end=201772626
<7>[ 2238.870000] tcp_in_window: sender end=201772608 maxend=201774108
maxwin=14600 scale=0 receiver end=4004184095 maxend=4004198695
maxwin=1500 scale=0
<7>[ 2238.870000] tcp_in_window: I=1 II=1 III=1 IV=1
<7>[ 2238.870000] tcp_in_window: res=1 sender end=201772626
maxend=201774108 maxwin=14600 receiver end=4004184095
maxend=4004198695 maxwin=1500
<7>[ 2238.870000] tcp_conntracks:
<7>[ 2238.870000] syn=0 ack=1 fin=0 rst=0 old=3 new=3
<7>[ 2238.870000] tcp_conntracks:
<7>[ 2238.870000] syn=0 ack=1 fin=1 rst=0 old=3 new=4
<7>[ 2238.880000] tcp_in_window: START
<7>[ 2238.880000] tcp_in_window:
<7>[ 2238.880000] seq=4004184095 ack=201772626+(0) sack=201772626+(0)
win=1500 end=4004184095
<7>[ 2238.880000] tcp_in_window: sender end=4004184095
maxend=4004198695 maxwin=1500 scale=0 receiver end=201772626
maxend=201774108 maxwin=14600 scale=0
<7>[ 2238.880000] tcp_in_window:
<7>[ 2238.880000] seq=4004184095 ack=201772626+(0) sack=201772626+(0)
win=1500 end=4004184095
<7>[ 2238.880000] tcp_in_window: sender end=4004184095
maxend=4004198695 maxwin=1500 scale=0 receiver end=201772626
maxend=201774108 maxwin=14600 scale=0
<7>[ 2238.880000] tcp_in_window: I=1 II=1 III=1 IV=1
<7>[ 2238.880000] tcp_in_window: res=1 sender end=4004184095
maxend=4004198695 maxwin=1500 receiver end=201772626 maxend=201774126
maxwin=14600
<7>[ 2238.880000] tcp_conntracks:
<7>[ 2238.880000] syn=0 ack=1 fin=0 rst=0 old=4 new=5
<7>[ 2238.880000] tcp_conntracks:
<7>[ 2238.880000] syn=0 ack=1 fin=1 rst=0 old=5 new=6
<7>[ 2238.940000] tcp_in_window: START
<7>[ 2238.940000] tcp_in_window:
<7>[ 2238.940000] seq=201772627 ack=4004184096+(0) sack=4004184096+(0)
win=14600 end=201772627
<7>[ 2238.940000] tcp_in_window: sender end=201772626 maxend=201774126
maxwin=14600 scale=0 receiver end=4004184095 maxend=4004198695
maxwin=1500 scale=0
<7>[ 2238.940000] tcp_in_window:
<7>[ 2238.940000] seq=201772626 ack=4004184096+(0) sack=4004184096+(0)
win=14600 end=201772626
<7>[ 2238.940000] tcp_in_window: sender end=201772626 maxend=201774126
maxwin=14600 scale=0 receiver end=4004184095 maxend=4004198695
maxwin=1500 scale=0
<7>[ 2238.940000] tcp_in_window: I=1 II=1 III=0 IV=1
<7>[ 2238.940000] tcp_in_window: res=0 sender end=201772626
maxend=201774126 maxwin=14600 receiver end=4004184095
maxend=4004198695 maxwin=1500
<7>[ 2238.940000] nf_ct_tcp: invalid new deleting.
<7>[ 2241.930000] tcp_conntracks:
<7>[ 2241.930000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2244.990000] tcp_conntracks:
<7>[ 2244.990000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2248.060000] tcp_conntracks:
<7>[ 2248.060000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2251.120000] tcp_conntracks:
<7>[ 2251.120000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2254.190000] tcp_conntracks:
<7>[ 2254.190000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2257.250000] tcp_conntracks:
<7>[ 2257.250000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2260.320000] tcp_conntracks:
<7>[ 2260.320000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2263.380000] tcp_conntracks:
<7>[ 2263.380000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2266.440000] tcp_conntracks:
<7>[ 2266.440000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2269.510000] tcp_conntracks:
<7>[ 2269.510000] syn=0 ack=1 fin=1 rst=0 old=6 new=6
<7>[ 2272.570000] tcp_conntracks:
<7>[ 2272.570000] syn=0 ack=0 fin=0 rst=1 old=6 new=8


On Tue, Oct 21, 2014 at 1:39 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Tue, 21 Oct 2014, vDev wrote:
>
>> Thanks, Jozsef. I see sequence number compensation in
>> segment_seq_plus_len() but does that not cover the ACK sequence
>> numbers. The variables (sack and receiver->td_end) are off by 1. It
>> seems like receiver->td_end must be incremented by 1 for last ACK.
>> Here's a trace:
>>
>> [  775.980000] seq=726609914 ack=94044192+(0) sack=94044192+(0)
>> win=14600 end=726609914
>> [  775.980000] tcp_in_window: sender end=726609914 maxend=726611414
>> maxwin=14600 scale=0 receiver end=94044191 maxend=94058791 maxwin=1500
>> scale=0
>> [  775.980000] tcp_in_window: I=1 II=1 III=0 IV=1
>> [  775.980000] tcp_in_window: res=0 sender end=726609914
>> maxend=726611414 maxwin=14600 receiver end=94044191 maxend=94058791
>> maxwin=1500
>>
>> As you can see above sack is 94044192 and receiver end is 94044191. As
>> a result III is 0 and res=0 which causes -NF_ACCEPT to be returned.
>
> It's a single packet, it doesn't tell anything about the TCP stream.
> A full TCP stream dump is required from the very first SYN to the very
> last packet.
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
