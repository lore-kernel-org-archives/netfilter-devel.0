From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch for conntrack expectations
Date: Sat, 06 Mar 2004 02:24:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40492868.1060105@eurodev.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org> <403B1F5F.6010004@trash.net> <20040224102432.GX13386@sunbeam.de.gnumonks.org> <403B7CAA.3060005@trash.net> <403CD128.40101@eurodev.net> <404668EB.1080400@trash.net> <4049183A.2040406@eurodev.net> <4049245E.60908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010707000304000703070906"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <4049245E.60908@trash.net>
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
--------------010707000304000703070906
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

> The patch looks fine, except for one thing, you return from the function
> after a failed memory allocation without dropping amanda_buffer_lock.

ok, I fixed this problem.

> My
> advice of returning NF_DROP from a helper in case of memory allocation
> wasn't right anyway, connection tracking should not drop packets. Just
> replace that return with a break and it's fine.

Also fixed. Attached last modification. Thanks patrick.

Best regards,
Pablo

--------------010707000304000703070906
Content-Type: text/plain;
 name="amanda-expect_alloc-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="amanda-expect_alloc-2.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-03-05 03:24:47.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-03-06 02:22:20.000000000 +0100
@@ -46,10 +46,11 @@
 static int help(struct sk_buff *skb,
                 struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
 	struct ip_ct_amanda_expect *exp_amanda_info;
 	char *data, *data_limit, *tmp;
 	unsigned int dataoff, i;
+	u_int16_t port, len;
 
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
@@ -79,33 +80,40 @@
 		goto out;
 	data += strlen("CONNECT ");
 
-	memset(&exp, 0, sizeof(exp));
-	exp.tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-	exp.tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	exp.tuple.dst.protonum = IPPROTO_TCP;
-	exp.mask.src.ip = 0xFFFFFFFF;
-	exp.mask.dst.ip = 0xFFFFFFFF;
-	exp.mask.dst.protonum = 0xFFFF;
-	exp.mask.dst.u.tcp.port = 0xFFFF;
-
 	/* Only search first line. */	
 	if ((tmp = strchr(data, '\n')))
 		*tmp = '\0';
 
-	exp_amanda_info = &exp.help.exp_amanda_info;
 	for (i = 0; i < ARRAY_SIZE(conns); i++) {
 		char *match = strstr(data, conns[i]);
 		if (!match)
 			continue;
 		tmp = data = match + strlen(conns[i]);
-		exp_amanda_info->offset = data - amanda_buffer;
-		exp_amanda_info->port   = simple_strtoul(data, &data, 10);
-		exp_amanda_info->len    = data - tmp;
-		if (exp_amanda_info->port == 0 || exp_amanda_info->len > 5)
+		port = simple_strtoul(data, &data, 10);
+		len = data - tmp;
+		if (port == 0 || len > 5)
 			break;
 
-		exp.tuple.dst.u.tcp.port = htons(exp_amanda_info->port);
-		ip_conntrack_expect_related(ct, &exp);
+		exp = ip_conntrack_expect_alloc();
+		if (exp == NULL)
+			goto out;
+
+		exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		exp->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+		exp->tuple.dst.protonum = IPPROTO_TCP;
+		exp->mask.src.ip = 0xFFFFFFFF;
+		exp->mask.dst.ip = 0xFFFFFFFF;
+		exp->mask.dst.protonum = 0xFFFF;
+		exp->mask.dst.u.tcp.port = 0xFFFF;
+
+		exp_amanda_info = &exp->help.exp_amanda_info;
+		exp_amanda_info->offset = data - amanda_buffer;
+		exp_amanda_info->port   = port;
+		exp_amanda_info->len    = len;
+
+		exp->tuple.dst.u.tcp.port = htons(port);
+
+		ip_conntrack_expect_related(exp, ct);
 	}
 
 out:

--------------010707000304000703070906--
