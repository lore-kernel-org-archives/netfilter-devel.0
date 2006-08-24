From: Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: [PATCH 3/3][CONNTRACK] Fix race condition in early drop
Date: Thu, 24 Aug 2006 15:02:59 +0200
Message-ID: <eck80r$hbo$1@sea.gmane.org>
References: <44E97335.1080105@netfilter.org>	<200608220435.k7M4ZSLf001686@toshiba.co.jp>	<44EB0ACA.8080109@netfilter.org>
	<eck3j5$20q$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040503000408090307010206"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <eck3j5$20q$1@sea.gmane.org>
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
--------------040503000408090307010206
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

On 24-08-2006 13:47, Jarek Poplawski wrote:
...

Sorry again, I'm definitely too fresh. It should be even shorter:

Jarek P.

--------------040503000408090307010206
Content-Type: text/plain;
 name="nf_conntrack_core-2.6.18-rc4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf_conntrack_core-2.6.18-rc4.diff"

--- linux-2.6.18-rc4/net/netfilter/nf_conntrack_core.c-	2006-08-22 07:55:25.000000000 +0200
+++ linux-2.6.18-rc4/net/netfilter//nf_conntrack_core.c	2006-08-24 13:34:43.000000000 +0200
@@ -905,6 +906,12 @@
 		goto out;
 	}
 
+	if (!atomic_add_unless(&nf_conntrack_count, 1, nf_conntrack_max) {
+		kmem_cache_free(nf_ct_cache[features].cachep, conntrack);
+		conntrack = NULL;
+		goto out;
+	}
+
 	memset(conntrack, 0, nf_ct_cache[features].size);
 	conntrack->features = features;
 	if (helper) {
@@ -922,7 +929,6 @@
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	atomic_inc(&nf_conntrack_count);
 out:
 	read_unlock_bh(&nf_ct_cache_lock);
 	return conntrack;

--------------040503000408090307010206--
