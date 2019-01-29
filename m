From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing-djzkFPsfvsizQB+pC5nmwQ@public.gmane.org>
Subject: Re: "Kernel bug detected [...]
 nf_ct_del_from_dying_or_unconfirmed_list"
Date: Tue, 29 Jan 2019 10:07:54 +0100
Message-ID: <20190129090754.GB1528@otheros>
References: <20190127214708.GC1788@otheros>
Reply-To: The list for a Better Approach To Mobile Ad-hoc Networking
 <b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org
To: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190127214708.GC1788@otheros>
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

On Sun, Jan 27, 2019 at 10:47:08PM +0100, Linus Lüssing wrote:
[...]
> The crash itself is triggered by the:
> 
>   BUG_ON(hlist_nulls_unhashed(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode));
> 
> in here:
> 
> https://elixir.bootlin.com/linux/v4.9.146/source/net/netfilter/nf_conntrack_core.c#L354

I had tried the nf_reset()s and Wang's patch but with no success.

Skimming through the code I noticed that there aren't that many
opportunities for the hnnode to become zero. There are several
hlist_nulls_del_rcu(), but no hlist_nulls_del_init_rcu()s for
instance.

That started to make me wonder whether something from "outside"
might be setting the hnnode to zero - and yeah...

I missed that batadv_send_skb_unicast() always frees/consumes the
skb... and I was freeing the skb myself if that call returned
!NET_XMIT_SUCCESS. So a double kfree_skb()... I'm a bit surprised
that things did not crash more often...

Sorry for the noise :-(. But thanks for all the help and quick
responses!
