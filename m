Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9B512B166
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Feb 2024 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967496; cv=none; b=BWNRW6z3VlOvaE0/f5Tq9DMfervt9dwQOh9Pl+l8z16CdzBcurdOcpL8up6XWMQmS99Pg6pzwSC4fj9jL611wnbKsoKj2VZshOyLQLMLl0TZj7n/S641vdYKjUecfv9XpMW7oIbaVhuxEGXmxw4mBSYcZKgsVcOQlwLMIQvK2i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967496; c=relaxed/simple;
	bh=wtDvnhQjygv6CQEdCetgs74QbouQY00APKuRP1+slD8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EVnmvMWuovCCHONl2reXFs8MOkWdrjNiD4lSaZ+409n/LkdKodjUUNrzDmSRl/S++kSGGWA5/VhtUa5JlLq+rcosRTklxB05NAJ4jRuMx6vnR3CjT0pdzcyXw9xu/3Q7nKGGTJkyMwEazGnip43towp2O5jgCAELMGe8aVAqkjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 2/3] udata: incorrect userdata buffer size validation
Date: Mon, 26 Feb 2024 18:11:26 +0100
Message-Id: <20240226171127.256640-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240226171127.256640-1-pablo@netfilter.org>
References: <20240226171127.256640-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the current remaining space in the buffer to ensure more userdata
attributes still fit in, buf->size is the total size of the userdata
buffer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/udata.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/udata.c b/src/udata.c
index 0cc3520ccede..e9bfc35e624c 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -42,6 +42,11 @@ uint32_t nftnl_udata_buf_len(const struct nftnl_udata_buf *buf)
 	return (uint32_t)(buf->end - buf->data);
 }
 
+static uint32_t nftnl_udata_buf_space(const struct nftnl_udata_buf *buf)
+{
+	return buf->size - nftnl_udata_buf_len(buf);
+}
+
 EXPORT_SYMBOL(nftnl_udata_buf_data);
 void *nftnl_udata_buf_data(const struct nftnl_udata_buf *buf)
 {
@@ -74,7 +79,8 @@ bool nftnl_udata_put(struct nftnl_udata_buf *buf, uint8_t type, uint32_t len,
 {
 	struct nftnl_udata *attr;
 
-	if (len > UINT8_MAX || buf->size < len + sizeof(struct nftnl_udata))
+	if (len > UINT8_MAX ||
+	    nftnl_udata_buf_space(buf) < len + sizeof(struct nftnl_udata))
 		return false;
 
 	attr = (struct nftnl_udata *)buf->end;
-- 
2.30.2

