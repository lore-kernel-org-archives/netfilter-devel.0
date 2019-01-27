From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing-djzkFPsfvsizQB+pC5nmwQ@public.gmane.org>
Subject: "Kernel bug detected [...]
 nf_ct_del_from_dying_or_unconfirmed_list"
Date: Sun, 27 Jan 2019 22:47:08 +0100
Message-ID: <20190127214708.GC1788@otheros>
Reply-To: The list for a Better Approach To Mobile Ad-hoc Networking
 <b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org
To: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.open-mesh.org/mm/options/b.a.t.m.a.n>,
 <mailto:b.a.t.m.a.n-request-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-mesh.org/pipermail/b.a.t.m.a.n/>
List-Post: <mailto:b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:b.a.t.m.a.n-request-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-mesh.org/mm/listinfo/b.a.t.m.a.n>,
 <mailto:b.a.t.m.a.n-request-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org?subject=subscribe>
Errors-To: b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org
Sender: "B.A.T.M.A.N" <b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I was trying to implement a multicast-to-multi-unicast conversion
in batman-adv with the following patch:

https://patchwork.open-mesh.org/patch/17729/

However, on OpenWrt with a 4.9.146 kernel I get a
"Kernel bug detected [...] nf_ct_del_from_dying_or_unconfirmed_list".

This only happens upon sending a SIGTERM to the network manager
"netifd" (so upon network shutdown). And only if the node is connected
to mesh of reasonable size, so if there is a certain amount of
multicast traffic for the multicast-to-multi-unicast patch to work on.

Upon normal operation, no such crash seems to occur.

The crash itself is triggered by the:

  BUG_ON(hlist_nulls_unhashed(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode));

in here:

https://elixir.bootlin.com/linux/v4.9.146/source/net/netfilter/nf_conntrack_core.c#L354


What confuses me a bit is, that the multicast-to-multi-unicast
conversion uses the same/similar, simple skb_copy() approach like the
"classic broadcast flooding" approach in batman-adv so far. The latter too
transmits three redundant frames via skb_copy() to increase
reliability for Wifi broadcast packets.

One difference is that the broadcast flooding adds a bit of
delay between each transmission. Which the multicast-to-multi-unicast
doesn't.

Looking at "git log net/netfilter/nf_conntrack_core.c" I noticed
"netfilter: nfnetlink_queue: resolve clash for unconfirmed
conntracks" (368982cd7). Which says:

"In nfqueue, two consecutive skbuffs may race to create the conntrack
 entry. Hence, the one that loses the race gets dropped due to clash in
 the insertion into the hashes from the nf_conntrack_confirm() path."

This patch is only part of >= 4.18, so not part of the firmware we use
yet. Could this issue somehow be related?


Other than that I was wondering whether we might be missing to
reset something after skb_copy()-ing. We do a "skb->protocol =
htons(ETH_P_BATMAN)" right before the dev_queue_xmit(skb) call in
batman-adv which sends the encapsulated frame into the
mesh. And we do a nf_reset(skb) after decapsulating a frame
received from the mesh. But maybe that is not enough?

Ticket this issue was reported at:

https://github.com/freifunk-gluon/gluon/issues/1468

Regards, Linus
