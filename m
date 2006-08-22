From: Stuart Zilm <szilm@presinet.com>
Subject: adding data fields to netfilter_conntrack / conntrack events
Date: Tue, 22 Aug 2006 15:41:07 -0700
Message-ID: <34ABBC54-DD57-407D-86CF-C4FB5FB24AEA@presinet.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I'm trying to add some more data to that which gets passed across the  
netlink socket for conntrack events, but can't seem to get the data  
from the kernel to arrive in userspace.

I've added the following to net/ipv4/netfilter/ip_conntrack_netlink.c:

static inline int
ctnetlink_dump_foo(struct sk_buff *skb, const struct ip_conntrack *ct)
{
	char dummy[sizeof(struct timeval)] = {0xde, 0xad, 0xde, 0xad, 0xde,  
0xad, 0xde, 0xad};

	NFA_PUT(skb, CTA_FOO, sizeof(struct timeval), dummy);
	
	return 0;

nfattr_failure:
         printk("<6>ctnetlink_dump_foo: nfattr_failure\n");
         return -1;
}

// note that CTA_FOO = 13

and ensured it is called within ctnetlink_conntrack_event(...).  A  
raw dump of the skb to be send over the netlink socket confirms the  
magic number at the end of the packet.

However, on the userspace side (conntrack-1.00beta1,  
libnetfilter_conntrack-0.0.30, libnfnetlink-0.0.14), the data does  
not seem to arrive correctly.  Calling nfnl_dump_packet(...) on the  
nlmsghdr within nfnl_listen(...) in libnfnetlink.c indicates that the  
payload should contain the data:
...
nfa@0xbfdfa9c4: nfa_type=13, nfa_len=12
...

but there are only zeroes where the magic number should be!

Can anyone help me to understand why this data is not traversing the  
netlink socket intact from kernel space to user space?
Thank you for any assistance,

Stuart Zilm
PresiNET Systems
