From: Steve Hill <steve@navaho.co.uk>
Subject: Conntrack leak (2.6.2rc2)
Date: Fri, 30 Jan 2004 15:09:01 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0401301500010.19876@sorbus2.navaho>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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


I'm using the 2.6.2rc2 kernel and have a strange connection tracking 
problem - when using unfragmented packets every thing is fine - a new 
connection is made and init_conntrack() is called, and as the session is 
timed out by conntrack, destroy_conntrack() is called.  Absolutely fine.

However, if I start a connection with a fragmented packet (i.e. my MTU 
is 1500 bytes, so "ping -c 1 -s 2500 172.16.0.1" sends a packet consisting 
of 2 fragments), init_conntrack() is called as usual, but when the session 
is timed out destroy_conntrack() never gets called.  This means that the 
memory for the connection is never freed and ip_conntrack_count is never 
decremented.  However, the connection is still removed from the hash 
table.  This means that it leaks memory, and eventually reaches 
ip_conntrack_max and starts dropping new connections.

Another oddity I came across while trying to debug the problem is that 
__kfree_skb() seems to be getting called very frequently, even when the 
network is completely idle - is that right?


- Steve Hill
Senior Software Developer                        Email: steve@navaho.co.uk
Navaho Technologies Ltd.                           Tel: +44-870-7034015

        ... Alcohol and calculus don't mix - Don't drink and derive! ...
