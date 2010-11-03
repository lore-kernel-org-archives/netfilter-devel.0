From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: libnetfilter_queue exiting on big tcp sessions
Date: Wed, 03 Nov 2010 19:55:30 +0100
Message-ID: <1288810531.2511.237.camel@edumazet-laptop>
References: <AANLkTimmr4MVCOwgxea9KoGB1BjomBchJ7oAgpnt2WyZ@mail.gmail.com>
	 <AANLkTin_ZFeXkzJ6zELpX3pP3782YfLjHcPzHrjDt1Ae@mail.gmail.com>
	 <AANLkTikV4_MD0JZzbvKhSXjL-abMDY7Af_3FTbbTzP33@mail.gmail.com>
	 <AANLkTikRXtjo-0y9aAPmOQ_gAWfTAYM4D-eDfTwah8z6@mail.gmail.com>
	 <AANLkTikxw3dyv6SUVo4O36sHhVM+eZfgb1A5sX-tCM1b@mail.gmail.com>
	 <AANLkTinQ6Q3B7XbdaCRJ9Qr0bTf6VGjLVkjgUtXaSjjk@mail.gmail.com>
	 <AANLkTin9DYRgeCNzkoxDS6Yy1pJ_jdPdzo0VDFe3S9q_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mistick Levi <gmistick@gmail.com>,
	Rajkumar S <rajkumars@gmail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <AANLkTin9DYRgeCNzkoxDS6Yy1pJ_jdPdzo0VDFe3S9q_@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le mercredi 03 novembre 2010 =C3=A0 11:42 -0700, Justin Yaple a =C3=A9c=
rit :
> Yechiel,
>=20
> Again thank you this seems like a better fix than ignoring the error.
> I had set the queue length to 1024 so it makes sense that the
> buffersize would also need to be adjusted to acomidate the new queue
> length.  I have not figured out how to access the error message along
> with the error number so I dont know for sure what it was.  Its
> probably safe to guess that because I was using the default buffer
> space it was "bufferspace unavailible".
>=20
> #define BUFSIZE 4096 // Size of buffer used to store IP packets.
> #define NFQLENGTH 1024 // Length of the netfilter queue.
>=20
> nfnl_rcvbufsiz(nfq_nfnlh(h), NFQLENGTH * BUFSIZE);
>=20
> So yes the kernel is sending packets to the queue faster than my
> application was processing them but I expected that.  The buffer does
> need to be adjusted so the queue can hold those packets until they ca=
n
> be processed.  A single session did not run into this issue because
> the default buffer size is large enough to hold any outstanding
> packets of a single session but once multiple sessions were involved
> the queue would fill up quickly.
>=20
> After that change I was able to handle running 32 parallel iperf
> connections.  The total throughput was ~20Mb.  Without sending traffi=
c
> through my application the throughput was ~138Mb but given that all m=
y
> test systems are running as VMs on the same system with only 4GB of
> ram it does not supprise me to see a big hit in performance there.
> Should see better results running on dedicated hardware.

If this is running on multi processor machine, you could use several NF
queues (one per cpu).

Eventually also use RPS if your network card is not multiqueue, to
spread tcp flows to different cpus and different queues.



