Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F109264608;
	Thu, 13 Mar 2025 09:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741859813; cv=none; b=JIcjqjJDCg7eqVwGCgsMeQrYkPVV4qHmq2UEYfI5JQszytWrcvJN+YOhKvMCdPbWtATtf0rq/xCM98qAvctxjwwUdUTlMDTj0ibq4iLC8Na/AJT79gdEJlCbp2/bQiHvfg5Fw0ahmWZA4vxS0CO94ncm+r0lw3WpZ1w2uK9ymsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741859813; c=relaxed/simple;
	bh=JpQ1k0m2Ua4J55+IfmJ9+Ez0qZ3wuKhCLFzvYd+jTnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hsSZ+lLJ2lejDPTaexyY+En/Lot281Hiz6K2RuPTobJY/I7pO5Uv2ly4ePcHgV067vW2gtWUp6JfzBQY652mjvXGbAt8OzoTqT9sg1BqQsA3G5LGWFFDxujumuojUXnR8KRO7w7rqyhCZJzKwtknVIB4feMbpTbt1rK1i2PQEpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iepz52V1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g58Xi58H; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iepz52V1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g58Xi58H"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 134B1602B8; Thu, 13 Mar 2025 10:56:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741859809;
	bh=Mid4hPZG1XPNyJ4Ty0Tl23Wc5ItlNpUl/OMG2/peWk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iepz52V1yY45ZKT+1qPS0R52E8mtSioSPKqW+B1fzSZVXujg9tY7wMMSsr5omqfD9
	 sP6gWbo7bX0FVFStZdFF8rS9RSYstgsg5wENtASY10LJSV/jmrFKD1MtnEjoI+GhEy
	 Bx76P/6XmoYJ7bqjOZRCKZ5Gp/MSLKp6+d6F2O6fwzELYOCEgQDWBD95H5+nEacQKF
	 P3dFlSP8BwfAleLz4MkJMQZ/j1q5ro1i1buZASznBt9ni1zLdpovxAzScqYGEpyqPq
	 g/HNjsst0rbkHKZrthzdkEQndwhoBWCt9vQC0lu6vokmD7nmmWeFx+uYRNbJpHHb7o
	 5cxzYZbOFicsQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0440F6028B;
	Thu, 13 Mar 2025 10:56:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741859804;
	bh=Mid4hPZG1XPNyJ4Ty0Tl23Wc5ItlNpUl/OMG2/peWk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g58Xi58H1v3Z8QmQq5mXFSBY4FhDBjmkZxHay74vLVlz/1HXjJjiIF1Y/qOYNBX4X
	 ahtR6WbgA0FZhRNpvl6pnk1xXBHSFRRDF8yksQZ0fkEGmL/7y7PN5auf0UWhIdLl3a
	 C+ShiFG3/GSVBGLQPQ7so/x2G6LTjExRiER1QU6GBtKdoIUua4eRNPd2UkGETlJspw
	 KOGqbw+Xr5Tsx0DJ6P2DwapOVRguN+bfaYdexh/qgK9HOsKwOIZ5FKmCAE2GNCOHPK
	 lz080KyqH++FqiLhIu4Q6BIcEONTBQxXLLaitXhVghVVQQ3PEoNqF/xIcJVGB0ztUX
	 /fmhlYsoDWdZg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/4] ipvs: prevent integer overflow in do_ip_vs_get_ctl()
Date: Thu, 13 Mar 2025 10:56:35 +0100
Message-Id: <20250313095636.2186-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250313095636.2186-1-pablo@netfilter.org>
References: <20250313095636.2186-1-pablo@netfilter.org>
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

