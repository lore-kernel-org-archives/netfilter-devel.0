Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CE312E1EA
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2024 11:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713873339; cv=none; b=PVMC05HUbM2W29FZg0i+O+A7EDOgyXyAWUsqrtm+HyGCW5KYfSf0eSjdinEO8G1LHr/1I7fNfhZhz7kgT+LwNT8hOKjC/JCWaTapnCZPPv/+Pxc70F0/8Y/Em3BfxjHW0nedFJYYWccmCXBlskHzzHac4FVcd7bx1HtXLD2LnDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713873339; c=relaxed/simple;
	bh=pRCyizJBXLafcgiLZimJVFcWKch621Tv6coNnmXpEbw=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=G2rCFN+xD0PTaXDx4gzvoCkWCm6us9V+LV9Ht3mmueWcVg60uNXhjwZ+id/5hsTXoHeChSYyUuEY0jVRsoSmxaMC6H23EyI47sA2FIeIqp53yWwxiCDs7gnz49XtFhLz6Tk/ULO8PjMw9KeMuBPshce4zb5tYiO3y81K+P9LlxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=sQyZJhxN; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="sQyZJhxN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1713873032; bh=9/w/tzBWmQ5MmArL4N+CgRcqjaPmk49mqMX02OJXD2A=;
	h=From:To:Cc:Subject:Date;
	b=sQyZJhxNAKv139UYsDafubp+qax6vg4HZyCfQt4389bsNekIU8wMvfqKFggUrZYXu
	 mIzB0ECyNn/dWvxwjZiEuiP519pxCrRdd0M4f9Y/mn/C99IlXiaDqpajo+l+iaoIFu
	 YdVSdKj04rxqeSvTZzJz+8ovTAaYIowirJuyg6Mg=
Received: from localhost.localdomain ([58.213.8.145])
	by newxmesmtplogicsvrszb9-1.qq.com (NewEsmtp) with SMTP
	id C9C0D4D5; Tue, 23 Apr 2024 19:50:28 +0800
X-QQ-mid: xmsmtpt1713873028tyc2wg7ji
Message-ID: <tencent_284407955020261D1B2BD142194A87C9EB0A@qq.com>
X-QQ-XMAILINFO: MhK4DKsBP06icZ6vUiZ0AyWKbL8hEAKksNAHNakfhxrPXC70cEjOCWZa/sxygp
	 kuQj+OxO7txQuk/IXFlt9sXae4kml6zc8mgK5OeTDWGTVJ6uoYtpMloRcGuEZ9i3d+XbOahiP9kX
	 vB5OxRyAenN3N852Nag3v2IgpseG3NE3wkXJDedAUqLGjATWpyexrPs3j4SUl6BXP+MmMB3yrG7K
	 s1gNZoRxA7NXZ3cIheGISx5tNPFdvnNsyJQSdelHAsYbJoJQgAPR8V+WTG+GEeoY6Rbzrs5AQTOh
	 bkFtMDlsl3MDVhoGmLzAwTifnt5WWWac7svMwAbVsazk/rYReWlJ0n8JEONRJrUYWmMLfJ/h9wNR
	 xROLstzvwc+j/djLysaFbyUI0PeURjIy23bX/0+D0dUP/D8dh4mZJKtBPEk+StEJU2a6GyShYwV+
	 0x3pg50ZaOBzKnY/tJOVPJCYHY9JRAh8wMjwP6L8wNSlEbgUlPbof9EJBSsGFyZjb9TsUhm+E8SP
	 42GLah5/1l3CQAoUPhZLx5s5JR2ym0cWwP0pY9P0H+Rz9/+ptJw5yB3NrG1uWpTfiWM7gzfFQLk+
	 m1M2/VPN/q2LR2BmMboe/KjRV3qe9cVx25pQcRHWcJFVhyj4oLQ7JSjevttVrN0uAP+9Wy8I2jtl
	 tzPjn64Qg7A2lfFI5aoBqYB3rn6ca8xRT0uvdNIBhduMxM2KefQOXjpxgOYbXLytg0fqc3pap5Fd
	 TQeOrS2r5CJUXmofpW6rc6v9bbzdWCoJBtyeEjZZtZ+V5cieZfH0C4uFXxXU2clSm2SojQQjd3WK
	 qGbR1M8y7rqNpmBDKkywccv+e7zey9l20tvStFBCGlVyQtjoBBs1mF74RcTAV2LLSyoKhLL+vm9J
	 VxY2IjC2GBuX8V/V9OPLpwO4FUr0LDSpPyscMwtpNK9mDk7pUtEsGOCJUgNkojWQCynlZAFQVywd
	 TXOyPIsfiyUYL4SIDD3QK9EWcLkckmoRaOG+B9v3kc089saNLibeoRXTHwFi3/bCJT2NL9gkhShS
	 r4aB4GOmtnz55qVyMyRnAnON8Lh1k=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: linke li <lilinke99@qq.com>
To: 
Cc: xujianhao01@gmail.com,
	linke li <lilinke99@qq.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: mark racy access on ext->gen_id
Date: Tue, 23 Apr 2024 19:50:22 +0800
X-OQ-MSGID: <20240423115022.78748-1-lilinke99@qq.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In __nf_ct_ext_find(), ext->gen_id can be changed by 
nf_ct_ext_valid_post(), using WRITE_ONCE. Mark data races on ext->gen_id
as benign using READ_ONCE. 

This patch is aimed at reducing the number of benign races reported by
KCSAN in order to focus future debugging effort on harmful races.

Signed-off-by: linke li <lilinke99@qq.com>
---
 net/netfilter/nf_conntrack_extend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index dd62cc12e775..7f1a5e5f6646 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -141,7 +141,7 @@ void *__nf_ct_ext_find(const struct nf_ct_ext *ext, u8 id)
 	if (!__nf_ct_ext_exist(ext, id))
 		return NULL;
 
-	if (this_id == 0 || ext->gen_id == gen_id)
+	if (this_id == 0 || READ_ONCE(ext->gen_id) == gen_id)
 		return (void *)ext + ext->offset[id];
 
 	return NULL;
-- 
2.39.3 (Apple Git-146)

