From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libxt_cluster: Add translation to nft
Date: Tue, 30 May 2017 21:15:29 +0200
Message-ID: <20170530191529.GB4675@salvia>
References: <1496132734-3829-1-git-send-email-mayhs11saini@gmail.com>
 <20170530100855.GC1273@salvia>
 <20170530102014.GA1674@salvia>
 <CAOfkYf5KT7EG75yOb5UhhLNGjvQrRL9+SJudZrq=2Drxy142GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751110AbdE3TPn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 15:15:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B4225DFF13
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 21:15:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A00B4FF2FB
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 21:15:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FFD4FF2FB
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 21:15:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOfkYf5KT7EG75yOb5UhhLNGjvQrRL9+SJudZrq=2Drxy142GQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 30, 2017 at 08:47:09PM +0530, Shyam Saini wrote:
> On Tue, May 30, 2017 at 3:50 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, May 30, 2017 at 12:08:55PM +0200, Pablo Neira Ayuso wrote:
> >> On Tue, May 30, 2017 at 01:55:34PM +0530, Shyam Saini wrote:
> >> > Add translation for cluster match to nftables
> >> >
> >> > $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed
> >> > 0xdeadbeef -j MARK --set-mark 0xffff
> >> > nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 2 seed 0xdeadbeef eq 0 meta pkttype set host counter meta mark set
> >> > 0xffff
> >> >
> >> > $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-nodemask 1 --cluster-hash-seed
> >> > 0xdeadbeef -j MARK --set-mark 0xffff
> >> > nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 2 seed 0xdeadbeef eq 0 meta pkttype set host counter meta mark set
> >> > 0xffff
> >> >
> >> >  --debug=netlink Result
> >> > ip mangle PREROUTING
> >> >   [ meta load iifname => reg 1 ]
> >> >   [ cmp eq reg 1 0x31687465 0x00000000 0x00000000 0x00000000 ]
> >> >   [ ct load src => reg 2 , dir original ]
> >> >   [ hash reg 1 = jhash(reg 2, 4, 0xdeadbeef) % mod 2 ]
> >> >   [ cmp eq reg 1 0x00000000 ]
> >> >   [ immediate reg 1 0x00000000 ]
> >> >   [ meta set pkttype with reg 1 ]
> >> >   [ counter pkts 0 bytes 0 ]
> >> >   [ immediate reg 1 0x0000ffff ]
> >> >   [ meta set mark with reg 1 ]
> >> >
> >> > For Example:
> >> >
> >> > If we have  total 2 nodes (i.e, --cluster-total-nodes is 2) in the cluster then
> >> >  modulus 2 = {0, 1}
> >> >
> >> > For node 1 (--cluster-local-node 1)
> >> >     jhash ct original saddr mod 2 seed 0xdeadbeef eq 0
> >> >
> >> > For  node 2 (--cluster-local-node 2)
> >> >     jhash ct original saddr mod 2 seed 0xdeadbeef eq 1
> >> >
> >> > Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> >> > ---
> >> >  extensions/libxt_cluster.c | 11 +++++++++++
> >> >  1 file changed, 11 insertions(+)
> >> >
> >> > diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
> >> > index 3adff12..f2abd18 100644
> >> > --- a/extensions/libxt_cluster.c
> >> > +++ b/extensions/libxt_cluster.c
> >> > @@ -126,6 +126,16 @@ cluster_save(const void *ip, const struct xt_entry_match *match)
> >> >             info->total_nodes, info->hash_seed);
> >> >  }
> >> >
> >> > +static int cluster_xlate(struct xt_xlate *xl,
> >> > +           const struct xt_xlate_mt_params *params)
> >> > +{
> >> > +   const struct xt_cluster_match_info *info = (const struct xt_cluster_match_info *)params->match->data;
> >> > +
> >> > +   xt_xlate_add(xl, "jhash ct original saddr mod %u seed 0x%08x eq 0 meta pkttype set host",
> >>
> >> This should use "eq %u" because:
> >>
> >>       xt_xlate_add(xl, "jhash ct original saddr mod %u seed 0x%08x eq %u meta pkttype set host",
> >
> > Forget this I mentioned below, got mixed with another email to you.
> >
> > What I'm telling here is, the "eq %u" should be used to translate
> > info->node_mask.
> >
> > Note that info->node_mask is a bitmask, so you have to interpret this
> > accordingly from the translation.
> 
> by this you mean, we have to take bitwise AND with generated jhash?
> 
> http://elixir.free-electrons.com/linux/latest/source/net/netfilter/xt_cluster.c#L132

No. I mean, you have to extract from the bitmask the node number, ie.

int i, k = 0;

for (i = 0; i < 32; i++) {
        if (info->node_mask & (1 << i)) {
                if (!needs_set) {
                        printf("{ ");
                        needs_set = true;
                }
                if (k)
                        printf(", ");

                printf("%u", i);
                k++;
        }
        if (needs_set)
                printf("}");
}

Something like this... not even compile tested.

> > Note that we have to support --cluster-local-nodemask too, you can
> > translate this using a set, ie.
> >
> > jhash ct original saddr mod 4 seed 0x1234 { 0, 1 } meta pkttype set host
> >
> 
> Translation should print set of node id depending on the number of nodes.
> For example for total_nodes = 4, it should print
> jhash ct original saddr mod 4 seed 0x1234 { 0, 1, 2, 3 } meta pkttype set host
> Right?

If there is a single node in the bitmask, then you just print:

[a] jhash ct original saddr mod 4 seed 0x1234 eq 3 meta pkttype set host

if rhere are several node in the bitmask, then, eg.

[b] jhash ct original saddr mod 4 seed 0x1234 eq { 0, 1, 3 } meta pkttype set host

You need to do some preprocessing on info->node_mask to know if you
need [a] or [b].
