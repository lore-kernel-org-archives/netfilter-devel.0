From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3][CTNETLINK] Atomically set/unset status bits
Date: Tue, 28 Nov 2006 19:31:07 +0100
Message-ID: <456C806B.9060806@netfilter.org>
References: <456C7606.4020504@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030904070708010208000804"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <456C7606.4020504@netfilter.org>
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

This is a multi-part message in MIME format.
--------------030904070708010208000804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> This patch guarantees that status bits are atomically set/unset. A minor
> cleanup to save one extra useless line in the code is introduced.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Sorry again, wrong patch :(, attached the one appropiated.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------030904070708010208000804
Content-Type: text/plain;
 name="02status-racy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02status-racy.patch"

[CTNETLINK] Atomically set/unset status bits

This patch guarantees that status bits are atomically set/unset. A minor
cleanup to save one extra useless line in the code is introduced.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: linux-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-11-28 16:39:37.000000000 +0100
+++ linux-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-11-28 17:48:48.000000000 +0100
@@ -770,6 +770,7 @@ out:
 static inline int
 ctnetlink_change_status(struct ip_conntrack *ct, struct nfattr *cda[])
 {
+	int i;
 	unsigned long d;
 	unsigned status = ntohl(*(__be32 *)NFA_DATA(cda[CTA_STATUS-1]));
 	d = ct->status ^ status;
@@ -782,7 +783,6 @@ ctnetlink_change_status(struct ip_conntr
 		/* SEEN_REPLY bit can only be set */
 		return -EINVAL;
 
-	
 	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
 		/* ASSURED bit can only be set */
 		return -EINVAL;
@@ -814,10 +814,16 @@ ctnetlink_change_status(struct ip_conntr
 #endif
 	}
 
-	/* Be careful here, modifying NAT bits can screw up things,
-	 * so don't let users modify them directly if they don't pass
-	 * ip_nat_range. */
-	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
+	d &= ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
+
+	for (i = 0; i < sizeof(ct->status); i++)
+		if (d & (1 << i)) {
+			if (status & (1 << i))
+				set_bit(i, &ct->status);
+			else
+				clear_bit(i, &ct->status);
+		}
+
 	return 0;
 }
 
Index: linux-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2006-11-28 16:52:13.000000000 +0100
+++ linux-2.6.git/net/netfilter/nf_conntrack_netlink.c	2006-11-28 17:48:56.000000000 +0100
@@ -779,6 +779,7 @@ out:
 static inline int
 ctnetlink_change_status(struct nf_conn *ct, struct nfattr *cda[])
 {
+	int i;
 	unsigned long d;
 	unsigned status = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
 	d = ct->status ^ status;
@@ -791,7 +792,6 @@ ctnetlink_change_status(struct nf_conn *
 		/* SEEN_REPLY bit can only be set */
 		return -EINVAL;
 
-	
 	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
 		/* ASSURED bit can only be set */
 		return -EINVAL;
@@ -823,10 +823,16 @@ ctnetlink_change_status(struct nf_conn *
 #endif
 	}
 
-	/* Be careful here, modifying NAT bits can screw up things,
-	 * so don't let users modify them directly if they don't pass
-	 * ip_nat_range. */
-	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
+	d &= ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
+
+	for (i = 0; i < sizeof(ct->status); i++)
+		if (d & (1 << i)) {
+			if (status & (1 << i))
+				set_bit(i, &ct->status);
+			else
+				clear_bit(i, &ct->status);
+		}
+
 	return 0;
 }
 

--------------030904070708010208000804--
