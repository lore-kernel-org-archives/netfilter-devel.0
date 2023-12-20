Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C780482CF
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LZbukDgd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oE1i9BUCJ+N+5io3KeoKmZ7f/+d15v3frqc0GYu0AS8=; b=LZbukDgdLNriJ6kf+Idextl9yy
	BdtXCk5P8ZXKdrTCcZ+v7MjCVCyZEIypQewO8oKOUP44pXVVww9jsta62oOatjzJS5UtpsKLyKTh1
	O0f0JCnLAfE/jhFWayM/j7JTzNsjRpIMozbX0WXfDdSvRKzxZkXg3hmx/LVoKxmYg0N5RqZeq2i3C
	D20R/VFtVtRMy6Hfzh2qkeYp+ujkp6mXv+PeUpEyq+DlWox4tAswZfdOjVFk6WUrIZTgDO6gFG4pp
	GBqUii7OzJJ173GefqZ8+SrrAsehu19qvsJXd8Q7Xy3aOYfceaQe4FHGTm01tv4CmX5re22mNv3g9
	CQxxxcLw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5l-0004KK-2T
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/23] libxtables: xtoptions: Treat NFPROTO_BRIDGE as IPv4
Date: Wed, 20 Dec 2023 17:06:17 +0100
Message-ID: <20231220160636.11778-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When parsing for XTTYPE_HOST(MASK), the return value of afinfo_family()
is used to indicate the expected address family.

Make guided option parser expect IPv4 by default for ebtables as this is
the more common case. The exception is libebt_ip6, which will
temporarily adjust afinfo->family while parsing.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 9377e1641f28c..5b693a9b00e3f 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -71,6 +71,7 @@ static uint8_t afinfo_family(void)
 {
 	switch (afinfo->family) {
 	case NFPROTO_ARP:
+	case NFPROTO_BRIDGE:
 		return NFPROTO_IPV4;
 	default:
 		return afinfo->family;
-- 
2.43.0

