Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.76.78.106])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADC63BE17F;
	Mon,  6 Jul 2026 11:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.76.78.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783338530; cv=none; b=LYLDO+T9IO3p4lYehb0UgNaAAj36zOsUXTG3Pvt7L16rVF8U9KcHvoqu9pAJFRAfQVnKz3uIpC2s8aRG+oU5paJd9CU9jyi/MFaTh6Of6SVYglal3uS5z14o/p2bV8BzsTmlwVXl5vTiblZzCUE4gTSPlAj5CZoaIA/7SF93KKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783338530; c=relaxed/simple;
	bh=nEukqTZBZ1X9i1rVreRZyN7lvtpb58xrxYOHWZfd9TM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pcvXw2w4GvG2oC4WupAYurDtBIDdKSaPrt5IyMNSfi930Fz8byf0vrbIdNf1wj7jHmXZyoA1U9NSUajFtDYRmX4Kt0UtQEukLDKiac91dpZKn9Abn8adFlmkYvZXHqkG69vamyLaGvp7+m89l5Sb1pBLAirsyms/t149XwKU6b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=gNWrlvDo; arc=none smtp.client-ip=13.76.78.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="gNWrlvDo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-ID:MIME-Version:Content-Transfer-Encoding; bh=1c5rR
	SeA44CoP10ZtJ1PJVKO0i9gPVa/NJLx733Iw68=; b=gNWrlvDoIYpVYLDEp1IuZ
	rs12UMR++sxykXrw6FScLXojZotehumO1lITeCVlzCqJKNwD9NdUAjt2/dg9UuZP
	iPHyLqYWV5F0i/52/2gTLX62zHJI0znZrntgQG3dFsiiw2brjzuNmKVu+PQQ/JA3
	QZTDDa0Qs6yaMj9qFW9fbQ=
Received: from localhost.localdomain (unknown [101.5.13.242])
	by web2 (Coremail) with SMTP id yQQGZQAn0pQNlktqskzGAg--.22382S2;
	Mon, 06 Jul 2026 19:48:30 +0800 (CST)
From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_conncount: fix zone comparison in tuple dedup
Date: Mon,  6 Jul 2026 19:48:18 +0800
Message-ID: <20260706114820.74006-1-zhaoyz24@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yQQGZQAn0pQNlktqskzGAg--.22382S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCw1rXr4UWF4fZryktF17Awb_yoWrGryrpF
	WYk3sayrWkXrsFkas7ZrnrAF13tws8AF1fGFn5C3y29wn0gFnYvayxta47A3WDCFWDGF1U
	ZF45Wr1DAan8ZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9m1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2
	z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4
	CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx26r4r
	Kr1UJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc
	8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCY02Av
	z4vE14v_Gw4l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8Ww4UJr1UMxC20s
	026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
	JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
	v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
	j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUWUDXUUUUU=
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAQMAAWpLXR9YbwAAsX

The "already exists" dedup logic in __nf_conncount_add() decides
whether a connection has already been counted and can be skipped instead
of incrementing the connlimit count.  It compares the conntrack zone of a
list entry with the zone of the connection being added using
nf_ct_zone_id() and nf_ct_zone_equal(), passing conn->zone.dir or
zone->dir as the direction argument.

Those helpers take enum ip_conntrack_dir values: IP_CT_DIR_ORIGINAL is 0
and IP_CT_DIR_REPLY is 1.  However, zone->dir is a u8 bitmask:
NF_CT_ZONE_DIR_ORIG is 1, NF_CT_ZONE_DIR_REPL is 2 and
NF_CT_DEFAULT_ZONE_DIR is 3.  Passing that bitmask as the enum direction
shifts the meaning of every non-zero value.  An ORIG-only zone passes 1
and is tested as REPLY, while REPL-only and default zones pass 2 or 3 and
test bits beyond the valid direction range.  In those cases
nf_ct_zone_id() can fall back to NF_CT_DEFAULT_ZONE_ID instead of using
the real zone id, so different zones can be treated as equal and dedup
collapses to tuple equality alone.

Do not special-case NF_CT_DEFAULT_ZONE_DIR and do not compare raw zone
ids: that would address only the common bidirectional case and would
bypass the direction-aware NF_CT_DEFAULT_ZONE_ID fallback.  Instead, add
a small conncount-local helper that converts the zone direction bitmask
to a valid enum direction before calling the existing zone helpers.  A
default bidirectional zone contains the ORIG bit, so it naturally maps to
IP_CT_DIR_ORIGINAL; single-direction zones continue to use the existing
nf_ct_zone_id() fallback semantics.

Fixes: 21ba8847f857 ("netfilter: nf_conncount: Fix garbage collection with zones")
Fixes: b36e4523d4d5 ("netfilter: nf_conncount: fix garbage collection confirm race")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
---
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 91582069f6d2..eb3156782405 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -127,6 +127,15 @@ find_or_evict(struct net *net, struct nf_conncount_list *list,
 	return ERR_PTR(-EAGAIN);
 }
 
+static enum ip_conntrack_dir
+nf_conncount_zone_dir(const struct nf_conntrack_zone *zone)
+{
+	if (zone->dir & NF_CT_ZONE_DIR_ORIG)
+		return IP_CT_DIR_ORIGINAL;
+
+	return IP_CT_DIR_REPLY;
+}
+
 static bool get_ct_or_tuple_from_skb(struct net *net,
 				     const struct sk_buff *skb,
 				     u16 l3num,
@@ -211,8 +220,10 @@ static int __nf_conncount_add(struct net *net,
 			/* Not found, but might be about to be confirmed */
 			if (PTR_ERR(found) == -EAGAIN) {
 				if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
-				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
-				    nf_ct_zone_id(zone, zone->dir))
+				    nf_ct_zone_id(&conn->zone,
+						  nf_conncount_zone_dir(&conn->zone)) ==
+				    nf_ct_zone_id(zone,
+						  nf_conncount_zone_dir(zone)))
 					goto out_put; /* already exists */
 			} else {
 				collect++;
@@ -223,7 +234,7 @@ static int __nf_conncount_add(struct net *net,
 		found_ct = nf_ct_tuplehash_to_ctrack(found);
 
 		if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
-		    nf_ct_zone_equal(found_ct, zone, zone->dir)) {
+		    nf_ct_zone_equal(found_ct, zone, nf_conncount_zone_dir(zone))) {
 			/*
 			 * We should not see tuples twice unless someone hooks
 			 * this into a table without "-p tcp --syn".

--
2.47.3

