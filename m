From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking retransmission handling
Date: Tue, 25 Jan 2005 09:33:02 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501250909570.9430@blackhole.kfki.hu>
References: <20050125060705.GA32479@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050125060705.GA32479@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Phil,

On Mon, 24 Jan 2005, Phil Oester wrote:

> Under certain circumstances (high latency WAN links for instance), ack
> packets get stacked up and arrive in bulk.  The current TCP window
> tracking code interprets these numerous acks as retransmits, and
> if there are >= 3 retransmits sequentially, it resets the timeout on
> a conntrack to 5 minutes.
>
> This is trivially reproducible on a high latency link by an 'ls -lR'
> on a large-ish tree.  In my test case, 8 ack packets arrived sequentially
> at the end of the listing.  While the seq numbers on those packets
> were indeed identical (which the current code tests for), they were acking
> unique packets, and thus clearly do not qualify as retransmissions.
>
> The problem lies in the fact that the code currently only examines
> the seq number of the arriving packet, but does not also look at the
> seq number being acked.  The patch below adds this additional check.
> Unfortunately, it adds another int32 to ip_ct_tcp, but I could think
> of no other fool-proof way of fixing it (short of ripping out the
> retransmission test altogether).

If we really want to attempt to detect resent packets, then I agree with
you and the proposed solution. I was reluctant to add another field to
ip_ct_tcp, but that cannot be avoided in order to do the job properly.

[However, from another point of view, we actually could get rid of the
feeble attempt of detecting resent packets (and thus the retrans and
last_end fields) with the price of possible dangling connections in the
conntrack table. The current code handles just fine "reopening" stuck
connections.]

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
