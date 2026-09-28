Received: from out-2uec-a100.jellyfish.systems (out-2uec-a100.jellyfish.systems [63.250.43.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C3D4E77E8
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616845; cv=none; b=OSeeZ4lxWJ8HFF2u+wGxfawypysNXwX1HmrsK6MZDeibtM7AHqWCNZKJJNBZcVJlf1LUdmjV0brnMR4v4HoJ328Qis5PDIrCKY+PKErE3aqKPlDDcyiXi2cleY08Z+t8hLamk1b7SsYmRoQFi1/hqPF01S5Ug5iiuZobBOwDigU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616845; c=relaxed/simple;
	bh=tUlZ1G4UHrxQaekD+OjECUmOFtsabICw69u6Qad9txc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXw25fOJFwrfC5Ubb8YNXziV8WMkvOPKsFci15y5CES9dBZYjNyvSyoAGlABsBjW0cpw8jxAfnBLQvX1pqkwvKhd1ouOZ+0T/7GcA5pMlORJ2vzmF3ZGuGoSY3USrCWhyQe7vf292TAkypS2PAK3w6xMlEzPa4fp42dBUIUqmXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=AiR0tfia reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="AiR0tfia"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4htpMD0JKCz8sWQ;
	Mon, 28 Sep 2026 17:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790616840;
	bh=r5zQMLcuUBvbWNoiiRfk5OPWWu4Wchlx/hRD60Z/RJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiR0tfiaHjj7U03tCawP9+le2+cBKKPHhXhIQ22D2f+fmaxDWRiV/y+s1ODHaj4b2
	 Z12jQWj6qNp+zUMJPWQqIGbRrH7UoV5LSbQljpkdoDS0/jJnAU+6AMnSygtby2uOuJ
	 Q07E1ZYXz8K5NXkdZ0dnFazvSJa/OnQ1lDUuXPuqsCoF5mAWxBsqh/2x1w9GrkF/Bl
	 aNjGmMtxPTcjYWWRwJz+au0HWQ8HogrwNX49lu2WrRLKb+VK5UJK8PAMhP/6K3D4UK
	 S4eZYWRRmD9eqRdGrMFIjrjEQCGMOddBYhk/JloVKTTtj/tATHBaq7cG8dNARyTbiE
	 FVkYCpbXX4Jsw==
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
Subject: [PATCH nf-next v5 1/4] netfilter: conntrack: add shared uint and port parsers for helpers
Date: Mon, 28 Sep 2026 17:33:59 +0000
Message-ID: <9a934bdb12cbb910f3d4f5b4328defd9eae27594.1790596690.git.rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790596690.git.rc@rexion.ai>
References: <cover.1790596690.git.rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Several conntrack helpers parse integers and port numbers out of
application-layer payload.  Some open-code simple_strtoul(), which
requires a NUL-terminated string and returns unsigned long without any
range check, while nf_conntrack_sip carries its own sip_strtouint() and
a digit loop in sip_parse_port().

Add two length-delimited parsers to the conntrack helper core so that
the helpers can share one implementation:

  nf_ct_helper_parse_uint() - bounded decimal parser for a buffer that
    need not be NUL-terminated.  Its body is sip_strtouint() unchanged:
    the result is capped at UINT_MAX and a run of more than 11 digits is
    rejected.

  nf_ct_helper_parse_port() - parses a port number and returns -EINVAL
    for a digit run longer than five characters, for zero and for values
    above 65535, matching what sip_parse_port() accepts today.

Both are exported; the following patches convert the IRC, Amanda and SIP
helpers to them.

Assisted-by: Claude-Code:claude-opus-5-5 sparse
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 include/net/netfilter/nf_conntrack_helper.h |  5 ++
 net/netfilter/nf_conntrack_helper.c         | 79 +++++++++++++++++++++
 2 files changed, 84 insertions(+)

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
index c30ae3f203be..bcdbe493d412 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -16,6 +16,8 @@
 #include <linux/random.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/limits.h>
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <linux/rtnetlink.h>
@@ -569,6 +571,83 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 }
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
+/**
+ * nf_ct_helper_parse_uint - parse a decimal number from a packet buffer
+ * @cp: first byte to parse; the buffer need not be NUL-terminated
+ * @len: number of bytes available at @cp
+ * @endp: if not NULL, set to the byte after the last digit, or to @cp on
+ *	error
+ *
+ * Return: the parsed value, or 0 if @cp does not start with a digit, the
+ * digit run is longer than 11 characters, or the value exceeds UINT_MAX.
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
+/**
+ * nf_ct_helper_parse_port - parse a TCP/UDP port number from a packet buffer
+ * @cp: first byte to parse; the buffer need not be NUL-terminated
+ * @len: number of bytes available at @cp
+ * @port: set to the parsed port on success
+ * @endp: if not NULL, set to the byte after the last digit on success
+ *
+ * Return: 0 on success, or -EINVAL if @cp does not start with a digit, the
+ * digit run is longer than five characters, or the value is 0 or above
+ * 65535.
+ */
+int nf_ct_helper_parse_port(const char *cp, unsigned int len,
+			    u16 *port, char **endp)
+{
+	char *e = (char *)cp;
+	unsigned int val;
+
+	val = nf_ct_helper_parse_uint(cp, len, &e);
+	if (e == cp || e - cp > 5 || val == 0 || val > 65535)
+		return -EINVAL;
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

