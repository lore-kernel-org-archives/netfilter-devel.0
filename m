From: Florian Westphal <fw@strlen.de>
Subject: Re: nft_rbtree_lookup: BUG: unable to handle kernel NULL pointer
 dereference
Date: Tue, 26 Jul 2016 17:15:52 +0200
Message-ID: <20160726151552.GA30809@breakpoint.cc>
References: <1469539108.1032.30.camel@akp.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: "Anders K. Pedersen" <akp@akp.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59214 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbcGZPP5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 11:15:57 -0400
Content-Disposition: inline
In-Reply-To: <1469539108.1032.30.camel@akp.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anders K. Pedersen <akp@akp.dk> wrote:
> Hello,
>=20
> While doing some tests with nftables, I've run into the the following
> bug, which is easily reproducable:
>=20
> [ 1409.721487] BUG: unable to handle kernel NULL pointer dereference =
at 0000000000000010
> [ 1409.730512] IP: [<ffffffff81495de9>] nft_rbtree_lookup+0xa9/0x150
> [ 1409.737525] PGD 0
> [ 1409.739841] Oops: 0000 [#1] SMP
> [ 1409.743445] Modules linked in:
> [ 1409.746966] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.7.0 #1
> [ 1409.753660] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 2=
=2E1.6 05/19/2016
> [ 1409.762253] task: ffffffff8180b500 ti: ffffffff81800000 task.ti: f=
fffffff81800000
> [ 1409.770846] RIP: 0010:[<ffffffff81495de9>]  [<ffffffff81495de9>] n=
ft_rbtree_lookup+0xa9/0x150
> [ 1409.780651] RSP: 0018:ffff88085f2039c8  EFLAGS: 00010202
> [ 1409.786745] RAX: ffff88083dc76f80 RBX: ffff88083dc76fa4 RCX: 00000=
00000000002
> [ 1409.794937] RDX: 0000000000000004 RSI: ffff88083dc76de0 RDI: ffff8=
8083dc76fa4
> [ 1409.803130] RBP: 0000000000000004 R08: 0000000000000000 R09: ffff8=
8085f203aa0
> [ 1409.811323] R10: ffff88083dc699e2 R11: ffff88085803d000 R12: ffff8=
8085ae2f700
> [ 1409.819517] R13: ffff88083dc76f80 R14: ffff88085f203aa0 R15: 00000=
00000000000
> [ 1409.827710] FS:  0000000000000000(0000) GS:ffff88085f200000(0000) =
knlGS:0000000000000000
> [ 1409.837006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1409.843594] CR2: 0000000000000010 CR3: 0000000001806000 CR4: 00000=
000001406f0
> [ 1409.851788] Stack:
> [ 1409.854095]  ffffffff00000002 ffff8800785b0100 0000000000000000 ff=
ff88085f203a20
> [ 1409.862641]  ffff88085ae2f700 ffff880855e16428 ffff88085f203a90 00=
00000000000002
> [ 1409.871184]  00000000ffffffff ffff880855e16428 ffffffff81493a4e ff=
ff880859d699d8
> [ 1409.879736] Call Trace:
> [ 1409.882539]  <IRQ>
> [ 1409.884751]  [<ffffffff81493a4e>] ? nft_lookup_eval+0x2e/0x80
[..]

> I have narrowed the rule set in use down to:
>=20
> table ip filter {
> =A0=A0=A0=A0=A0=A0=A0=A0set bogons {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0type ipv4_addr
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0flags interval
> =A0=A0=A0=A0=A0=A0=A0=A0}
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0chain prerouting {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0type filter hook prer=
outing priority -300; policy accept;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0iif lo accept
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ip daddr @bogons ip d=
addr !=3D 224.0.0.0/4 log prefix "Bogon" group 0 snaplen 80 counter pac=
kets 0 bytes 0 drop
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ip saddr @bogons log =
prefix "Bogon" group 0 snaplen 80 counter packets 0 bytes 0 drop
> =A0=A0=A0=A0=A0=A0=A0=A0}
> }
>=20
> With the following shell code, the box will crash quite quickly (with=
in
> seconds) during the "nft delete element" part:
>=20
> I=3D1
> while : ; do
> 	echo -n "${I} add"
> 	nft add element ip filter bogons { 0.0.0.0/8 }
> 	echo -n " delete"
> 	nft delete element ip filter bogons { 0.0.0.0/8 }
> 	echo
> 	I=3D$[${I}+1]
> done

Perfect.  Thanks for this detailed bug report!

When the 'goto found' path is taken then 'parent' has already been set =
in
previous loop and might be NULL.

diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -72,6 +72,8 @@ static bool nft_rbtree_lookup(const struct net *net, =
const struct nft_set *set,
 		else {
 found:
 			if (!nft_set_elem_active(&rbe->ext, genmask)) {
+				if (parent =3D=3D NULL)
+					goto out;
 				parent =3D parent->rb_left;
 				continue;
 			}
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
