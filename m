From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking retransmission handling
Date: Tue, 25 Jan 2005 11:09:02 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501251106190.9430@blackhole.kfki.hu>
References: <20050125060705.GA32479@linuxace.com>
	<Pine.LNX.4.58.0501250909570.9430@blackhole.kfki.hu>
	<Pine.LNX.4.58.0501251041390.11515@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.58.0501251041390.11515@tux.rsn.bth.se>
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

On Tue, 25 Jan 2005, Martin Josefsson wrote:

> > [However, from another point of view, we actually could get rid of the
> > feeble attempt of detecting resent packets (and thus the retrans and
> > last_end fields) with the price of possible dangling connections in the
> > conntrack table. The current code handles just fine "reopening" stuck
> > connections.]
>
> I think this is one of the features that really help keep the hashtable
> small and nice. And of course the ability to disable connection pickup by
> disabling ip_conntrack_tcp_loose. With the old code I easily had ~100k
> entries in the hashtable, with the new code and loose disabled I see
> 35-40k entries unless there's a lot of udp scanning going on.

Thank you, such reports are always wanted.

> I'd like for it to continue existing unless it bloats the code and
> datastructures too much.

Patrick, please submit the patch for kernel inclusion.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
