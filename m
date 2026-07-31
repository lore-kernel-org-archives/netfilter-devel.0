Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC0542C4FE;
	Fri, 31 Jul 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509648; cv=none; b=sScVSQPdc24SCtzEtlv3zMQGeRA5pSCKomJOf2jt/XU1tNoF9nSZOWDncnfIOsRpMAVccl6+31aqjtnOrhMaz7lVsQ7kQbL0w8i1Yc9gBZOUXAVsKw9PC+z6CvjCmoZFWZIJQ1d+7zN8Gu06U8UZpUYRItRnA/LzaeM3j2oY7ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509648; c=relaxed/simple;
	bh=y4nMOC9rQwMNh9/QY5ohrtC8GVSatFRMMa5dqqJ11SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CsugH0ahsa2ILb0AvwGZSlbPs9UONZWGWJeZ3VbhYKsKEpP9dmIHe865a7zwLZvR0euMpvgiRT+Bcwkc3L1rjw7m1Hpg9zDOqepvqMqMUBC+hskyPfV40pgdnwsDlNI4bvzHWzF5/SqbEIQAbbiMGVBnI3cDWp7DQn6o1PK4VCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=DpSmphZ6; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="DpSmphZ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-ID:MIME-Version:Content-Transfer-Encoding; bh=eEBf+
	+lMlqIjYQrTOiYA3dW3YJg7bayGuafygzjVaDw=; b=DpSmphZ6xA+AMRNLVPqSb
	V64JubUX4q+k2vE6B00gDRKHiFt1BwaDGJHwonE27J4Ct4pQeh4hVUQ0jH/Aao5y
	W4L+0+Sm+skIweYF31/0I56PY1q6slpDYJl/+sbxmXoik3VMUPwkEk+aO26Two8N
	y8P6jGDKHwHlIlbv2bkPlw=
Received: from localhost.localdomain (unknown [106.111.19.240])
	by web1 (Coremail) with SMTP id yAQGZQBnCcn4tmxqZRvfAA--.52498S2;
	Fri, 31 Jul 2026 22:53:46 +0800 (CST)
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
	Ke Xu <xuke@tsinghua.edu.cn>
Subject: [PATCH nf-next] netfilter: conntrack: sctp: validate vtag before state changes
Date: Fri, 31 Jul 2026 22:53:41 +0800
Message-ID: <20260731145342.56890-1-zhaoyz24@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yAQGZQBnCcn4tmxqZRvfAA--.52498S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZrykWrW5XF4ftFy7Xry5urg_yoW5GryDpa
	yFkr1agFyxGr4ayan3Kw1vyF47Grs3C39FkryUCFyvkwn8JF1Fga13K3yxuw1DZF1DKry3
	AFZ0qr4YyF1DCwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9v1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
	F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzx
	vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_GrWk
	Jr1UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5c
	I20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxkIecxE
	wVAFwVW5XwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4rKr1UJr1l4I8I3I
	0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
	GVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
	0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
	rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJV
	WxJrUvcSsGvfC2KfnxnUUI43ZEXa7VU1m9aPUUUUU==
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAQYFAWprzrTllAAAsJ

The packet-wide vtag check in nf_conntrack_sctp_packet() is skipped when
the bundle map contains a chunk type with special vtag handling.  The
per-chunk path re-checks INIT, ABORT, SHUTDOWN_COMPLETE, and COOKIE_ECHO,
but other state-changing chunks can still reach sctp_new_state() without
validating sh->vtag.

This lets a wrong-vtag packet bundle HEARTBEAT with COOKIE_ACK, ERROR,
SHUTDOWN, or SHUTDOWN_ACK and update SCTP conntrack state.  The resulting
state can diverge from that of the SCTP association.

Check sh->vtag before processing those chunks when conntrack already
knows the expected direction vtag.  This keeps the existing
HEARTBEAT/HEARTBEAT_ACK learning and connection-reuse behavior for the
`vtag == 0` cases.

Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude Code:GLM-5.2
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://lore.kernel.org/netfilter-devel/amx58O5Jb6B29XDJ@chamomile/
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7e10fa65cbdd..9978ecd05b1e 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -407,9 +407,17 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			/* (D) vtag must be same as init_vtag as found in INIT_ACK */
 			if (sh->vtag != ct->proto.sctp.vtag[dir])
 				goto out_unlock;
-		} else if (sch->type == SCTP_CID_COOKIE_ACK) {
-			ct->proto.sctp.init[dir] = 0;
-			ct->proto.sctp.init[!dir] = 0;
+		} else if (sch->type == SCTP_CID_COOKIE_ACK ||
+			   sch->type == SCTP_CID_ERROR ||
+			   sch->type == SCTP_CID_SHUTDOWN ||
+			   sch->type == SCTP_CID_SHUTDOWN_ACK) {
+			if (ct->proto.sctp.vtag[dir] &&
+			    sh->vtag != ct->proto.sctp.vtag[dir])
+				goto out_unlock;
+			if (sch->type == SCTP_CID_COOKIE_ACK) {
+				ct->proto.sctp.init[dir] = 0;
+				ct->proto.sctp.init[!dir] = 0;
+			}
 		} else if (sch->type == SCTP_CID_HEARTBEAT) {
 			if (ct->proto.sctp.vtag[dir] == 0) {
 				pr_debug("Setting %d vtag %x for dir %d\n", sch->type, sh->vtag, dir);
-- 
2.47.3

