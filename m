From: "David S. Miller" <davem@redhat.com>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Fri, 5 Dec 2003 12:28:19 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031205122819.25ac14ab.davem@redhat.com>
References: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD1F@orsmsx402.jf.intel.com>
	<20031204213030.2B75.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: scott.feldman@intel.com, laforge@netfilter.org,
        netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Lee <mukansai@emailplus.org>
In-Reply-To: <20031204213030.2B75.MUKANSAI@emailplus.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 04 Dec 2003 21:36:09 +0900
Stephen Lee <mukansai@emailplus.org> wrote:

> "Feldman, Scott" <scott.feldman@intel.com> wrote:
> > 
> > Try turning off TSO by disabling this code or by using "ethtool -K tso
> > off" (need version 1.8).
> 
> Yes, turning off TSO with ethtool fixed it (tested on 2.6.0-test11).  At
> least we have a workaround now.

OK, I've found out what IP conntack does that creates the problems.

In fact, it's a bug in conntrack and this ends up corrupting the TSO
packet.  This forces TSO-disabling on that connection, and
retransmission of all the data.  Then the data flows correctly so TSO
is re-enabled, and on and on and on like this.  Performance goes into
the toilet.

The culprit is net/ipv4/netfilter/ip_conntrack_standalone.c,
in ip_refrag(), it does this:

        if ((*pskb)->len > dst_pmtu(&rt->u.dst)) {
                /* No hook can be after us, so this should be OK. */
                ip_fragment(*pskb, okfn);
                return NF_STOLEN;
        }

Which fragments TSO packets, oops :)

People can confirm this analysis by applying the patch below, enabling
TSO with conntrack loaded, and see if the problem goes away.

Some auditing is definitely necessary wrt. TSO and netfilter.  In particular
I am incredibly confident that we have issues in cases like when the FTP
netfilter modules mangle the data.  Another area for inspection are the
cases where TCP header bits are changed and thus the checksum needs to
be adjusted.

===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.22 vs edited =====
--- 1.22/net/ipv4/netfilter/ip_conntrack_standalone.c	Thu Oct  2 23:21:19 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	Fri Dec  5 12:25:22 2003
@@ -201,7 +201,8 @@
 	/* Local packets are never produced too large for their
 	   interface.  We degfragment them at LOCAL_OUT, however,
 	   so we have to refragment them here. */
-	if ((*pskb)->len > dst_pmtu(&rt->u.dst)) {
+	if ((*pskb)->len > dst_pmtu(&rt->u.dst) &&
+	    !skb_shinfo(*pskb)->tso_size) {
 		/* No hook can be after us, so this should be OK. */
 		ip_fragment(*pskb, okfn);
 		return NF_STOLEN;
