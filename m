Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991F7322E
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2024 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732730470; cv=none; b=JAnJ84BY+TLCfhWNn9etel+l8gtoJrW5KniddZDxvc+jQDFzcXEgu4gyPvw8ki8KTMbWwmUpwhNxpMY9Vh8pXf5NB4uu8QTS8TtI+YGXz+nchufgVt4ErSSM7AQhAVtLY7ENwRCPo4ibvmn3bP0F7eyfvLNXBF/YEa/XmwNCv48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732730470; c=relaxed/simple;
	bh=ZhebeS0aZ8E/HgQybLbwg/NtgnjGYQm/45PU7EQxwkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZw4bpPLFEosE1xP+PlaIsqvDO5mgCaXiog5eUfZBbVrUdn/sNZ7mUwCioOXRohhhdMp1xhJVYgcGXvY7D4O7Iiw8rwuNiO5cISx5xQyfkztkt+pikIWYNA7JJLUaX3lMNR1chPRAYxRGlBF9l2ziESv0Hk4y9gA/sDQZB4zzDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SavtnyEf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SavtnyEf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RWsonhVrFHEVjM6ZO60vX1tLgtVYAd9iWyvbBeadME0=; b=SavtnyEfFXPScbrhVbgWNDN29i
	pVetq/x40KlSeE5ynTE7t4qIqdHf0EtAZJ824IvBQW1b0qKBAYNnK5V9Cs+x55tAgsS9xaDY6F2Di
	p13ZZEfPilytI+Avr7y4qaQgzCHHojUgb6JVBGiu5NOn/Kr/7v7S3aIxd9kfqT3urrmVUFx4wj5+9
	zj0QSjwl8mQw5hWXU1hGfx+2TGGMzIqY2MQAkzlO3qarS7velSvcW7SBwpj8qk7EXKjUiX8wCa1qy
	wAted0JArx1FzGNLXWb1ivr7tM4FLOXeX+1SNCj48tR4olezRtg0kajXoSQaekzpF0vr/JbMPiEHu
	/01ezAXQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tGMLU-000000000Et-19GP;
	Wed, 27 Nov 2024 19:01:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 2/3] tests: Extend set test by NFTNL_SET_DESC_CONCAT
Date: Wed, 27 Nov 2024 19:01:02 +0100
Message-ID: <20241127180103.15076-2-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241127180103.15076-1-phil@nwl.cc>
References: <20241127180103.15076-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just to cover setter and getter code for that attribute.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/nft-set-test.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
index e264c735a2de6..1cb66e4a3ea64 100644
--- a/tests/nft-set-test.c
+++ b/tests/nft-set-test.c
@@ -21,6 +21,9 @@ static void print_err(const char *msg)
 
 static void cmp_nftnl_set(struct nftnl_set *a, struct nftnl_set *b)
 {
+	const uint8_t *data_a, *data_b;
+	uint32_t datalen_a, datalen_b;
+
 	if (strcmp(nftnl_set_get_str(a, NFTNL_SET_TABLE),
 		   nftnl_set_get_str(b, NFTNL_SET_TABLE)) != 0)
 		print_err("Set table mismatches");
@@ -45,11 +48,18 @@ static void cmp_nftnl_set(struct nftnl_set *a, struct nftnl_set *b)
 	if (strcmp(nftnl_set_get_str(a, NFTNL_SET_USERDATA),
 		   nftnl_set_get_str(b, NFTNL_SET_USERDATA)) != 0)
 		print_err("Set userdata mismatches");
+
+	data_a = nftnl_set_get_data(a, NFTNL_SET_DESC_CONCAT, &datalen_a);
+	data_b = nftnl_set_get_data(b, NFTNL_SET_DESC_CONCAT, &datalen_b);
+	if (datalen_a != datalen_b ||
+	    memcmp(data_a, data_b, datalen_a))
+		print_err("Set desc concat mismatches");
 }
 
 int main(int argc, char *argv[])
 {
 	struct nftnl_set *a, *b = NULL;
+	uint8_t field_lengths[16];
 	char buf[4096];
 	struct nlmsghdr *nlh;
 
@@ -68,6 +78,13 @@ int main(int argc, char *argv[])
 	nftnl_set_set_u32(a, NFTNL_SET_FAMILY, 0x12345678);
 	nftnl_set_set_str(a, NFTNL_SET_USERDATA, "testing user data");
 
+	memset(field_lengths, 0xff, sizeof(field_lengths));
+	if (!nftnl_set_set_data(a, NFTNL_SET_DESC_CONCAT, field_lengths, 17))
+		print_err("oversized NFTNL_SET_DESC_CONCAT data accepted");
+	if (nftnl_set_set_data(a, NFTNL_SET_DESC_CONCAT, field_lengths, 16))
+		print_err("setting NFTNL_SET_DESC_CONCAT failed");
+
+
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, AF_INET, 0, 1234);
 	nftnl_set_nlmsg_build_payload(nlh, a);
-- 
2.47.0

