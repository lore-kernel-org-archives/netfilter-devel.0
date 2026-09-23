Received: from out-zbxj-a78.jellyfish.systems (out-zbxj-a78.jellyfish.systems [198.54.127.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9BD4A093B
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 12:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.54.127.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165593; cv=none; b=Ywe97NC8fBwfX152o1n2gpoTJji7z96SrKE7uHWCXMGGwZj1+udfYjb8pa9tkdxams9qOMbm66E0xIoNeqNzlf0pGEzNFoaVXP8GFInEAG/ipRZBGC0WWDG0L7i9nk00ivRUifg8ogCC1DUezHG8G4rPcO+yrhMJynRlE7Daoq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165593; c=relaxed/simple;
	bh=zFinCXNLEu0ze4nQ76eS+VO5+LQazasf6eYONc0uDFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqDPCqnX9ImOrGF7maQWcgCtNE0zL3YkSjas5wTIaK8yUv257ejuiN/IPe9+JYg4G8DBCvu65sPm3TDdDWzTiNQvJSct48vvEK54XnsA8Apobl5GH93wazz2XFvj1zSzaNHthX2hxl1u0d/TplFP425l/6WmOMv7BO9RCUC0o0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=f19C2X4t reason="key not found in DNS"; arc=none smtp.client-ip=198.54.127.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="f19C2X4t"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqbM132Pbz8sY0;
	Wed, 23 Sep 2026 12:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790165262;
	bh=8SuxllwL7FhyID8IKX9Cc3xbMnHEppmrcasVpdKlnN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f19C2X4tWCsrqLAP3l0BHWo1F9FR206ZCS4MjcVm3xal4DNo1Jqh2B8ZDVbNxH8tw
	 2Mi8qevGJSO7EH4OnHTvrPWcPc/GPdn+2MFtVHkjAsqYgzWtH0p1ktAqqh9qDRqF5K
	 IkVgrfvNOFNFy8+/o9mGzkqAlnPdut3lYpoF9ECjMkx2CmloPZRHHHRwq/nNyqa3gb
	 2/+dmJKt52a9bVmuaFa27xhoFc2FFK0TnuSFYewHiPYCO83PZKzITj9L2TFHkX9vi2
	 7E2vAKRFHPowQ9hqOWsJOaUE4svh+AqO54eyAhtXa3eEiVgWY5gpVY3Wv4NQ4zrwnT
	 xBSNWPv33l+mw==
From: Rahul Chandelkar <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Rahul Chandelkar <rc@rexion.ai>
Subject: [PATCH nf-next v4 1/4] netfilter: conntrack: add shared uint and port parsers for helpers
Date: Wed, 23 Sep 2026 12:07:35 +0000
Message-ID: <20260923120738.2844168-1-rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260923091608.2617604-1-rc@rexion.ai>
References: <20260923091608.2617604-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Several conntrack helpers parse integers and port numbers out of
application-layer payload.  Some open-code simple_strtoul() (which
requires a NUL-terminated string and returns unsigned long without any
range check), while nf_conntrack_sip carries its own sip_strtouint().

Add two length-delimited parsers to the conntrack helper core so helpers
can share one implementation:

  nf_ct_helper_parse_uint() - bounded decimal parser that operates on an
    unterminated buffer, capping the result at UINT_MAX.  Its body is
    taken from sip_strtouint() so nf_conntrack_sip can drop its private
    copy in a later patch.

  nf_ct_helper_parse_port() - thin wrapper that parses a port and rejects
    zero and values above 65535.

Both are exported so the IRC, Amanda and SIP helpers can use them.

Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 include/net/netfilter/nf_conntrack_helper.h |  5 ++
 net/netfilter/nf_conntrack_helper.c         | 68 +++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 335b8c43694f..4d5ad5ae1d13 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -184,6 +184,11 @@ nf_ct_helper_expectfn_find_by_name(const char *name);
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
 
+unsigned int nf_ct_helper_parse_uint(const char *cp, unsigned int len,
+				     char **endp);
+int nf_ct_helper_parse_port(const char *cp, unsigned int len,
+			    u16 *port, char **endp);
+
 extern struct hlist_head *nf_ct_helper_hash;
 extern unsigned int nf_ct_helper_hsize;
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index c30ae3f203be..99b90a54d8a9 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -16,6 +16,7 @@
 #include <linux/random.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/ctype.h>
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <linux/rtnetlink.h>
@@ -569,6 +570,73 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 }
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
+/* Parse a decimal unsigned integer from a length-delimited buffer that is not
+ * necessarily NUL-terminated.  At most @len bytes are examined.  On success
+ * the parsed value is returned and, if @endp is non-NULL, *@endp points just
+ * past the last digit consumed.  If no digit is found or the value would
+ * exceed UINT_MAX, 0 is returned and *@endp is set to @cp.
+ */
+unsigned int nf_ct_helper_parse_uint(const char *cp, unsigned int len,
+				     char **endp)
+{
+	const unsigned int max = sizeof("4294967295");
+	unsigned int olen = len;
+	const char *s = cp;
+	u64 result = 0;
+
+	if (len > max)
+		len = max;
+
+	while (olen > 0 && isdigit(*s)) {
+		unsigned int value;
+
+		if (len == 0)
+			goto err;
+
+		value = *s - '0';
+		result = result * 10 + value;
+
+		if (result > UINT_MAX)
+			goto err;
+		s++;
+		len--;
+		olen--;
+	}
+
+	if (endp)
+		*endp = (char *)s;
+
+	return result;
+err:
+	if (endp)
+		*endp = (char *)cp;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_parse_uint);
+
+/* Parse a TCP/UDP port (1-65535) from a length-delimited buffer using
+ * nf_ct_helper_parse_uint().  Returns 0 and stores the port in *@port (and the
+ * end pointer in *@endp) on success, or -1 if no digit is found or the value
+ * is out of range.
+ */
+int nf_ct_helper_parse_port(const char *cp, unsigned int len,
+			    u16 *port, char **endp)
+{
+	char *e = (char *)cp;
+	unsigned int val;
+
+	val = nf_ct_helper_parse_uint(cp, len, &e);
+	if (e == cp || val == 0 || val > 65535)
+		return -1;
+
+	*port = val;
+	if (endp)
+		*endp = e;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_parse_port);
+
 int nf_conntrack_helper_init(void)
 {
 	nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
-- 
2.43.0

