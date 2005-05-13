From: Thomas Kling <thomasmkling@yahoo.de>
Subject: tcp conntrack logging
Date: Fri, 13 May 2005 15:04:25 +0200
Message-ID: <1233091063.20050513150425@vuni.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello,

I want to write an extended logging of TCP-Connections: iptables -A INPUT -j LOGTCP

LOGTCP should just be a copy of ipt_LOG.c: 

/* --------copy------------
static void dump_packet(const struct ipt_log_info *info, const struct sk_buff *skb, unsigned int iphoff)
{
...
case IPPROTO_TCP: {
struct tcphdr _tcph, *th;
 
/* Max length: 10 "PROTO=TCP " */
printk("PROTO=TCP ");
... 
[*]
...
break;
--------copy------------ /*

And here [*] I want to call some functions from tcp_conntrack:
printk("tcp_in_window, sender->td_end, sender->td_maxend, sender->maxwin, receiver->td_end, receiver->td_maxend, receiver->td_maxwin);

The problem: I just don't know how to access these values from there.
I looked through several other modules that use ip_conntrack, but
didn't find the idea to get started.



[sorry if this appears twice, the first text got somehow lost]
