From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: Mangle on a Connection, not on a Packet
Date: Fri, 17 Oct 2003 15:10:39 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310170510.h9H5Adv17981@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > possible?  (and I'd need that mark to be made free when
> > the connection is removed from netfilter).
> 
> Then you need something a little more advanced than CONNMARK I think.

ok ..

 
> From your description it sounds like you could be using the conntract 
> handle as is. This will give you an arbitrary integer of size (void *).

Hmm .. this would be good ...
 
> The conntrack mark is available as ct->mark.
> 
> Examle code snipped accessing the conntrack mark:
> 
>       enum ip_conntrack_info ctinfo;
>       struct ip_conntrack *ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
>       if (!ct)
>           return 0;
> 
>       mark = ct->mark;

This was the bit that had me thinking .. if this was implemented in the XOR
target .. with rules sending NEW and other traffic to that target .. then
unmarked conns could be marked (and seeds could be seeded) while
marked ones could be referenced and dealt with ..

The only issue that would be left then is removed connections .. is there
a substantial scratch space available within the conntrack structure(s) ?
Ie; would I be able to attach the key to the connection, such that when the
connection is destroyed I don't need to worry about deallocating structures
or structure memory within the target ?   Or would this be something that
I would (or should) need to add to ip_conntrack.h ..   like ..

+#if defined(CONFIG_IP_NF_CONNTRACK_CRYPTO)
+	unsigned long key_xor;
+#endif


Hmm .. I think I'm almost there .. thanks for your help Henrick.




--
Ian Latter
Internet and Networking Security Officer
Macquarie University
