From: Philip Craig <philipc@snapgear.com>
Subject: tcp match silently drops packets
Date: Mon, 10 Oct 2005 13:01:14 +1000
Message-ID: <4349D97A.9070708@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

If you send a 20 byte IP packet that has the protocol set to 6,
(ie TCP packet with no TCP header) then the following rule will match:

iptables -I FORWARD -p tcp

and the following rule will match and silently drop the packet:

iptables -I FORWARD -p tcp --syn

I think the behaviour of the first rule is fine, but the second one
should simply not match.  These packets probably should be dropped,
but this is a policy decision, and shouldn't be implemented in the
tcp match.  And if it must drop it, then a log message or counter
somewhere would be nice.

Conntracking marks the packet as INVALID, so you can use that to
drop it, and also log it if desired.

This isn't a big issue for me.  I had a TCPMSS rule before the INVALID
check, so I just need to reorder that.

There is a similar issue in TCPMSS itself: it has a few tests
that drop the packet.  In particular, it drops TCP SYN packets that
contain data.  Since TCPMSS isn't a firewall match (it is a hack to
try to avoid dropped packets), I don't think it makes sense for
it to drop packets that it can't handle.  I can submit a patch for
this if needed.

(Note: I tested this on 2.4.31.  There was some change to the tcp
hotdrop code as part of the skb linearization in 2.6, but from
reading the code, the behaviour looks the same.)
