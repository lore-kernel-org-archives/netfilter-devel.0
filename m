Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CAD334C39;
	Mon, 25 May 2026 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779733818; cv=none; b=l8rE0NQk75Y9AE4K8lgainkZeitob4eVIGaENkOtP57cwaKVovZmbeit1KvB5gumPRHY21Op5AurmiJkhr2XhZ0vNIr0Zf+tzFBseJFmCEgtCgzJtOxjzBxFBVfvAKlFNWjekQjQH7ePuZsH0cAmb7OYd+0ZaIJpCA0S2lBlemg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779733818; c=relaxed/simple;
	bh=yJhWf3vHtSLuTznAIzQUaM100G6X4XJa7tHy+0FxUwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgRetFnI1Vtu0Wuz9TMFhGbVgEGC61bl3jbUbsnzj1sqbl7CPzr0iKnr751Ry3dDI72/kKXfhMF7nuQr8VdVswDFkpRIaM9ghMW/k5R/Qkk/uM6PG9ZRqpPpeQfz6ID0Fuxs/qNhQh03lKooLADXS9KHAYT41f8HpLZTVPz59MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7D23F602AB; Mon, 25 May 2026 20:30:15 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 11/11] netfilter: nf_conntrack_ftp: avoid u16 overflows
Date: Mon, 25 May 2026 20:29:24 +0200
Message-ID: <20260525182924.28456-12-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260525182924.28456-1-fw@strlen.de>
References: <20260525182924.28456-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Giuseppe Caruso <giuseppecaruso0990@gmail.com>

get_port and try_number() parse comma-separated decimal values from FTP PORT
and EPRT commands into a u_int32_t array, but does not validate that each
value fits in a single octet. RFC 959 specifies that PORT parameters
are decimal integers in the range 0-255, representing the four octets
of an IP address followed by two octets encoding the port number.

Values exceeding 255 are silently accepted. In try_rfc959(), the raw
u32 values are combined via shift-and-OR to form the IP and port:

  cmd->u3.ip = htonl((array[0] << 24) | (array[1] << 16) |
                     (array[2] << 8) | array[3]);
  cmd->u.tcp.port = htons((array[4] << 8) | array[5]);

When array elements exceed 255, bits from one field bleed into adjacent
fields after shifting, producing IP addresses and port numbers that
differ from what the text representation suggests. For example,
"PORT 10,0,1,2,256,22" yields port (256<<8)|22 = 65558, truncated to
u16 = 22. This mismatch between the textual and computed values can
confuse network monitoring tools that parse FTP commands independently.

Ignore the command by returning 0 (no match) when any accumulated
value exceeds 255 so that no expectation is created.

Signed-off-by: Giuseppe Caruso <giuseppecaruso0990@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ftp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index de83bf9e6c61..dc6f0017ca6b 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -120,6 +120,8 @@ static int try_number(const char *data, size_t dlen, u_int32_t array[],
 	for (i = 0, len = 0; len < dlen && i < array_size; len++, data++) {
 		if (*data >= '0' && *data <= '9') {
 			array[i] = array[i]*10 + *data - '0';
+			if (array[i] > 255)
+				return 0;
 		}
 		else if (*data == sep)
 			i++;
@@ -189,7 +191,7 @@ static int try_rfc1123(const char *data, size_t dlen,
 static int get_port(const char *data, int start, size_t dlen, char delim,
 		    __be16 *port)
 {
-	u_int16_t tmp_port = 0;
+	u32 tmp_port = 0;
 	int i;
 
 	for (i = start; i < dlen; i++) {
@@ -200,10 +202,11 @@ static int get_port(const char *data, int start, size_t dlen, char delim,
 			*port = htons(tmp_port);
 			pr_debug("get_port: return %d\n", tmp_port);
 			return i + 1;
-		}
-		else if (data[i] >= '0' && data[i] <= '9')
+		} else if (data[i] >= '0' && data[i] <= '9') {
 			tmp_port = tmp_port*10 + data[i] - '0';
-		else { /* Some other crap */
+			if (tmp_port > 65535)
+				break;
+		} else { /* Some other crap */
 			pr_debug("get_port: invalid char.\n");
 			break;
 		}
-- 
2.53.0

