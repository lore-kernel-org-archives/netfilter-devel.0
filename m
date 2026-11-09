Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.187.6.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242847;
	b=daI1T1EG+5TzSAuoDpOEubosQm8bPHj+DwmnmMutu+1h+8/X/eF+S+C2W0KaOiSV7Bur
	 NKbimpu0NKAR+swjEFLciI5IsO0RMSZxtCbdDpbu2UMaUan7Pw49Mx+TztsjKLd/UAdbF
	 Z7XRZpRG5onOwcRAIsdzqRAqoczjzRCZfEMJVAPdJDvZ4/1maHLY6h3dlzeuVcfK91vzK
	 +rLkSZDrNUopJ2+dwak/YOQ94okyvG5TQMaDSXTKsqEqJyHskFY+F5C4Qu45KfglZM1/8
	 KFt+d2rXCae5z34eUIQZL/IW11+PQ85wLHKJg9ZzEr38M3SZx/lx6gO84ohfWlrTjow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242847;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=Jh09cejyLyw22IOlwKMtjgCkmRjtIzNNLXD3r5ks7Rk=;
	b=DQ+ikaZrapyjgnFOLYgzoWs7zpYf4/fLQ2E5PqgOllbijemvEPZ7Pud5ZKsLHhdr1kE9
	 tjqwLvCZ5tw94KHhsykhBgitAuC0FlFpS/60PTaDWN8RPR2HmsXFjTDzwSwK9Qp9nbQwY
	 pai4ms3StH0PFPmIPFRB73Mk36/lBV4Ujw0voUzvzjPRHLQWc1wiCKcqOCU/cUPURi7Mt
	 uTMeF74vDf9S59jenxiWGd0w94lgE/PfArZKSJBRmYLK6N5wvIiH9q1tsIx6ShpivhBYx
	 bDBbfnl7Y8vrpggl81VGu82uztZYetvc1KC8mzA3gTg95WtY2jDJnbpqr87TIXiC7wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mails.tsinghua.edu.cn;
	spf=pass smtp.mailfrom=mails.tsinghua.edu.cn;
	dkim=pass header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.a=rsa-sha256 header.s=dkim header.b=R13s6C17;
	arc=none smtp.remote-ip=52.187.6.220
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.187.6.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD15606A321;
	Mon,  9 Nov 2026 16:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BD15606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.a=rsa-sha256 header.s=dkim header.b=R13s6C17
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=Jh09cejyLyw22IOlwKMtjgCkmRjtIzNNLX
	D3r5ks7Rk=; b=R13s6C17EDaD+PQR+3et8lmGUEluEW/S5bDrPPsLpB06Xxrstd
	p31CPpCGsLuAPARrXbp6LcFvGB7QkJjWEkk7X7MQbFty9pu+eFMXL4soj/b2MG86
	kWUTt7x4ThI7BcUnQFEiQG0/wn8rbbQXnikSkxBmArAVWiID/BVEr5ypM=
Received: from localhost.localdomain (unknown [202.112.47.69])
	by web4 (Coremail) with SMTP id ywQGZQCXWAYQ+fFq9djgAQ--.9376S2;
	Tue, 10 Nov 2026 00:47:12 +0800 (CST)
From: zhangmh25@mails.tsinghua.edu.cn
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	jianjun@tsinghua.edu.cn,
	Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Subject: Re: [PATCH net] netfilter: nf_reject: validate TCP header length before sending resets
Date: Tue, 10 Nov 2026 00:47:00 +0800
Message-Id: <20261109164700.3867689-1-zhangmh25@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <179372144385.488856.3773065210102501294@kernel.org>
References: <179372144385.488856.3773065210102501294@kernel.org>
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
X-CM-TRANSID:ywQGZQCXWAYQ+fFq9djgAQ--.9376S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXw17Wr4rXrW3GF1DJr1DKFg_yoW5ArWrpF
	Z5K3W0qw4kKryIgrZ2k3WrW340yrn5Ka13JF1rKryrJa4YgF109FWagFWjgayYyrsYg342
	qrWjq343CF1DZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBq14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCY02Avz4vE14v_JwCF04
	k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18
	MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr4
	1lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1l
	IxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4
	A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7sRihSdtUUUUU==
X-CM-SenderInfo: x2kd0wlpkskqxpdlz2oowvx0pjkxthxhgxhubq/1tbiAQEGB2rxhf6p0QAAsZ

From: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>

Hi,

thanks for the reviews, and sorry for the delayed reply.

Pablo: yes, TCP conntrack already handles this. tcp_error() in
nf_conntrack_proto_tcp.c checks both bounds (th->doff*4 <
sizeof(struct tcphdr) || tcplen < th->doff*4), so on the paths where
conntrack runs before the reject rule a segment with an inconsistent
data offset is classified INVALID, and a ruleset that drops INVALID
packets there never passes it to the reject target. The netdev and
inet ingress reject paths run before conntrack, so they are not
covered by that. The v2 description states the affected
configurations. Agreed on nf-next as the target tree -- picking
net.git was a batch routing default on my side, not the model's call.

The Sashiko review is correct as well: v1 closes the underflow
relative to skb->len, but on the netdev ingress and bridge paths the
skb is not trimmed to the IP-declared length, so a data offset that
runs past the declared segment can still pass the check when enough
trailing bytes are present, and the ACK computation counts padding
bytes that were never part of the segment.

The rework follows the first option the review suggests: the segment
length is derived from the IP header -- skb_ip_totlen() for IPv4,
payload_len minus the extension header chain for IPv6 -- and is used
for both the data offset check and the ACK calculation. skb_ip_totlen()
keeps the skb length for BIG TCP GSO packets, which carry tot_len == 0,
and the IPv6 side preserves the existing skb-length handling when
payload_len is zero (jumbograms and BIG TCP aggregates), so neither
changes behaviour for GRO aggregates: inet_gro_complete() and
ipv6_gro_complete() update the declared lengths to the aggregate, and
aggregates past 64 KiB are covered by the zero-length handling on
both sides. I preferred this over trimming oldskb the way the
unreach paths do: it is read-only and leaves the skb alone
mid-evaluation.

One boundary is deliberately left out: the TCP checksum gate keeps
its skb-length basis. Whether it rejects a padded segment whose
checksum was signed over the IP-declared length depends on
skb->ip_summed and the hook, exactly as before. In the tested
configuration (netdev ingress, software verification running) the
QEMU probes sign their checksums over the padded length, which is
what that path verifies, so the tests cover the length handling and
not that pre-existing inconsistency. I can look at the checksum basis
separately if that is worth unifying.

The QEMU tests cover the netdev ingress path with trailing-byte
probes on both families and an Ethernet-minimum-frame padding probe
on IPv4, with otherwise valid TCP headers.

I will send v2 to netfilter-devel as a separate thread, with a lore
link to this submission, the discovery and testing process spelled
out, and without the stable Cc.

Thanks,
Minghao Zhang

pw-bot: cr

