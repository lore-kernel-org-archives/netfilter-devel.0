From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [0/3] OSF: resurect skb fragmentation patch.
Date: Wed, 1 Jun 2005 03:55:34 +0400
Message-ID: <20050601035534.156b475c@zanzibar.2ka.mipt.ru>
References: <cede307105053115377afb8aac@mail.gmail.com>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <cede307105053115377afb8aac@mail.gmail.com>
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

Patch for fragmented skb was applied half of a year ago
against 2.4 sources instead of 2.6.
This one should be applied before others 4 in [*/3] OSF: series.

Thanks to Pavel Nekrasov for pointer.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
+++ mod/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
@@ -158,20 +158,30 @@
       int *hotdrop)
 {
 	struct ipt_osf_info *info = (struct ipt_osf_info *)matchinfo;
-	struct iphdr *ip = skb->nh.iph;
-	struct tcphdr *tcp;
+	struct iphdr _iph, *ip;
+	struct tcphdr _tcph, *tcp;
 	int fmatch = FMATCH_WRONG, fcount = 0;
 	unsigned long totlen, optsize = 0, window;
 	unsigned char df, *optp = NULL, *_optp = NULL;
+	unsigned char opts[MAX_IPOPTLEN];
 	char check_WSS = 0;
 	struct list_head *ent;
 	struct osf_finger *f;
+	int off;
 
-	if (!ip || !info)
+	if (!info)
+		return 0;
+	
+	off = 0;
+	
+	ip = skb_header_pointer(skb, off, sizeof(_iph), &_iph);
+	if (!ip)
 		return 0;
 				
-	tcp = (struct tcphdr *)((u_int32_t *)ip + ip->ihl);
-
+	tcp = skb_header_pointer(skb, off + ip->ihl * 4, sizeof(_tcph), &_tcph);
+	if (!tcp)
+		return 0;
+	
 	if (!tcp->syn)
 		return 0;
 	
@@ -181,8 +191,16 @@
 	
 	if (tcp->doff*4 > sizeof(struct tcphdr))
 	{
-		_optp = optp = (char *)(tcp+1);
 		optsize = tcp->doff*4 - sizeof(struct tcphdr);
+
+		if (optsize > sizeof(opts))
+		{
+			log("%s: BUG: too big options size: optsize=%lu, max=%d.\n",
+					__func__, optsize, sizeof(opts));
+			optsize = sizeof(opts);
+		}
+		
+		_optp = optp = skb_header_pointer(skb, off + ip->ihl*4 + sizeof(_tcph), optsize, opts);
 	}
 
 	/* Actually we can create hash/table of all genres and search
@@ -375,7 +393,7 @@
 		if (optp)
 		{
 			optsize = tcp->doff * 4 - sizeof(struct tcphdr);
-			if (skb_copy_bits(skb, ip->ihl*4 + sizeof(struct tcphdr),
+			if (skb_copy_bits(skb, off + ip->ihl*4 + sizeof(struct tcphdr),
 					  opt, optsize) < 0)
 			{
 				if (info->flags & IPT_OSF_LOG)






	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
