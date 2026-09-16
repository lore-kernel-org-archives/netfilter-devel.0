Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96994457B4;
	Wed, 16 Sep 2026 07:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544246; cv=none; b=MFZ/VrTzrT/YfYKMuENxvdvDWoQNC7uKOpsK3PHmqwgiug8qRFlQ+E5F0PvaZ2OyYhv8lcZN/GycSfXIhAJMV83Hr5BLj846dh74KZdMDABjTXav31sb9wA9kCT13E1b3yx0phh1JKlA8mDUWDRXy5AmORhWeVzNn5L1+Wh5a9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544246; c=relaxed/simple;
	bh=FmYzNaJRkwgmbwI5ocsRqqY7QWvLnBHPBVNWCZYs2fM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QLKmN52DZ05wfHJtMMVaoOPcwf43bxXfaEazIxpVt7Sj7JHdpUgOLNcTugjKmnPXi7UbINwLea674laQc2tgKiquTnZBAUqrzpb8nbya1LMpWOajtX3VAHqYqtyDlwlpS63pzJoO3rtoWoL4K/ZxaPmSJlqFfZj58M9p7OwUNAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAHCzkXR6pqkTXfBw--.33266S2;
	Wed, 16 Sep 2026 15:36:55 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: coreteam@netfilter.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	phil@nwl.cc,
	wenxu@ucloud.cn,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] netfilter: nf_dup_netdev: Fix net_device reference leak in nft_fwd_dup_netdev_offload()
Date: Wed, 16 Sep 2026 07:36:27 +0000
Message-Id: <20260916073627.1971921-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAHCzkXR6pqkTXfBw--.33266S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4UXFW5JF1UKF4xJw1kKrg_yoWkGrX_ur
	y0vryxXF4kAFn2kw4S9FZ7Zrnxta4UXFyS9ryIqFy3Aas8tF10krW8Xrn5ArsrG347GrW5
	Awnrur98t3y3ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbaxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr
	1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUCNtxUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgcMA2qqPpQm1gABsV

In nft_fwd_dup_netdev_offload(), dev_get_by_index() gets a reference to
the net_device corresponding to oif. When nft_flow_action_entry_next()
fails (returning NULL), the function returns -E2BIG directly without
dropping the net_device reference via dev_put(), causing a reference
leak.

Add dev_put(dev) before returning -E2BIG on failure.

Fixes: be2861dc36d7 ("netfilter: nft_{fwd,dup}_netdev: add offload support")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 net/netfilter/nf_dup_netdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 3b0a70e154cd..dd627b7d72d9 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -80,8 +80,10 @@ int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
 		return -EOPNOTSUPP;
 
 	entry = nft_flow_action_entry_next(ctx, flow);
-	if (!entry)
+	if (!entry) {
+		dev_put(dev);
 		return -E2BIG;
+	}
 
 	entry->id = id;
 	entry->dev = dev;
-- 
2.34.1

