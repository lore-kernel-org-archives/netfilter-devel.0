From: zhi wang <pangy2004@yahoo.com>
Subject: What is the good of find_appropriate_src?
Date: Mon, 29 Mar 2004 21:58:08 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040330055808.97213.qmail@web41703.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

find_appropriate_src is a function in ip_nat_core.c.
What is this function for? Although  confused, I
figured the following facts about this function(only
udp is consided):

1. The packet hit a SNAT target.
2. There is already a NATed connection. It has the
same srcip/proto/src-proto-part, and the connection's
srcip/proto/src-proto-part is in ip_nat_multi_range.
3. The very same srcip/proto/src-proto-part are kept
intacted.

In short, "If this srcip/proto/src-proto-part is
currently mapped, and that same mapping gives a unique
tuple within the given range, use that"

I don't know under what condition the No.1 and No.2
conditions will be fulfilled. I also notice, that when
this function is called, only nat table is locked, but
conntrak table is not locked. I suspet that there
could be a race condition here in SMP machines with
some odd configuration. And if that race condition
occurs, get_unique_tuple will be called over and over
again until the racing conntrack entry times out. 

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
