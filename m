From: Stelios Sidiroglou-Douskos <ss1759@cs.columbia.edu>
Subject: IPIP and SNAT
Date: Wed, 30 Jul 2003 11:37:23 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.31.0307301130240.13487-100000@disco.cs.columbia.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I am having some trouble with SNAT and my IPIP implementation. I have the
ipip part working (I use code from ipip.c) but when I clear the nfct field
of the sk_buff that packet that gets fwd to the other interface doesn't
get NATed. I tried not clearing conntrack but obviously that results in
the packets not matching up when they return.

Do I have to rebuild the conntrack tuple and insert it back? If so, is
there a code or a helper function to do just that?

thanks in advance,

stelios.


p.s Please reply to this address directly also.
