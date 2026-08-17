Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDB73F44E8;
	Mon, 17 Aug 2026 23:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009424; cv=none; b=U9O4OEnbix+LD/zNMOjN/dNMuOzi0CaZmIoxDpsI9nv4fsGSWBKA/EEtWNto10iF9mHL2R+7DbFBHK3nfLRoErfocVrTA8zOFxjMdV7xg8RHNOpdspx9rIGbg8fCmdFFk9VZbE3/JkkoN/PkoPjJkyNzuLO60wsRfB8varsBBEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009424; c=relaxed/simple;
	bh=V5jrNmJVF46wI+TZVQ+vy8rfWyLJhJOGvOzwAMpIsu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHI6Dva27ieLpsdx8W7g6aQ5BgqI0Qbf/C5njSZ9Q42H16lHe10oM2vmw0dLo7/z1wK1/i7Xkd3Oy5ylcZYa5bYEOAnq3B28ZkWbu9Ej3hini4ROiLAicXjCVFupHF9I+FxfuWslyXZoUiX1FCofroEYHeP35UvhYazOSc6OeH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SEehMyP7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SEehMyP7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009415;
	bh=CG2UKa0gVE8JcQVdrYUAm+sGUxTVzGmZXNI60EGHCaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEehMyP7fiP6+LzdKJPaypDnjxfbySD1InI0ayi4/vvBm4dspisd5SUwpPqLNonjj
	 2JhpWTCfl8eKhTTf7sAlZlVcKOOJYfUVDm69PB4MQ6ooehcCaqII25IFwUDthfkMsp
	 B7CMpf9ZKSSqvdZvPSVBeBk5IU79a/vC7L5pjaFkGmE2N64q3f4KsSQe+fupsPHa4K
	 iysqz3sDUVj8eEtXOuL8LtrklcTJmkI148Knnpbd/iqOHfOtF3UYQtKTDyv8hawVkE
	 F1VDtepVM7bbYBxyhXYTJx+g+V+OrU8sjaBgZs0pAc8yTHp9ma9f5DJ099HdROMsbv
	 kYWnJ0rDpXA2g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B1CAB6005F;
	Tue, 18 Aug 2026 01:30:14 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 8/8] ipvs: fix integer overflow in ftp helper port/address parsing
Date: Tue, 18 Aug 2026 01:29:57 +0200
Message-ID: <20260817232957.1281637-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>
References: <20260817232957.1281637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

ip_vs_ftp_get_addrport() accumulates decimal digits into a __u16
(hport) and into unsigned char (p[]) without checking for overflow.
A crafted FTP PASV/EPSV response with an over-long port or address
octet wraps the value, so the helper configures the data connection
with a truncated port/address.

The netfilter conntrack FTP helper had the same defect, fixed in
commit 2b413fc689ba ("netfilter: nf_conntrack_ftp: avoid u16
overflows"). Apply the equivalent fix here: widen the port accumulator
to u32 and reject values above 65535, and reject address octets above
255.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index b315c608fda4..9e3e005a8263 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -102,7 +102,7 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 	char *s, c;
 	unsigned char p[6];
 	char edelim;
-	__u16 hport;
+	__u32 hport;
 	int i = 0;
 
 	if (data_limit - data < plen) {
@@ -144,7 +144,11 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 				return -1;
 			c = *data;
 			if (isdigit(c)) {
-				p[i] = p[i]*10 + c - '0';
+				unsigned int val = p[i] * 10 + c - '0';
+
+				if (val > 255)
+					return -1;
+				p[i] = val;
 			} else if (c == ',' && i < 5) {
 				i++;
 				p[i] = 0;
@@ -222,6 +226,8 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 		if (!isdigit(*s))
 			break;
 		hport = hport * 10 + *s - '0';
+		if (hport > 65535)
+			return -1;
 	}
 	if (s == data_limit || !hport || *s != edelim)
 		return -1;
-- 
2.47.3

