From: don-netfil@isis.cs3-inc.com (Don Cohen)
Subject: Re: SNAT and IP ID -> what can be mangled by routers?
Date: Sun, 4 May 2003 12:14:12 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <16053.26244.510867.656383@isis.cs3-inc.com>
References: <20030502222622.31281.56108.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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


This question reminds me of something I've been wondering about.
It seems to me that some parts of an IP packet can be arbitrarily
changed by the forwarding infrastructure.
The TOS field seems like one good example.  When I send a packet to
my ISP it can (I believe, or at least should be allowed to) change
the TOS field as it wishes to influence where and when that packet
is forwarded.  What arrives at the ultimate destination need not bear 
any resemblance to what I sent.
The possible danger I see from this is that, after the TOS is altered,
some router might decide to send me an ICMP reply saying that it could
not forward this packet.  This means that when I receive that reply I
should NOT expect the TOS field in the reply (I mean the one in the
ICMP content part containing the beginning of the packet as it was
received at that router) to be the same as the one I sent.
Clearly I should expect the TTL to also be different.
Perhaps I should also not expect, e.g., the IP ID field to be the
same?  If I can rely on the ID field to be the same then it becomes
an expensive proposition to mangle IDs at the firewall since you have
to be able to UNmangle the ICMP replies, which requires possibly a lot
of memory.

The linux source appears to me to identify icmp packets only by source
and destination IP addresses and ports (and something else I don't
quite understand - arrival interface?  Can someone explain this?).
So if the TOS or ID were mangled on the way to the router sending the
reply this would have no effect, I believe.  (Any other opinions?)

The real question:
Are there any standards that indicate what parts of the ICMP reply the
recipient can count on to be the same as the packet originally sent?
If so, which are they and what do they say?
