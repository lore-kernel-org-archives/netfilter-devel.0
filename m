Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.235
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505669;
	b=F/EzD8s6THj8osjrLASJfCazrVnfBx3h89Pk3aTHZZauWc64s7WtZMbX6KyzbrJP7Jok
	 BMX9EEbvoJ5GqQ6Zf10MhfpElH2uRw3sM0jJrQrWRZKm+SibQJnq28NJ5aBUA7YH15Bxi
	 mgQBJ8ijTBAr4YB++V56YYMIpeLf+j3kuJOvIxlH/W9rOfkSTmU3lhgJ1u9Gm1cSCTda2
	 dpXivnDWq56+Pzk0OUNX3GFLP2C1YOSbp/x1dZAr1fm8SnXPd5ne5Eq1DwZBrnAtB6vgE
	 wrkEPZ1tYi5MtGit0B44qqhwP7TYJZXmoM1e+gMCxzs8Wfu2Sygelh1I9SkXy7mp9eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505669;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=r+ATw+jPC/wAC5DZgfnnfAS5gn4vHzk15igScB5zba4=;
	b=1YFGN4iPZO6FJ2xGxRn3xfZNakrPRTGH/eEOw0Epco+Hpn/V0ZJ+yk0dFiFxqT8Vmbsj
	 cYZBNenbsgnQ0DFtmeUKRDh9tHcWAgeEjVYp0pTASmuiHi5iKZt6wsIgIHOygLP6yxN/p
	 hIX4DhZSu0It/Dmk+Tt7L/LzU4Yvb6MAJanltirlyadaEE5zOPX7maxzTNrAiZetI6nlf
	 wokG+82BZoo2R95ile3IhUaSdPMgiXvsPdN+KRBRNUD8tJHkAlTQrbWogMuLNtRLnwQPh
	 qWVYAjL/xDpYwtHkEN/NOK3SIReKTH2u8JeJLUd74P/fXdoeutGE+WpQysD9TzuHd8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=NXCmjXoZ;
	arc=none smtp.remote-ip=203.205.221.235
Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947E7606A32D;
	Tue, 24 Nov 2026 07:34:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 947E7606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=NXCmjXoZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795505659; bh=r+ATw+jPC/wAC5DZgfnnfAS5gn4vHzk15igScB5zba4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXCmjXoZ3uh8nii51GLR8Z9lky+yAtOyBL7JEPUkQx9PvRYN1bu/DOT4D89q/JcTx
	 D84RhdGgZH1KFEhDv6IvTkfjF9bXdRqZ5ijSmlYq3ABbL5odWgldlBQ88/bqgkYDOL
	 qtpJU8ao8Pq5qMmlIvlrw9jXIeNvnrYO0Tg4riT4=
Received: from localhost.localdomain ([182.239.88.62])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 889B8CA3; Tue, 24 Nov 2026 15:34:09 +0800
X-QQ-mid: xmsmtpt1795505652tp2hwn9oq
Message-ID: <tencent_8540831909086563F9813E5F61A65EB16A05@qq.com>
X-QQ-XMAILINFO: NC4p7XQIBeahDasKqsVRRP9wVmFH9Z5liGHlwM67oEZdB9CWjA6FgqXk+cDqkO
	 6YFdj3+tbnM3MT9LDKE9pR5VuIspQYiOlyoNBYnYZDXBGu6VtJSx5aGnCSvc0p8wGqziOdr/2wJV
	 ycic5XYD69YxJRLCiYJ7cIxgLMe61WFGgxC7dyMzg2tXsiXghwZRiGZAoTjiy6wmqXsPuaNTDAB0
	 +CSeaTrYU3BfgwrlbTciKBCKxsYBtomOhI+rV5icWufdcpSQjnSD5QKnmfy1UyfTb388Vyi91e3n
	 cQodnVip9UKhGZObj5iOqQLi9oKkG7kp4daLsBD0kFbzke/otiSSO00eyF/XZyAKSavB93YZAbh8
	 Zb7aLRs+qiWczd269Lepie5Wxv3ALtoUi7g9P52PCC/ZG+Rjxw8svQTjR9X5k4i7DctNDJgX2ZTu
	 FXri+NxwbS59pqv1FQN9dIN45/yKoy+x3vcoYif96aBEdNm1Xe1cUhKaJOijJVnEeRuOVLSCAm2X
	 Wg2qo1fVZzs2ASpKEsLOTjwCM/1sdpyGnvTuVQwuU6BxSnDB0+mP72mJDCQhkjmwoyIEw+0+PFnG
	 nCutqKssB0crbUHrs2E9IrZbodluyhXOsX0vvuAtDboqLqLhT7lYjrdFVo2uqrNd9wC2miE10fo6
	 b4m1Z84aZ1Jq48CalQu/yEOb2Mv4cnpF/gXhhuIi1J0GuVWwNa65RLw8TEAIzrF/08MHfc11Lb/N
	 IzzHMlqFxq2YVZTQGWZvguK1X5rYEfBA9wIGltSmrhQvxihHJQCzjKySkDvbfAUSpRV1hrevxipa
	 sVgOeER2EPvogc57p4Y1EtbZ9y6zONxFdoR9BBw4eGjetu5YjqHLRTD0DO9IPpMw9KabxyG8UthL
	 jCoI/jwN4H8/N3jrE6ukuJF+C5K+HQVTkh6C1ya18s1v6CM2WAOsXFTTyerOp8f1dq5YYhWHAQph
	 9zy3MW770fsYriWrWYNFRTk4gn/oXZ7z1nxE1Q/hhrFQMy4PdhqcLCPPMxEXp5gw/HipoLQtv1mu
	 +0IsX14V5vk53VwxcMqUjblXGxi3VxHDn/rOTS7UW9VgaQpnae
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH nf v3 1/1] netfilter: nf_tables: only disable tables on a dormant transition
Date: Tue, 24 Nov 2026 15:33:12 +0800
X-OQ-MSGID: <20261124073351.1562-2-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20261124073351.1562-1-1564938642@qq.com>
References: <20261124073351.1562-1-1564938642@qq.com>
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
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
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

