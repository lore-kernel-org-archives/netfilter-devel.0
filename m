From: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Subject: Re: Implementation of Ebtables target similar to QUEUE
Date: Thu, 18 Oct 2007 21:29:49 +0100 (BST)
Message-ID: <2688.41803.qm@web7913.mail.in.yahoo.com>
References: <46FD7530.6090506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web7913.mail.in.yahoo.com ([202.86.4.89]:27028 "HELO
	web7913.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754349AbXJRU34 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:29:56 -0400
In-Reply-To: <46FD7530.6090506@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--- Patrick McHardy <kaber@trash.net> wrote:

> Abhinav Srivastava wrote:
> > Hi Patrick,
> >
> > Thanks for your quick reply. I understood the
> first
> > part but did not get the second harder part
> > completely.
> >
> > Could you please shed some more light on that and
> also
> > it would be great if you could give me some
> pointer
> > for  target files that I may need to look into.
> >   
> 
> The NF_HOOK part: the okfn functions given to
> NF_HOOK in the bridge
> code don't actually continue the packet processing
> path as required
> for packet reinjection. Normally you'd have:
> 
> 
> static inline int finish_packet_processing(struct
> sk_buff *skb)
> {
>     <finish packet processing>
> }
> 
> static int process_packet(struct sk_buff *skb)
> {
>     ...
>     return NF_HOOK(...., finish_packet_processing);
> }
> 
> Look at net/ipv4/ip_input.c for an example. The
> bridging code does
> (in some spots at least) something like this:
> 
> static int br_handle_local_finish(struct sk_buff
> *skb)
> {
>         struct net_bridge_port *p =
> rcu_dereference(skb->dev->br_port);
> 
>         if (p)
>                 br_fdb_update(p->br, p,
> eth_hdr(skb)->h_source);
>         return 0;        /* process further */
> }
> 
> struct sk_buff *br_handle_frame(struct
> net_bridge_port *p, struct 
> sk_buff *skb)
> {
>     ...
>                 if (NF_HOOK(PF_BRIDGE,
> NF_BR_LOCAL_IN, skb, skb->dev,
>                             NULL,
> br_handle_local_finish))
>     ...
> }
> 
> When the queue handler calls nf_reinject, the packet
> goes to the
> okfn. In the case above that would be
> br_handle_local_finish(),
> which will simply update the fdb and return to
> nf_reinject,
> leaking the packet instead of continuing processing.
> 
> The code needs to be rearranged that in all NF_HOOK
> invocations
> the okfn takes ownership of the skb and continues
> processing.
> grep net/bridge for NF_HOOK for all spots to check
> (excluding
> br_netfilter.c).
> 
> The second part is simpler, __nf_queue() and
> nf_reinject()
> perform a lookup for afinfo of the packets protocol
> family
> and drop the packet if that lookup is unsucessful.
> For bridging
> there is no registered family, so the packet is
> always dropped.
> So these functions (net/netfilter/nf_queue.c) needs
> to be changed
> to handle the unsucessful lookup by avoiding
> rerouting.
> 
> 


Hi Patrick,

I tried to do what you said but some how could not
achieve it and since project deadlines are so pressing
I would like to achieve the same thing but from the
user space.

Inside the ebtables code, I intercept packets and send
it to userspace application, which decides whether to
accept the packet or drop it and re-inject it to the
network. I heard it can be done for iptables but can
it be done for ebtables?

I saw libipq which provides you functionality of
reinjecting the packets into ipfilters ip queue.

I would like to reinject the packet to ebtable
filtering code or if not then directly out to the
interface if I decide packet is to be accepted. Please
let me know if this deisgn is possible. I also ok with
passing the packet using libipq to ipfilters as long
as they can send the packet out to network. I just
want to achieve the complete design with minimum
hassle because of deadline.

I would really appreciate your help.

Thanks,
Abhinav



      5, 50, 500, 5000 - Store N number of mails in your inbox. Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html
