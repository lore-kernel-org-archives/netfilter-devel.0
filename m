From: Patrick McHardy <kaber@trash.net>
Subject: Re: Implementation of Ebtables target similar to QUEUE
Date: Fri, 28 Sep 2007 23:42:08 +0200
Message-ID: <46FD7530.6090506@trash.net>
References: <132825.81500.qm@web7901.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61661 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbXI1VpW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:45:22 -0400
In-Reply-To: <132825.81500.qm@web7901.mail.in.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Abhinav Srivastava wrote:
> Hi Patrick,
>
> Thanks for your quick reply. I understood the first
> part but did not get the second harder part
> completely.
>
> Could you please shed some more light on that and also
> it would be great if you could give me some pointer
> for  target files that I may need to look into.
>   

The NF_HOOK part: the okfn functions given to NF_HOOK in the bridge
code don't actually continue the packet processing path as required
for packet reinjection. Normally you'd have:


static inline int finish_packet_processing(struct sk_buff *skb)
{
    <finish packet processing>
}

static int process_packet(struct sk_buff *skb)
{
    ...
    return NF_HOOK(...., finish_packet_processing);
}

Look at net/ipv4/ip_input.c for an example. The bridging code does
(in some spots at least) something like this:

static int br_handle_local_finish(struct sk_buff *skb)
{
        struct net_bridge_port *p = rcu_dereference(skb->dev->br_port);

        if (p)
                br_fdb_update(p->br, p, eth_hdr(skb)->h_source);
        return 0;        /* process further */
}

struct sk_buff *br_handle_frame(struct net_bridge_port *p, struct 
sk_buff *skb)
{
    ...
                if (NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_IN, skb, skb->dev,
                            NULL, br_handle_local_finish))
    ...
}

When the queue handler calls nf_reinject, the packet goes to the
okfn. In the case above that would be br_handle_local_finish(),
which will simply update the fdb and return to nf_reinject,
leaking the packet instead of continuing processing.

The code needs to be rearranged that in all NF_HOOK invocations
the okfn takes ownership of the skb and continues processing.
grep net/bridge for NF_HOOK for all spots to check (excluding
br_netfilter.c).

The second part is simpler, __nf_queue() and nf_reinject()
perform a lookup for afinfo of the packets protocol family
and drop the packet if that lookup is unsucessful. For bridging
there is no registered family, so the packet is always dropped.
So these functions (net/netfilter/nf_queue.c) needs to be changed
to handle the unsucessful lookup by avoiding rerouting.

