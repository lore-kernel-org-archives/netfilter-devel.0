From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC, PATCH 5/5]: netfilter+ipsec - policy checks
Date: Sat, 20 Mar 2004 16:58:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <405C6A2F.80206@trash.net>
References: <20040308110331.GA20719@gondor.apana.org.au> <404C874D.4000907@trash.net> <20040308115858.75cdddca.davem@redhat.com> <4059CF27.4030803@trash.net> <20040318221904.45011167.davem@redhat.com> <20040319063143.GC29442@samad.com.au> <20040320055811.GG29442@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030104050609060706060509"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20040320055811.GG29442@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030104050609060706060509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Alexander Samad wrote:
> Done some more testing and there seems to be a problem with the NAT
> table 
> 

Thanks for the report, does this patch fix it ?

Regards
Patrick

--------------030104050609060706060509
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/raw.c 1.44 vs edited =====
--- 1.44/net/ipv4/raw.c	Thu Mar 18 16:44:12 2004
+++ edited/net/ipv4/raw.c	Sat Mar 20 16:57:24 2004
@@ -257,6 +257,12 @@
 	return 0;
 }
 
+static inline int ip_dst_output(struct sk_buff *skb)
+{
+	return NF_HOOK_COND(PF_INET, NF_IP_POST_ROUTING, skb, NULL,
+	                    skb->dst->dev, dst_output, skb->dst->xfrm != NULL);
+}
+
 static int raw_send_hdrinc(struct sock *sk, void *from, int length,
 			struct rtable *rt, 
 			unsigned int flags)
@@ -308,7 +314,7 @@
 	}
 
 	err = NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, rt->u.dst.dev,
-		      dst_output);
+		      ip_dst_output);
 	if (err > 0)
 		err = inet->recverr ? net_xmit_errno(err) : 0;
 	if (err)

--------------030104050609060706060509--
