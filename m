From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/3] OSF: code beautification.
Date: Mon, 30 May 2005 00:20:00 +0400
Message-ID: <20050530002000.4c63b34b@zanzibar.2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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

{ placement, copyright data change, list_for_each_entry usage.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
+++ mod/owf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
@@ -1,7 +1,7 @@
 /*
  * ipt_osf.c
  *
- * Copyright (c) 2003 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2003-2005 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
  *
  *
  * This program is free software; you can redistribute it and/or modify
@@ -102,8 +102,7 @@
 	size = NLMSG_SPACE(sizeof(struct ipt_osf_nlmsg));
 
 	skb = alloc_skb(size, GFP_ATOMIC);
-	if (!skb)
-	{
+	if (!skb) {
 		log("skb_alloc() failed.\n");
 		return;
 	}
@@ -127,14 +126,11 @@
 {
 	struct iphdr *ip = skb->nh.iph;
 
-	if (flags & IPT_OSF_SMART)
-	{
+	if (flags & IPT_OSF_SMART) {
 		struct in_device *in_dev = in_dev_get(skb->dev);
 
-		for_ifa(in_dev)
-		{
-			if (inet_ifa_match(ip->saddr, ifa))
-			{
+		for_ifa(in_dev) {
+			if (inet_ifa_match(ip->saddr, ifa)) {
 				in_dev_put(in_dev);
 				return (ip->ttl == f_ttl);
 			}
@@ -162,7 +158,6 @@
 	unsigned char df, *optp = NULL, *_optp = NULL;
 	unsigned char opts[MAX_IPOPTLEN];
 	char check_WSS = 0;
-	struct list_head *ent;
 	struct osf_finger *f;
 	int off;
 
@@ -186,12 +181,10 @@
 	df = ((ntohs(ip->frag_off) & IP_DF)?1:0);
 	window = ntohs(tcp->window);
 	
-	if (tcp->doff*4 > sizeof(struct tcphdr))
-	{
+	if (tcp->doff*4 > sizeof(struct tcphdr)) {
 		optsize = tcp->doff*4 - sizeof(struct tcphdr);
 
-		if (optsize > sizeof(opts))
-		{
+		if (optsize > sizeof(opts)) {
 			log("%s: BUG: too big options size: optsize=%lu, max=%d.\n",
 					__func__, optsize, sizeof(opts));
 			optsize = sizeof(opts);
@@ -205,9 +198,7 @@
 	 * so will use slow path.
 	 */
 	read_lock(&osf_lock);
-	list_for_each(ent, &finger_list)
-	{
-		f = list_entry(ent, struct osf_finger, flist);
+	list_for_each_entry(f, &finger_list, flist) {
 	
 		if (!(info->flags & IPT_OSF_LOG) && strcmp(info->genre, f->genre)) 
 			continue;
@@ -216,16 +207,14 @@
 		fmatch = FMATCH_WRONG;
 
 		if (totlen == f->ss && df == f->df && 
-			smart_dec(skb, info->flags, f->ttl))
-		{
+			smart_dec(skb, info->flags, f->ttl)) {
 			unsigned long foptsize;
 			int optnum;
 			unsigned short mss = 0;
 
 			check_WSS = 0;
 
-			switch (f->wss.wc)
-			{
+			switch (f->wss.wc) {
 				case 0:	  check_WSS = 0; break;
 				case 'S': check_WSS = 1; break;
 				case 'T': check_WSS = 2; break;
@@ -248,8 +237,7 @@
 			if (foptsize > MAX_IPOPTLEN || optsize > MAX_IPOPTLEN || optsize != foptsize)
 				continue;
 
-			if (!optp)
-			{
+			if (!optp) {
 				fmatch = FMATCH_OK;
 				loga("\tYEP : matching without options.\n");
 				if ((info->flags & IPT_OSF_LOG) && 
@@ -258,12 +246,9 @@
 				else
 					continue;
 			}
-			
 
-			for (optnum=0; optnum<f->opt_num; ++optnum)
-			{
-				if (f->opt[optnum].kind == (*optp)) 
-				{
+			for (optnum=0; optnum<f->opt_num; ++optnum) {
+				if (f->opt[optnum].kind == (*optp)) {
 					unsigned char len = f->opt[optnum].length;
 					unsigned char *optend = optp + len;
 					int loop_cont = 0;
@@ -271,8 +256,7 @@
 					fmatch = FMATCH_OK;
 
 
-					switch (*optp)
-					{
+					switch (*optp) {
 						case OSFOPT_MSS:
 							mss = ntohs(*(unsigned short *)(optp+2));
 							break;
@@ -281,19 +265,16 @@
 							break;
 					}
 					
-					if (loop_cont)
-					{
+					if (loop_cont) {
 						optp = optend;
 						continue;
 					}
 					
-					if (len != 1)
-					{
+					if (len != 1) {
 						/* Skip kind and length fields*/
 						optp += 2; 
 
-						if (f->opt[optnum].wc.val != 0)
-						{
+						if (f->opt[optnum].wc.val != 0) {
 							unsigned long tmp = 0;
 							
 							/* Hmmm... It looks a bit ugly. :) */
@@ -307,8 +288,7 @@
 							else
 								tmp = ntohl(tmp);
 
-							if (f->opt[optnum].wc.wc == '%')
-							{
+							if (f->opt[optnum].wc.wc == '%') {
 								if ((tmp % f->opt[optnum].wc.val) != 0)
 									fmatch = FMATCH_OPT_WRONG;
 							}
@@ -318,20 +298,17 @@
 					}
 
 					optp = optend;
-				}
-				else
+				} else
 					fmatch = FMATCH_OPT_WRONG;
 
 				if (fmatch != FMATCH_OK)
 					break;
 			}
 
-			if (fmatch != FMATCH_OPT_WRONG)
-			{
+			if (fmatch != FMATCH_OPT_WRONG) {
 				fmatch = FMATCH_WRONG;
 
-				switch (check_WSS)
-				{
+				switch (check_WSS) {
 					case 0:
 						if (f->wss.val == 0 || window == f->wss.val)
 							fmatch = FMATCH_OK;
@@ -356,8 +333,7 @@
 			}
 					
 
-			if (fmatch == FMATCH_OK)
-			{
+			if (fmatch == FMATCH_OK) {
 				fcount++;
 				log("%s [%s:%s:%s] : %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u hops=%d\n", 
 					f->genre, f->version,
@@ -365,8 +341,7 @@
 					NIPQUAD(ip->saddr), ntohs(tcp->source),
 					NIPQUAD(ip->daddr), ntohs(tcp->dest),
 					f->ttl - ip->ttl);
-				if (info->flags & IPT_OSF_NETLINK)
-				{
+				if (info->flags & IPT_OSF_NETLINK) {
 					spin_lock_bh(&ipt_osf_netlink_lock);
 					ipt_osf_nlsend(f, skb);
 					spin_unlock_bh(&ipt_osf_netlink_lock);
@@ -377,8 +352,7 @@
 			}
 		}
 	}
-	if (!fcount && (info->flags & (IPT_OSF_LOG | IPT_OSF_NETLINK)))
-	{
+	if (!fcount && (info->flags & (IPT_OSF_LOG | IPT_OSF_NETLINK))) {
 		unsigned char opt[4 * 15 - sizeof(struct tcphdr)];
 		unsigned int i, optsize;
 		struct osf_finger fg;
@@ -387,21 +361,16 @@
 
 		if ((info->flags & IPT_OSF_LOG))
 			log("Unknown: %lu:%d:%d:%lu:", window, ip->ttl, df, totlen);
-		if (optp)
-		{
+		if (optp) {
 			optsize = tcp->doff * 4 - sizeof(struct tcphdr);
 			if (skb_copy_bits(skb, off + ip->ihl*4 + sizeof(struct tcphdr),
-					  opt, optsize) < 0)
-			{
+					  opt, optsize) < 0) {
 				if (info->flags & IPT_OSF_LOG)
 					loga("TRUNCATED");
 				if (info->flags & IPT_OSF_NETLINK)
 					strcpy(fg.details, "TRUNCATED");
-			}
-			else
-			{
-				for (i = 0; i < optsize; i++)
-				{
+			} else {
+				for (i = 0; i < optsize; i++) {
 					if (info->flags & IPT_OSF_LOG)
 						loga("%02X", opt[i]);
 				}
@@ -414,8 +383,7 @@
 				NIPQUAD(ip->saddr), ntohs(tcp->source),
 				NIPQUAD(ip->daddr), ntohs(tcp->dest));
 		
-		if (info->flags & IPT_OSF_NETLINK)
-		{
+		if (info->flags & IPT_OSF_NETLINK) {
 			fg.wss.val 	= window;
 			fg.ttl		= ip->ttl;
 			fg.df		= df;
@@ -489,31 +457,26 @@
 
 	ptr = &obuf[0];
 	i = 0;
-	while (ptr != NULL && i < olen)
-	{
+	while (ptr != NULL && i < olen) {
 		val = 0;
 		op = 0;
 		wc = 0;
-		switch (obuf[i])
-		{
+		switch (obuf[i]) {
 			case 'N': 
 				op = OSFOPT_NOP;
 				ptr = osf_strchr(&obuf[i], OPTDEL);
-				if (ptr)
-				{
+				if (ptr) {
 					*ptr = '\0';
 					ptr++;
 					i += (int)(ptr-&obuf[i]);
 
-				}
-				else
+				} else
 					i++;
 				break;
 			case 'S': 
 				op = OSFOPT_SACKP;
 				ptr = osf_strchr(&obuf[i], OPTDEL);
-				if (ptr)
-				{
+				if (ptr) {
 					*ptr = '\0';
 					ptr++;
 					i += (int)(ptr-&obuf[i]);
@@ -525,23 +488,19 @@
 			case 'T': 
 				op = OSFOPT_TS;
 				ptr = osf_strchr(&obuf[i], OPTDEL);
-				if (ptr)
-				{
+				if (ptr) {
 					*ptr = '\0';
 					ptr++;
 					i += (int)(ptr-&obuf[i]);
 
-				}
-				else
+				} else
 					i++;
 				break;
 			case 'W': 
 				op = OSFOPT_WSO;
 				ptr = osf_strchr(&obuf[i], OPTDEL);
-				if (ptr)
-				{
-					switch (obuf[i+1])
-					{
+				if (ptr) {
+					switch (obuf[i+1]) {
 						case '%':	wc = '%'; break;
 						case 'S':	wc = 'S'; break;
 						case 'T':	wc = 'T'; break;
@@ -556,15 +515,13 @@
 						val = simple_strtoul(&obuf[i+1], NULL, 10);
 					i += (int)(ptr-&obuf[i]);
 
-				}
-				else
+				} else
 					i++;
 				break;
 			case 'M': 
 				op = OSFOPT_MSS;
 				ptr = osf_strchr(&obuf[i], OPTDEL);
-				if (ptr)
-				{
+				if (ptr) {
 					if (obuf[i+1] == '%')
 						wc = '%';
 					*ptr = '\0';
@@ -575,32 +532,27 @@
 						val = simple_strtoul(&obuf[i+1], NULL, 10);
 					i += (int)(ptr-&obuf[i]);
 
-				}
-				else
+				} else
 					i++;
 				break;
 			case 'E': 
 				op = OSFOPT_EOL;
 				ptr = osf_strchr(&obuf[i], OPTDEL);
-				if (ptr)
-				{
+				if (ptr) {
 					*ptr = '\0';
 					ptr++;
 					i += (int)(ptr-&obuf[i]);
 
-				}
-				else
+				} else
 					i++;
 				break;
 			default:
 				ptr = osf_strchr(&obuf[i], OPTDEL);
-				if (ptr)
-				{
+				if (ptr) {
 					ptr++;
 					i += (int)(ptr-&obuf[i]);
 
-				}
-				else
+				} else
 					i++;
 				break;
 		}
@@ -616,7 +568,6 @@
 
 static int osf_proc_read(char *buf, char **start, off_t off, int count, int *eof, void *data)
 {
-	struct list_head *ent;
 	struct osf_finger *f = NULL;
 	int i, __count, err;
 	
@@ -625,10 +576,7 @@
 	count = 0;
 
 	read_lock_bh(&osf_lock);
-	list_for_each(ent, &finger_list)
-	{
-		f = list_entry(ent, struct osf_finger, flist);
-
+	list_for_each_entry(f, &finger_list, flist) {
 		log("%s [%s]", f->genre, f->details);
 		
 		err = snprintf(buf+count, __count-count, "%s - %s[%s] : %s", 
@@ -638,12 +586,10 @@
 			break;
 		else
 			count += err;
-		if (f->opt_num)
-		{
+		if (f->opt_num) {
 			loga(" OPT: ");
 			//count += sprintf(buf+count, " OPT: ");
-			for (i=0; i<f->opt_num; ++i)
-			{
+			for (i=0; i<f->opt_num; ++i) {
 				//count += sprintf(buf+count, "%d.%c%lu; ", 
 				//	f->opt[i].kind, (f->opt[i].wc.wc)?f->opt[i].wc.wc:' ', f->opt[i].wc.val);
 				loga("%d.%c%lu; ", 
@@ -667,19 +613,15 @@
 	int cnt;
 	unsigned long i;
 	char obuf[MAXOPTSTRLEN];
-	struct osf_finger *finger;
-	struct list_head *ent, *n;
+	struct osf_finger *finger, *n;
 
 	char *pbeg, *pend;
 
-	if (count == strlen(OSFFLUSH) && !strncmp(buffer, OSFFLUSH, strlen(OSFFLUSH)))
-	{
+	if (count == strlen(OSFFLUSH) && !strncmp(buffer, OSFFLUSH, strlen(OSFFLUSH))) {
 		int i = 0;
 		write_lock_bh(&osf_lock);
-		list_for_each_safe(ent, n, &finger_list)
-		{
+		list_for_each_entry_safe(finger, n, &finger_list, flist) {
 			i++;
-			finger = list_entry(ent, struct osf_finger, flist);
 			list_del(&finger->flist);
 			finger_free(finger);
 		}
@@ -696,8 +638,7 @@
 		if (buffer[i] == ':')
 			cnt++;
 
-	if (cnt != 8 || i != count)
-	{
+	if (cnt != 8 || i != count) {
 		log("Wrong input line cnt=%d[8], len=%lu[%lu]\n", 
 			cnt, i, count);
 		return count;
@@ -706,19 +647,16 @@
 	memset(obuf, 0, sizeof(obuf));
 	
 	finger = finger_alloc();
-	if (!finger)
-	{
+	if (!finger) {
 		log("Failed to allocate new fingerprint entry.\n");
 		return -ENOMEM;
 	}
 
 	pbeg = (char *)buffer;
 	pend = osf_strchr(pbeg, OSFPDEL);
-	if (pend)
-	{
+	if (pend) {
 		*pend = '\0';
-		if (pbeg[0] == 'S')
-		{
+		if (pbeg[0] == 'S') {
 			finger->wss.wc = 'S';
 			if (pbeg[1] == '%')
 				finger->wss.val = simple_strtoul(pbeg+2, NULL, 10);
@@ -726,9 +664,7 @@
 				finger->wss.val = 0;
 			else 
 				finger->wss.val = simple_strtoul(pbeg+1, NULL, 10);
-		}
-		else if (pbeg[0] == 'T')
-		{
+		} else if (pbeg[0] == 'T') {
 			finger->wss.wc = 'T';
 			if (pbeg[1] == '%')
 				finger->wss.val = simple_strtoul(pbeg+2, NULL, 10);
@@ -736,14 +672,10 @@
 				finger->wss.val = 0;
 			else 
 				finger->wss.val = simple_strtoul(pbeg+1, NULL, 10);
-		}
-		else if (pbeg[0] == '%')
-		{
+		} else if (pbeg[0] == '%') {
 			finger->wss.wc = '%';
 			finger->wss.val = simple_strtoul(pbeg+1, NULL, 10);
-		}
-		else if (isdigit(pbeg[0]))
-		{
+		} else if (isdigit(pbeg[0])) {
 			finger->wss.wc = 0;
 			finger->wss.val = simple_strtoul(pbeg, NULL, 10);
 		}
@@ -751,38 +683,33 @@
 		pbeg = pend+1;
 	}
 	pend = osf_strchr(pbeg, OSFPDEL);
-	if (pend)
-	{
+	if (pend) {
 		*pend = '\0';
 		finger->ttl = simple_strtoul(pbeg, NULL, 10);
 		pbeg = pend+1;
 	}
 	pend = osf_strchr(pbeg, OSFPDEL);
-	if (pend)
-	{
+	if (pend) {
 		*pend = '\0';
 		finger->df = simple_strtoul(pbeg, NULL, 10);
 		pbeg = pend+1;
 	}
 	pend = osf_strchr(pbeg, OSFPDEL);
-	if (pend)
-	{
+	if (pend) {
 		*pend = '\0';
 		finger->ss = simple_strtoul(pbeg, NULL, 10);
 		pbeg = pend+1;
 	}
 
 	pend = osf_strchr(pbeg, OSFPDEL);
-	if (pend)
-	{
+	if (pend) {
 		*pend = '\0';
 		cnt = snprintf(obuf, sizeof(obuf), "%s", pbeg);
 		pbeg = pend+1;
 	}
 
 	pend = osf_strchr(pbeg, OSFPDEL);
-	if (pend)
-	{
+	if (pend) {
 		*pend = '\0';
 		if (pbeg[0] == '@' || pbeg[0] == '*')
 			cnt = snprintf(finger->genre, sizeof(finger->genre), "%s", pbeg+1);
@@ -792,16 +719,14 @@
 	}
 	
 	pend = osf_strchr(pbeg, OSFPDEL);
-	if (pend)
-	{
+	if (pend) {
 		*pend = '\0';
 		cnt = snprintf(finger->version, sizeof(finger->version), "%s", pbeg);
 		pbeg = pend+1;
 	}
 	
 	pend = osf_strchr(pbeg, OSFPDEL);
-	if (pend)
-	{
+	if (pend) {
 		*pend = '\0';
 		cnt = snprintf(finger->subtype, sizeof(finger->subtype), "%s", pbeg);
 		pbeg = pend+1;
@@ -835,15 +760,13 @@
 	INIT_LIST_HEAD(&finger_list);
 	
 	err = ipt_register_match(&osf_match);
-	if (err)
-	{
+	if (err) {
 		log("Failed to register OS fingerprint matching module.\n");
 		return -ENXIO;
 	}
 
 	p = create_proc_entry("sys/net/ipv4/osf", S_IFREG | 0644, NULL);
-	if (!p)
-	{
+	if (!p) {
 		ipt_unregister_match(&osf_match);
 		return -ENXIO;
 	}
@@ -852,8 +775,7 @@
 	p->read_proc  = osf_proc_read;
 	
 	nts = netlink_kernel_create(NETLINK_NFLOG, NULL);
-	if (!nts)
-	{
+	if (!nts) {
 		log("netlink_kernel_create() failed\n");
 		remove_proc_entry("sys/net/ipv4/osf", NULL);
 		ipt_unregister_match(&osf_match);
@@ -865,17 +787,14 @@
 
 static void __exit osf_fini(void)
 {
-	struct list_head *ent, *n;
-	struct osf_finger *f;
+	struct osf_finger *f, *n;
 	
 	remove_proc_entry("sys/net/ipv4/osf", NULL);
 	ipt_unregister_match(&osf_match);
 	if (nts && nts->sk_socket)
 		sock_release(nts->sk_socket);
 
-	list_for_each_safe(ent, n, &finger_list)
-	{
-		f = list_entry(ent, struct osf_finger, flist);
+	list_for_each_entry_safe(f, n, &finger_list, flist) {
 		list_del(&f->flist);
 		finger_free(f);
 	}





	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
