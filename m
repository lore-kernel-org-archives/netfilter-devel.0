From: Harald Welte <laforge@netfilter.org>
Subject: Re: The latest nf_conntrack
Date: Mon, 8 Nov 2004 14:47:09 +0100
Message-ID: <20041108134709.GE12437@sunbeam.de.gnumonks.org>
References: <200411010827.iA18RJGT024881@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6JAe/4X0qssghT2u"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200411010827.iA18RJGT024881@toshiba.co.jp>
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


--6JAe/4X0qssghT2u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yasuyuki!

On Mon, Nov 01, 2004 at 05:27:18PM +0900, Yasuyuki Kozakai wrote:

> I finished synchronizing nf_conntrack with ip_conntrack in linux 2.6.10-r=
c1.
> I need to cleanup and do more tests, anyway, I committed it to pom-ng.

Thanks again, Yasuyuki.  I didn't have time to review your latest
version until today.  I am happy that the issues we discussed at the
workshop have been resolved.

I allowed myself to commit a minor modification:  The include path for
new header files is <linux/netfilter/ipv4> instead of
<linux/netfilter_ipv4>.  Old headers stay at their current position, but
I think in the end (after nf_conntrack is merged) they should be moved
too (and we just provide dummy include files that include the new files
for backwards compatibility). =20

> From the discussion at Netfilter developer workshop, I deleted the
> very complex code reallocating conntrack from the basic slab cache
> when destroying the slab cache for conntrack which has "help" part.
> Instead, all slab caches are destroyed when unloading nf_conntrack.ko

Great.

> And I re-implemented handling fragmented IPv6 packets. This code is what
> I imagined after workshop, but I recently found that my idea is different
> with the results of discussion at workshop. Then I may change some parts.

Which differences are you talking about?  Is it that you pass the
individual fragments instead of the refreagmented packet?  I think we
were undecided at the workshop about what to do, so it's not really a
difference from the proposed solution ;)

> The summary of handling IPv6 packets is as follows.
>=20
> - at the hook NF_IP6_PRE_ROUTING, priority NF_IP6_CONNTRACK_DEFRAG,
> 	- The fragments are cloned and queued. clone skb has the pointer
> 	  to original skb.
> 	- When all fragments are gathered, cloned skb are reassembled.
> 	- All original skbs keep the pointer to reassembled skb in new member
> 	  of sk_buff "nfct_reasm".
> 	- The following hooks of NF_IP6_PRE_ROUTING are called. Please note
> 	  that reassembled skb isn't passed to hooks but original fragments are
> 	  passed.
> 	- NF_STOLEN is returned.

this sounds exactly lik our plan.

> - at the hook NF_IP6_PRE_ROUTING, priority NF_IP6_CONNTRACK,
> 	- If skb has reassembled skb, that is, packet is fragmented,
> 		- If reassembled skb is already parsed, fragmented skb
> 		  reserves the pointer to the conntrack bound with reassembled
> 		  skb. Otherwise, reassembled skb is parsed.
> 	  Otherwise, skb is ordinarily parsed.
> 	- The original fragments are passed to next hooks and IPv6 core
> 	  processing.

again, great.

> By this processing,
> 	1. We can prevent disturbing IPv6 stack. If we introduce
> 	   ip_conntrack style, and when large fragmented packets came in,
> 	   "Too big" isn't sent. Instead, resized fragmented packets are
> 	   forwarded. That isn't natural.

yes.  I think it is even worth to change nf_conntrack_ipv4 to do it the
same way as ipv6 now does it.  But let's not change too many things at
the same time,

> comments ?

I again have to congratulate you on your work.  I think nf_conntrack was
not an easy task, and you managed very well, especially without any strong
previous netfilter development background.  Thanks also to USAGI and
Toshiba for enabling you to contribute this work.

Let me give it some testing.  Maybe I even get around doing some
benchmarking of ip_conntrack versus nf_conntrack, just to get an idea
how big the performance impact of the generalization is.

If everything goes well, I think we can merge in one to two weeks!

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6JAe/4X0qssghT2u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBj3jdXaXGVTD0i/8RAubcAJ9jDoNbqB/+9hHdrNdt9+IhdPiXbACfSMKn
YtX3WFzEyErmMys9PCxz1eU=
=Bfz8
-----END PGP SIGNATURE-----

--6JAe/4X0qssghT2u--
