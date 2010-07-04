From: Simon Lodal <simonl@parknet.dk>
Subject: Re: xt2 table core
Date: Sun, 4 Jul 2010 19:22:39 +0200
Message-ID: <201007041922.39846.simonl@parknet.dk>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de> <201007020532.12596.simonl@parknet.dk> <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cuda.parknet.dk ([84.238.112.40]:51294 "EHLO cuda.parknet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab0GDRWm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Jul 2010 13:22:42 -0400
In-Reply-To: <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

S=F8ndag 04 juli 2010 15:56:03 skrev Jan Engelhardt:
> On Friday 2010-07-02 05:32, Simon Lodal wrote:
> >> This patchset adds the xtables2 main proper, and incrementally
> >> changes ip6_tables to use it. There are more patches for iptables
> >> and arptables and, but to not make it larger than needed, just thi=
s
> >> much for now.
> >>=20
> >> Previously featured on http://lwn.net/Articles/345176/ .
> >
> >Nice to see some new development! Guess we all have a long wishlist =
that
> >is hard to implement in the current design, and this may make it eas=
ier.
> >
> >But what about performance? I think all these lists must cause a hug=
e
> >amount of jumps in hot path (eg. filtering packets). The packed blob
> >format is hard to work with, but once created it is efficient. Do yo=
u
> >have any expectations or even numbers on the performance?
>=20
> Your suspicion was right, linked lists seem to have their impact.
>=20
> The command I used was
>=20
> 	ping6 localhost -fc 500 -i .001
>=20
> this sends 500 packets in near-flood fashion (-i0 would lead to
> packet drops).
>=20
> Xtables1 blob-style 2.6.31-rc4:
> 500 packets transmitted, 500 received, 0% packet loss, time 3532ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3428ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3388ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3339ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3219ms
>=20
> Xtables1 blob-style 2.6.34:
> 500 packets transmitted, 500 received, 0% packet loss, time 3405ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3525ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3426ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3388ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3328ms
>=20
> Xtables2 (linked lists) 2.6.35-rc1:
> 500 packets transmitted, 500 received, 0% packet loss, time 14775ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14383ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14381ms
> 500 packets transmitted, 500 received, 0% packet loss, time 15432ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14498ms
>=20
> nftables (uses linked lists) 2.6.31-rc4:
> 500 packets transmitted, 500 received, 0% packet loss, time 16198ms
> 500 packets transmitted, 500 received, 0% packet loss, time 16128ms
> 500 packets transmitted, 500 received, 0% packet loss, time 16492ms
> 500 packets transmitted, 500 received, 0% packet loss, time 16451ms
> 500 packets transmitted, 500 received, 0% packet loss, time 16475ms
>=20
> Well I guess Xt2 isn't the total backlight :-)
>=20
> Do you have any suggestions for improvement though?

Interesting.

I think it is a question of granularity. At what level do we use lists,=
 vs.=20
blobs? It seems to be a flexibility/performance tradeoff. I have hundre=
ds of=20
kpps 24/7 and rarely reload rules, so I am strictly in the performance =
camp=20
:-)

Chain granularity that we have now is maybe too big. Match/target granu=
larity=20
that you use is apparently too small. Also, is the ability to edit matc=
hes and=20
targets really useful? Perhaps rule granularity (keep each rule as one =
blob)=20
is right.

Another thought, though beyond the scope of this patchset: The kernel s=
ide=20
could have two rulesets:
1) In linked lists (like your patch), what userspace sees.
2) Big packed blobs, generated in kernel from the lists; what filtering=
=20
actually runs off.

So userspace gets flexibility, and kernel side gets performance, plus d=
ealing=20
with packaging the blob, copying it NR_CPU times, swapping it in atomic=
ally.


Simon
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
