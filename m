From: James Morris <jmorris@intercode.com.au>
Subject: Re: ip_queue, is this safe:
Date: Sat, 2 Aug 2003 01:25:18 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0308020114120.29556-100000@excalibur.intercode.com.au>
References: <3F2A460A.5050005@lf.lv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peteris Krumins <peteris@lf.lv>
In-Reply-To: <3F2A460A.5050005@lf.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 1 Aug 2003, Peteris Krumins wrote:

>   i am doubting:
>   tcp = (struct tcphdr *)(packet->payload + ip->ihl*4);

To start with, this pointer arithmetic is incorrect, you need something 
like:

	tcph = (void *) iph + iph->ihl * 4;

> 
>   because ip->ihl could be faked, couldnt it? The packet would get queued
>   and if ip->ihl is something faked, using the tcp pointer i'd get a
>   segfault, wouldn't i?

The kernel drops received packets with a too-large ihl before the
prerouting hook.  For locally generated packets of this type (e.g. root is
playing games with raw sockets), iptables 'accepts' them without 
traversing any more rules on the chain -- they won't make it to the 
QUEUE target.

You will however need to validate any transport+ header lengths against 
the length of the packet.


- James
-- 
James Morris
<jmorris@intercode.com.au>
