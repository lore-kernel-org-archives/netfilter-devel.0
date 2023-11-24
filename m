Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dybUn3tT"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261E110F9
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 03:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d2uXjecoL4dylpEubl4HSnxiITgFnIGfgHJiMgnBZTM=; b=dybUn3tT3fiKUyfVd6cg41wVy0
	UhaBEBLG4WvIemIlFDFjiRvve4wruWdw0OwFU0ZzSBe6EsW9z/W7ErF4979dQA4o0t4FlW8CPGfof
	NJhA9zcFhmR1ExCVm+6p9KDZBgBf7meESs3v2EqKSLDD7frQ/UPB/9OVgX7MNybcu1nqMoPxNMBtU
	xdltdnypMHYKvZY//qg/QsK1XtR5ZTYYpps+6uJ55+T8vQ5zFxqW7YatdguwrfVL2IFfs6C9mFlt8
	yn87TBitdGZDloeJd75lJwHskgpSQSkcuNzPPw25rOf2fKUXKQJ9FfSVK00hC7fplzhaSNFzOTZ1E
	S50GdzxA==;
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6UDU-0002UV-HF
	for netfilter-devel@vger.kernel.org; Fri, 24 Nov 2023 12:19:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] xshared: Do not populate interface masks per default
Date: Fri, 24 Nov 2023 12:28:33 +0100
Message-ID: <20231124112834.5363-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231124112834.5363-1-phil@nwl.cc>
References: <20231124112834.5363-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are needed by legacy variants only, so introduce a simplified
xtables_parse_interface() replacement which does not deal with them and
a small function which sets the mask based on given interface name for
use by legacy tools.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c |  3 +++
 iptables/iptables.c  |  3 +++
 iptables/xshared.c   | 51 ++++++++++++++++++++++++++++++++++----------
 iptables/xshared.h   |  2 ++
 4 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 21cd801892641..53eeb6e90bbb7 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -713,6 +713,9 @@ int do_command6(int argc, char *argv[], char **table,
 	smasks		= args.s.mask.v6;
 	dmasks		= args.d.mask.v6;
 
+	iface_to_mask(cs.fw6.ipv6.iniface, cs.fw6.ipv6.iniface_mask);
+	iface_to_mask(cs.fw6.ipv6.outiface, cs.fw6.ipv6.outiface_mask);
+
 	/* Attempt to acquire the xtables lock */
 	if (!restore)
 		xtables_lock_or_exit(wait);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index ce65c30ad0b15..69dd289060528 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -706,6 +706,9 @@ int do_command4(int argc, char *argv[], char **table,
 	smasks		= args.s.mask.v4;
 	dmasks		= args.d.mask.v4;
 
+	iface_to_mask(cs.fw.ip.iniface, cs.fw.ip.iniface_mask);
+	iface_to_mask(cs.fw.ip.outiface, cs.fw.ip.outiface_mask);
+
 	/* Attempt to acquire the xtables lock */
 	if (!restore)
 		xtables_lock_or_exit(wait);
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 839a5bb68776c..dca744773d773 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1322,6 +1322,44 @@ void xtables_clear_iptables_command_state(struct iptables_command_state *cs)
 	}
 }
 
+void iface_to_mask(const char *iface, unsigned char *mask)
+{
+	unsigned int len = strlen(iface);
+
+	memset(mask, 0, IFNAMSIZ);
+
+	if (!len) {
+		return;
+	} else if (iface[len - 1] == '+') {
+		memset(mask, 0xff, len - 1);
+		/* Don't remove `+' here! -HW */
+	} else {
+		/* Include nul-terminator in match */
+		memset(mask, 0xff, len + 1);
+	}
+}
+
+static void parse_interface(const char *arg, char *iface)
+{
+	unsigned int len = strlen(arg);
+
+	memset(iface, 0, IFNAMSIZ);
+
+	if (!len)
+		return;
+	if (len >= IFNAMSIZ)
+		xtables_error(PARAMETER_PROBLEM,
+			      "interface name `%s' must be shorter than %d characters",
+			      arg, IFNAMSIZ);
+
+	if (strchr(arg, '/') || strchr(arg, ' '))
+		fprintf(stderr,
+			"Warning: weird character in interface `%s' ('/' and ' ' are not allowed by the kernel).\n",
+			arg);
+
+	strcpy(iface, arg);
+}
+
 void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
@@ -1600,9 +1638,7 @@ void do_parse(int argc, char *argv[],
 			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(p->ops, &cs->options, OPT_VIANAMEIN,
 				   &args->invflags, invert);
-			xtables_parse_interface(optarg,
-						args->iniface,
-						args->iniface_mask);
+			parse_interface(optarg, args->iniface);
 			break;
 
 		case 'o':
@@ -1610,9 +1646,7 @@ void do_parse(int argc, char *argv[],
 			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(p->ops, &cs->options, OPT_VIANAMEOUT,
 				   &args->invflags, invert);
-			xtables_parse_interface(optarg,
-						args->outiface,
-						args->outiface_mask);
+			parse_interface(optarg, args->outiface);
 			break;
 
 		case 'f':
@@ -1873,12 +1907,7 @@ void ipv4_post_parse(int command, struct iptables_command_state *cs,
 	cs->fw.ip.invflags = args->invflags;
 
 	memcpy(cs->fw.ip.iniface, args->iniface, IFNAMSIZ);
-	memcpy(cs->fw.ip.iniface_mask,
-	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
-
 	memcpy(cs->fw.ip.outiface, args->outiface, IFNAMSIZ);
-	memcpy(cs->fw.ip.outiface_mask,
-	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
 
 	if (args->goto_set)
 		cs->fw.ip.flags |= IPT_F_GOTO;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 952fa8ab95fec..d2ce72e90824a 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -311,4 +311,6 @@ unsigned char *make_delete_mask(const struct xtables_rule_match *matches,
 				const struct xtables_target *target,
 				size_t entry_size);
 
+void iface_to_mask(const char *ifname, unsigned char *mask);
+
 #endif /* IPTABLES_XSHARED_H */
-- 
2.41.0

