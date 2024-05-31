Received: from zg8tmtu5ljy1ljeznc42.icoremail.net (zg8tmtu5ljy1ljeznc42.icoremail.net [159.65.134.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CF0D26A;
	Fri, 31 May 2024 01:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.65.134.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717118990; cv=none; b=tBwtAMY5HXxnfi0H7VHw8+s58qbwUL3FXiDr64rAMzKg79S3FStlY8ygDV/c6J/HBksvXXs6pwkqpSu5GjazNoPmbLHtGtCTk6exos+++HHPBU/2E5aM8S34u3C0t0p+bu6QSw5X07a8GdI+1nw1k3tmKS+Lb2iLD06enNytQFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717118990; c=relaxed/simple;
	bh=cN24PCts8cd/+uVtUS2fsYyNPhWnS9RM9MgIE/6VNN0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C//G1e6XXuM55pFGIQdwPGHTrOknEe83NFtNOIWOdihocxt2CVzdaoCb+r+olUugjvsNLvQlk4reTi2bgzphosRUNnfqGnzJmHaJK/ETRKPSqO2AotHdablPJgOquodcm/cxJtLDwPTq0gEM5Mlkmp7X7CLgaX/P7cYX100GMcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=159.65.134.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from gui.. (unknown [125.120.154.162])
	by mail-app4 (Coremail) with SMTP id cS_KCgCnNrTWJ1lmOB00AQ--.34291S4;
	Fri, 31 May 2024 09:28:55 +0800 (CST)
From: Lin Ma <linma@zju.edu.cn>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Lin Ma <linma@zju.edu.cn>
Subject: [PATCH net-next v1] netfilter: cttimeout: remove 'l3num' attr check
Date: Fri, 31 May 2024 09:28:47 +0800
Message-Id: <20240531012847.2390529-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cS_KCgCnNrTWJ1lmOB00AQ--.34291S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr18Cr4xKr4DAF13Ar4fKrg_yoWkGrg_Zr
	Wkta9rZF15Jw4qgw4UKa1fXr9rK34xWF1fuFyfX3y7J3s8twsYgrWv9as0yF17Cw1DKFyU
	Ar4vqryru343KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
	6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/

After commit dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping
information"), the attribute of type `CTA_TIMEOUT_L3PROTO` is not used
any more in function cttimeout_default_set.

However, the previous commit ea9cf2a55a7b ("netfilter: cttimeout: remove
set but not used variable 'l3num'") forgot to remove the attribute
present check when removing the related variable.

This commit removes that check to ensure consistency.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/netfilter/nfnetlink_cttimeout.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index f466af4f8531..eab4f476b47f 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -366,8 +366,7 @@ static int cttimeout_default_set(struct sk_buff *skb,
 	__u8 l4num;
 	int ret;
 
-	if (!cda[CTA_TIMEOUT_L3PROTO] ||
-	    !cda[CTA_TIMEOUT_L4PROTO] ||
+	if (!cda[CTA_TIMEOUT_L4PROTO] ||
 	    !cda[CTA_TIMEOUT_DATA])
 		return -EINVAL;
 
-- 
2.34.1

