Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4271F0E51;
	Wed, 12 Mar 2025 23:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821509; cv=none; b=Les+YvfSzPTzOzXICEyPs2fc4t1iMEfmK9L2d3jPdUkdRvtgkFFikjndKwNozlM3r4uXyfjSBgwobhF4jaqOJrYQ8sLqAzywyp1rjLAB4OIKXBEBgBjcs/Ku8KqD99ufQDLW3fybpAkl91qNGzPXBO7xYlLqAqqIlpsNIsiSjfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821509; c=relaxed/simple;
	bh=JpQ1k0m2Ua4J55+IfmJ9+Ez0qZ3wuKhCLFzvYd+jTnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XVzUz5e22/HhzGTOTMQUSseMI2ew15ozupsl3FB0AWK7L5trZ+RJTrdBWEFLyT9l0dxOV7kwPRzG7dxFWX4DD7he/2n781sOVRiBv4SebmAo/PSGYIhPIc7EFy8aRu8Ly8YFQ1BXBjRDqdeEzDJa0Gdd9+A1xfJjtKcS7KIe78k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LmiTpPrg; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B07scvHS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LmiTpPrg";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B07scvHS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 83E4E602A4; Thu, 13 Mar 2025 00:18:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821506;
	bh=Mid4hPZG1XPNyJ4Ty0Tl23Wc5ItlNpUl/OMG2/peWk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmiTpPrgcikoYrwVXT9pWL/WWa+75agOpKGDkmtN8jY9Xu1CUho1fA7SNZ7DPN8Zi
	 TZm3pCBFZgdp4nrHAJpeNCQejUv7uuG5yVakW2kSoVYqC1uLU93xby8F3pgaEa/T9L
	 Ue2pGuc0t9ZzZtyP2+Bw5KPNToRtfpXM3p4jq52Hkm8OkZrvYeJ7JWaj0hwqit+E4Q
	 63D/gMaWLb3rK4hq5+1yC9HLfMCReJjIwPOnhooMSmdasyX8s/iwi0CMX7Yp4q6J0K
	 iwYKwdaRHN6m5OQtEzstPUgNcU+SpUwoijWWxrojNkfnWC2mcYireIRUycr1Tvin1g
	 OlwhPOi9kZeLQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3055C6028C;
	Thu, 13 Mar 2025 00:18:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821502;
	bh=Mid4hPZG1XPNyJ4Ty0Tl23Wc5ItlNpUl/OMG2/peWk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B07scvHS4aZfCZVq1ZjiOT/aa2pkkJ+KPWkMOrnD8VvfkqHjsKFVgur3q759y80jT
	 AXYbaubd4mPXEU1M2DGjLGs8oU36Subuh/WHuMYZOgIqfnXvlIrhqc3yWh240PKWq/
	 s5bixZMUtMJSbK4HOkOm9gXr/KyfCImGRZBpAcPUzyX00yCgfHEySvQnS261aQAlm5
	 686cCgJk6oMwJQEXXxykts4NkepF/0j9O9roIEYPsZ3fbhRC9mf4z7t+dvBkY9ZJTE
	 Sq3gqK9CSi9eJoNT3UtAnMbswx5zjl/tJYr1xXWxYi3MKfULI1f+OcIoHqBJChk5kV
	 40D9UbrroENrg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/3] ipvs: prevent integer overflow in do_ip_vs_get_ctl()
Date: Thu, 13 Mar 2025 00:18:12 +0100
Message-Id: <20250312231812.4091-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250312231812.4091-1-pablo@netfilter.org>
References: <20250312231812.4091-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

The get->num_services variable is an unsigned int which is controlled by
the user.  The struct_size() function ensures that the size calculation
does not overflow an unsigned long, however, we are saving the result to
an int so the calculation can overflow.

Both "len" and "get->num_services" come from the user.  This check is
just a sanity check to help the user and ensure they are using the API
correctly.  An integer overflow here is not a big deal.  This has no
security impact.

Save the result from struct_size() type size_t to fix this integer
overflow bug.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7d13110ce188..0633276d96bf 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3091,12 +3091,12 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	case IP_VS_SO_GET_SERVICES:
 	{
 		struct ip_vs_get_services *get;
-		int size;
+		size_t size;
 
 		get = (struct ip_vs_get_services *)arg;
 		size = struct_size(get, entrytable, get->num_services);
 		if (*len != size) {
-			pr_err("length: %u != %u\n", *len, size);
+			pr_err("length: %u != %zu\n", *len, size);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3132,12 +3132,12 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	case IP_VS_SO_GET_DESTS:
 	{
 		struct ip_vs_get_dests *get;
-		int size;
+		size_t size;
 
 		get = (struct ip_vs_get_dests *)arg;
 		size = struct_size(get, entrytable, get->num_dests);
 		if (*len != size) {
-			pr_err("length: %u != %u\n", *len, size);
+			pr_err("length: %u != %zu\n", *len, size);
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.30.2

