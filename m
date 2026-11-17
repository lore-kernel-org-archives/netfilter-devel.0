Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932156;
	b=u8iuENwF+Xy9z1dL03NCAUEYlnkNUQ1on/EyzBa/f4+sGeqo3w7E93ANzeBlMzUOH9F/
	 0dJ2NpxZF7XKDfhnHu49DFrxl1Imozx/w6N/WPEoFKNqSwFptKHmaf3En+horZz8pSeBw
	 bXEtF0W/0mrm6vJqdrvd3XaVh3V3h4esBoKNiJJaMmVm7+2k1lOpLlmIyS7aRTLHhYlta
	 e+EWRSDhBc94kfFyLXeX6gCGPKG4CYol4t+T2Fof0i1lt015/aQ/6/v4ppNTktJKl958D
	 2BNbdJ8Q8zkFeo2N5Z1HBIaLs6EFH0WCnWe1e68xRsKJVExoSeV4bNcOWUsrv/4qKEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932156;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8jwtGjw18EU1ziJNNVtxqvciDNQoYG4fyQiix6f1irk=;
	b=nWPyxRhL9Gu30SasGgfMAzG7igL22Y7NOfyY2itoDMjDAgT2ScJgoP+OIYOtZyEDW2Ru
	 McsF/AXpIdH1N6Ec/WA7cAmR9e6avRj119HWC4Q9MCQJIdkCOQxESaEpDmgpk8teUoETf
	 /DKJ5kQQmdORZspwD3unvccBmn06JHH7IVUjNOkfEPxF9i3MXuyxsDmW7wDreT1+27rRX
	 kEEN0u/0w9nLoslLB4a5QHWvCBQ6xSii9QLwsQajjG8YMAe//FgXa5VBZDNsq3j+iPq4W
	 xozRhHBnab6mssoVhMPgS/fRQlbqN02pHIgIOYjNIefMDPzWsocRSiGBMRpPlsz3y0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=VePrIKQt;
	arc=none smtp.remote-ip=203.205.221.240
Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F93606A32A;
	Tue, 17 Nov 2026 16:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4F93606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=VePrIKQt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794932147; bh=8jwtGjw18EU1ziJNNVtxqvciDNQoYG4fyQiix6f1irk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VePrIKQtsunRscRbdPFbSXB3bWHPEfQHtJ+qptQwLc7OsDGDD837crVuQbVRTWF1U
	 hAY+aMY4BNkyC9ZuS7Zx6ruRmDEyuZl9Jhx8vKVI6zmRFoZmtORTHPk1dje+3Vh7pc
	 gkHfXR36ioLMH6NntgGxZ2j8Ct4CgDddAgNYjCFE=
Received: from localhost.localdomain ([182.239.117.117])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 3E6A5A2C; Wed, 18 Nov 2026 00:15:38 +0800
X-QQ-mid: xmsmtpt1794932140tfui4gfs5
Message-ID: <tencent_6731DB02656EFC3D74E4DFCE582B7E0EFC0A@qq.com>
X-QQ-XMAILINFO: MUB0BnZgQ8A6Yd5EK8sLuE4bS7MIUkAafrgfGJLBbIljcw+ncSizykCK8kSKqc
	 NwtntNukoBM/XIEtDBss2nA6zJMyrji2i6lxPlKkUgbrQjAjQ+8keYY+vg2ngCXhlj5wjfLr5Ii0
	 F3/Iywl61KpUsPbxU1pdV+5PcPbRdGeSks7PiMAzeUq25vq9osJE96u1m5NwdCYzmSmv2U9E3ULP
	 UvnWmKgWM9GoqtLDISl3nKQNnTgqYy38ttEUaX+WFu9Qccs2VuRAAYCbdxs9bjXIDW8Ge85Lx2GK
	 OqW0OhFBPckT1fOSX33afI32gDiS9PkZ1h68G+5aXWPgKDISvsdAn0Rcx8D5CovF7q/VxSmPGmAU
	 t6dEDLp2gKbGBmXWg3ltFeQia9zjuKwvjl5OGIGXWmIR7UeOX2A8lEPsCHrjZBdehWaahs2Z60e+
	 tEZUnPPoQSNXY+ONm+vtsjhEpvM7u+TFavo/sbwiWUw5WGVqmtNxX2JlPoSssFDUnenTdSpV1aar
	 gPPIeiDx4o9LCLYcdTccX88sHC/BTERvfwCCa+y0IDJHl7s1NHljm//IVPmIV42/7izlEQpEYiQi
	 R6DtG8eEdq+jQCvMEtCGZ3SxLAqjmD5KZwb14rukAEVjNo2szP4Y73QEp4RCvVS3l3bgvzDncmdZ
	 EZNLC7EFSTLsK2is0VgJz7rpax8ZxsiTeMp+6aVNFz1pjyqy6/F3UvCqqQF5D9eZoVSwpKPzibmz
	 jagrlfOanaWDZ3/gidMex/d70+lrjgviYuqt4jSH4nA/imxb1yzzWjgVKUBsclQmD+YE0qObzk7W
	 pIIj6X0SB4l/VjrR/2YF/VcQ/X9TrxJ7wMkNhDMHKISiDuQt7YFg+i7hrvKDjoFbF41xec4vfwmi
	 WP2TSEi3g/DeaL+OKXWT/8sdNetwuddBXTrNcYMfyYiy/iyk2PRAZp/oqaBgXy5JkvI6vIPFm5iZ
	 jkyeo92DnpDHhTBuNPIhvT5KScnOYtzONY2uVZ6dy4EuyZWvmjnJ49VQ+03Nsg9pDF0t0/zML6c1
	 V2y83Z16BOgT0+MxBaTYB5WzlRyJKeQ9qVx2lX+w==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf v2 1/2] netfilter: nf_tables: only disable tables on a dormant transition
Date: Wed, 18 Nov 2026 00:14:57 +0800
X-OQ-MSGID: <20261117161520.1031-2-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20261117161520.1031-1-1564938642@qq.com>
References: <20261117161520.1031-1-1564938642@qq.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_tables_commit() calls nf_tables_table_disable() for every NEWTABLE
transaction that has NFT_TABLE_F_DORMANT set and __NFT_TABLE_F_UPDATE.
Since table adoption introduced __NFT_TABLE_F_WAS_ORPHAN, UPDATE no
longer implies a dormant state change: re-owning an already dormant
PERSIST orphan sets UPDATE because of the adoption, even though the
table never left the dormant state. The commit then clears DORMANT,
walks the basechains, and unregisters a hook that was never registered,
which triggers WARN_ONCE("hook not found") in
__nf_unregister_net_hook().

Use __NFT_TABLE_F_WAS_AWAKEN, which records an awake-to-dormant
transition, instead of the current DORMANT flag. This skips the disable
for an already dormant adopted table while preserving the genuine
awake-to-dormant path.

Fixes: 31bf508be656 ("netfilter: nf_tables: Implement table adoption support")
Signed-off-by: Ma Xinmeng <1564938642@qq.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8b94b5e7d..b184c739c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11078,7 +11078,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 					nft_trans_destroy(trans);
 					break;
 				}
-				if (table->flags & NFT_TABLE_F_DORMANT)
+				if (table->flags & __NFT_TABLE_F_WAS_AWAKEN)
 					nf_tables_table_disable(net, table);
 
 				table->flags &= ~__NFT_TABLE_F_UPDATE;
-- 
2.56.0.windows.4.niugit

