From: Willy TARREAU <willy@w.ods.org>
Subject: Re: [PATCH-2.4.26] ip6tables cleanup
Date: Mon, 29 Mar 2004 00:38:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040328223805.GA27147@pcw.home.local>
References: <20040328042608.GA17969@logos.cnet> <20040328115439.GA24421@pcw.home.local> <m2d66wsrg2.fsf@p4.localdomain> <20040328200932.GA19852@pcw.home.local> <20040328123318.63c54ee8.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: petero2@telia.com, marcelo.tosatti@cyclades.com,
   linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20040328123318.63c54ee8.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

David,

I sent last one too quickly, it needs this one to compile :

diff -urN linux-2.4.26-rc1/include/net/ipv6.h linux-2.4.26-rc1-ipv6/include/net/ipv6.h
--- linux-2.4.26-rc1/include/net/ipv6.h	Mon Mar 29 00:18:38 2004
+++ linux-2.4.26-rc1-ipv6/include/net/ipv6.h	Mon Mar 29 00:36:39 2004
@@ -321,8 +321,8 @@
 						    struct ipv6_txoptions *opt,
 						    u8 *proto);
 
-extern int			ipv6_skip_exthdr(struct sk_buff *, int start,
-					         u8 *nexthdrp, int len);
+extern int			ipv6_skip_exthdr(const struct sk_buff *,
+					int start, u8 *nexthdrp, int len);
 
 extern int 			ipv6_ext_hdr(u8 nexthdr);
 

Sorry for the noise,
Willy
