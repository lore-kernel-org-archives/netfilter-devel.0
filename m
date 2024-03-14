Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8379B51C49
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710419943; cv=none; b=FOhI7rn6ITAdSft5pp9eUF97seoGhRwFo/miJePJ6N2oLlYZ0Z4vRz+F+JGrZjFaj4gMT+3fuqHau4/87Dbfq/9kI6juFN/VdExHF9CNDALOqil7nHsXAkL2LcVWRwzVpTs2zzIy3kjgtCv8weGeB8SgHo1Bf+/ZlWzgFTqqDMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710419943; c=relaxed/simple;
	bh=8iz90J9Zg5mk9AN4iAV9j11XktfjDEuSAHy2wPnTsWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhiiRwsqLCd24Lh/ZeA1bnw+SnXN0uVNasBCPl7FqMcVozF9fbAi5HrrDS9RLeJfct56ejFUT40iDUciL+nDdOozzJpewnlGtbviGMCjHXySISi+u/R98DfteZ7lGSbMHo7Pd8eEIAmCCPdiLWMj+QvkqWxI9EShxBJBHC2gec8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 14 Mar 2024 13:38:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: Flowtable race condition error
Message-ID: <ZfLv3iQk--ddRsk2@calendula>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <ZfLc33WgQPKdv2vG@calendula>
 <2lv2ycmvwqpzw2etorhz32oxxnzgnpmi7g7ykm3z5c2cnqcilk@zmixunfs4sjz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NmQJbSVC7I/iNijF"
Content-Disposition: inline
In-Reply-To: <2lv2ycmvwqpzw2etorhz32oxxnzgnpmi7g7ykm3z5c2cnqcilk@zmixunfs4sjz>


--NmQJbSVC7I/iNijF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Mar 14, 2024 at 12:30:30PM +0100, Sven Auhagen wrote:
> On Thu, Mar 14, 2024 at 12:17:51PM +0100, Pablo Neira Ayuso wrote:
> Hi Pablo,
> 
> > Hi Sven,
> > 
> > On Tue, Mar 12, 2024 at 05:29:45PM +0100, Sven Auhagen wrote:
> > > Hi,
> > > 
> > > I have a race condition problem in the flowtable and could
> > > use some hint where to start debugging.
> > > 
> > > Every now and then a TCP FIN is closing the flowtable with a call
> > > to flow_offload_teardown.
> > > 
> > > Right after another packet from the reply direction is readding
> > > the connection to the flowtable just before the FIN is actually
> > > transitioning the state from ESTABLISHED to FIN WAIT.
> > > Now the FIN WAIT connection is OFFLOADED.
> > 
> > Are you restricting your ruleset to only offload new connections?
> > 
> 
> It does not work to only use ct state new as we need to see both
> directions for the offload and the return packet is in ct state
> established at that point.

Indeed, we need to see two packets at least, which will be the next
one coming in the opposite that is, the conntrack needs to be
confirmed.

> > Or is it conntrack creating a fresh connection that being offloaded
> > for this terminating TCP traffic what you are observing?
> 
> I can see a race condition where there is a TCP FIN packet
> so flow_offload_teardown is called but before the FIN packet
> is going through the slow path and sets the TCP connection to FIN_WAIT
> another packet is readding the state to the flowtable.
>
> So I end up with FIN_WAIT and status OFFLOADED.
> This only happens every few hunderd connections.
>
> > > This by itself should work itself out at gc time but
> > > the state is now deleted right away.
> > >
> > > Any idea why the state is deleted right away?
> > 
> > It might be conntrack which is killing the connection, it would be
> > good to have a nf_ct_kill_reason(). Last time we talk, NAT can also
> > kill the conntrack in masquerade scenarios.
> > 
> 
> I found this out.
> The state is deleted in the end because the flow_offload_fixup_ct
> function is pulling the FIN_WAIT timeout and deducts the offload_timeout
> from it. This is 0 or very close to 0 and therefore ct gc is deleting the state
> more or less right away after the flow_offload_teardown is called
> (for the second time).

This used to be set to:

        timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];

but after:

commit e5eaac2beb54f0a16ff851125082d9faeb475572
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue May 17 10:44:14 2022 +0200

    netfilter: flowtable: fix TCP flow teardown

it uses the current state.

> > > Here is the output of the state messages:
> > > 
> > >     [NEW] tcp      6 120 SYN_SENT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 [UNREPLIED] src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
> > >  [UPDATE] tcp      6 60 SYN_RECV src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
> > >  [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
> > >  [UPDATE] tcp      6 86400 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
> > > [DESTROY] tcp      6 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 packets=10 bytes=1415 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 packets=11 bytes=6343 [ASSURED] mark=92274785 delta-time=0
> > 
> > Is there a [NEW] event after this [DESTROY] in FIN_WAIT state to pick
> > the terminating connection from the middle?
> > 
> > b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or
> > FIN was seen") to let conntrack close the connection gracefully,
> > otherwise flowtable becomes stateless and already finished connections
> > remain in place which affects features such as connlimit.
> > 
> > The intention in that patch is to remove the entry from the flowtable
> > then hand over back the conntrack to the connection tracking system
> > following slow path.
> 
> So if the machanism is intended as it is then we need to make sure that the
> timeout is not so close to 0 and we life with the possible race condition?

Then, this needs a state fix up based on the packet from the flowtable
path to infer the current state.

This patch is not complete, it just restores ct timeout based on
the established state, which has also its own problems.

--NmQJbSVC7I/iNijF
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index a0571339239c..1f6d168e3ce6 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -182,7 +182,7 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 
 		flow_offload_fixup_tcp(&ct->proto.tcp);
 
-		timeout = tn->timeouts[ct->proto.tcp.state];
+		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
 		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
@@ -346,9 +346,10 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
+	flow_offload_fixup_ct(flow->ct);
+	smp_mb__before_atomic();
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 

--NmQJbSVC7I/iNijF--
