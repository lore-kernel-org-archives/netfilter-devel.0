Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677FE3E0C4A;
	Tue, 28 Jul 2026 07:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785224135; cv=none; b=LSaKKAM9goHHKI6eGRAtaEUcwzoDANN1KW8pl8shvNmrqFvv30N2i3msNtSEzARUgwiDhquZ9CtyveUIK7AVb6uqKaui6mJEMSSa6RMgppUZoi2f8E4BT2RCw8FY31Ud9CAX+GGmZEjpzJAmittzOmGPo5YmhSVWzQ/4Z17hvQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785224135; c=relaxed/simple;
	bh=88oMKijMS5flfz6PnFMsJGC7BOZ5lot/+gvxNg3Hjm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J8hOLlECYOfVAA7HXqVwmHNrj0WCjBETlrL11Tt+z4TDchlTtcKg534lPxHHy8F3ED0c9ELMt24FKJGUSplnjOcPOpJvV1b3BTvH+s8uxbX/lRb53sOLKQRaBfJbZO5E6CfuCGFc60ERUc3umnXx2XOYqM4rBPljeabRmvCtlvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=lm0UGZkL; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="lm0UGZkL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-ID:MIME-Version:Content-Transfer-Encoding; bh=hdHcj
	0vOw7H2iiEIlvqDJr0IzX3wk+uoZPxeYcgWfdE=; b=lm0UGZkLp+AvF08b55Fwu
	tN+ODNmjr6NKMBErPZ4zDrBL9avvgbCGYvhlmf7XJhfkw4JrNICA/pDDKBQvmChh
	DRi090UnsHDshd7BQFvGqVQa8cs2qHJOzhKdVOqBL4R/u/m2n97TsROh/kyWQRtE
	zIJdX5IbQw6sbr/6m9XSeU=
Received: from localhost.localdomain (unknown [121.225.135.236])
	by web1 (Coremail) with SMTP id yAQGZQBnCcmwW2hqJim1AA--.58324S2;
	Tue, 28 Jul 2026 15:35:13 +0800 (CST)
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
	stable@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>
Subject: [PATCH nf] netfilter: conntrack: sctp: verify vtag before state changes
Date: Tue, 28 Jul 2026 15:35:06 +0800
Message-ID: <20260728073507.30635-1-zhaoyz24@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yAQGZQBnCcmwW2hqJim1AA--.58324S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZrykWrWrWFyfuFy7Zr4UCFg_yoW5GFy8pa
	yFkryakFyxGr4ay3Z3Kw1vyF4DGrs3C3yakryUAFyvkwn8JF1F9a13K3yxuwn8XFnrKry3
	AFWqqr4YyF1DCrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9m1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl
	84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcx
	kEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8
	Ww4UJr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6I
	AqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xS
	Y4AK67AK6r4xMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GrWkJr1UJwCFx2
	IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
	6r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
	AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
	s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
	0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUtKsbUUUUU=
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAgICAWpn2yG07gAAsu

The packet-wide vtag check in nf_conntrack_sctp_packet() is skipped when
the bundle map contains any chunk type with special vtag handling.  The
per-chunk path re-checks INIT, ABORT, SHUTDOWN_COMPLETE, and
COOKIE_ECHO, but other state-changing chunks still fall through to
sctp_new_state() without validating sh->vtag.

This lets a wrong-vtag packet bundle HEARTBEAT with COOKIE_ACK, ERROR,
SHUTDOWN, or SHUTDOWN_ACK and still advance conntrack state.  That can
desynchronize conntrack from the real SCTP association and cause denial
of service for SCTP traffic behind a stateful firewall.

Check sh->vtag before processing those chunks when conntrack already
knows the expected direction vtag.  This keeps the existing
HEARTBEAT/HEARTBEAT_ACK learning and connection-reuse behavior for the
`vtag == 0` cases.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
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

