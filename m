From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: memcmp() is slow?
Date: Sat, 22 Jan 2005 21:31:52 +0100
Message-ID: <69935817.20050122213152@dns.toxicfilms.tv>
References: <E1CsQZH-0002AE-Ob@vishnu.netfilter.org>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <E1CsQZH-0002AE-Ob@vishnu.netfilter.org>
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

Hi,

I have seen a patch that replaces memcmp() with a few comparison statements.
The log for the change says that memcmp() is slow.

Why is it? Is it just due to the overhead of calling a function and going
through the memory in a loop? Or are there other issues I am not aware of.

Ragards,
Maciej

Below is the mention patch:

trunk/patch-o-matic-ng/nf_conntrack/linux-2.6/include/linux/netfilter/nf_conntrack_tuple.h
2005-01-22 19:05:07 UTC (rev 3607)
@@ -142,19 +142,25 @@
 static inline int nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
                                        const struct nf_conntrack_tuple *t2)
 {
-       return (!memcmp(t1->src.u3.all, t2->src.u3.all, sizeof(t1->src.u3.all)))
-              && (t1->src.u.all == t2->src.u.all)
-              && (t1->src.l3num == t2->src.l3num)
-              && (t1->dst.protonum == t2->dst.protonum);
+       return (t1->>src.u3.all[0] == t2->src.u3.all[0] &&
+               t1->>src.u3.all[1] == t2->src.u3.all[1] &&
+               t1->>src.u3.all[2] == t2->src.u3.all[2] &&
+               t1->>src.u3.all[3] == t2->src.u3.all[3] &&
+               t1->>src.u.all == t2->src.u.all &&
+               t1->>src.l3num == t2->src.l3num &&
+               t1->>dst.protonum == t2->dst.protonum);
>  }
