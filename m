From: "Colin Paton" <cozzarp@hotmail.com>
Subject: How to make conntrack ignore packets on certain interfaces?
Date: Wed, 23 Jun 2004 15:20:30 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY22-F9OxHp2sdp2Mn0009ff98@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

With the aid of someone on this mailing list I've figured out why the PPTP 
connection tracking wasn't working correctly with tun interfaces. I have 
created a really hacky solution which fixes the problem - but it's extremely 
inelegant and I think there must be a better way.

To recap:

- Packets come in through an eth1.6 interface. This interface has no IP 
address assigned; packets are read from it using a user-space program. This 
program can perform certain packet mangling, and it then reinjects the 
packets back into a tap interface. Netfilter/IP tables are then used to 
route packets and do NAT, etc as usual.

Connection tracking wasn't correctly working with this scenario. It would 
appear that a conntrack was created when the packet arrived, but was then 
removed as the incoming packet was never routed through the kernel.

My evil hack which fixes things was just to ignore traffic on the incoming 
interface - this way, packets reinjected via the tap interface would be 
tracked, which is what is wanted.

My hack therefore looks like (from the code in ip_conntrack_core.c):

/* Netfilter hook itself. */
unsigned int ip_conntrack_in(unsigned int hooknum,
			     struct sk_buff **pskb,
			     const struct net_device *in,
			     const struct net_device *out,
			     int (*okfn)(struct sk_buff *))
{
	struct ip_conntrack *ct;
	enum ip_conntrack_info ctinfo;
	struct ip_conntrack_protocol *proto;
	int set_reply;
	int ret;

	/* FIXME: Do this right please. --RR */
	(*pskb)->nfcache |= NFC_UNKNOWN;


+	/* cpaton hack stuff begins here... */
+       if (in && (!strcmp(in->name,"eth1.6")))
+	  {
+	    printk("ip_conntrack_in - ignoring packet on interface 
%s\n",in->name);
+           return NF_ACCEPT;
+	  }

....so that packets coming in on the eth1.6 interface aren't tracked. NAT 
now works well.

I've been trying to think of a better way of doing this, but nothing jumps 
out at me - connection tracking seems to have its own hook into netfilter, 
so most iptables rules won't have any effect.

The options I've considered are:

- Register a higher-priority netfilter hook which is called before 
conntrack_in() - this somehow(?!) causes the packet to jump over netfilter. 
I'm not sure if 'jumping' over netfilter hooks is possible however.
- Tell the conntrack code (somehow) to ignore packet coming on eth1.6. While 
it seems that iptables can read the connection tracking state I don't think 
it can alter it.

I'm not sure if this is at all possible - is it possible to replicate my 
evil hack using a better method?

Thanks,

Colin

_________________________________________________________________
It's fast, it's easy and it's free. Get MSN Messenger today! 
http://www.msn.co.uk/messenger
