Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032836;
	b=duqVcbKYS2hjAlon0rDIj7V7xH3fRWx8cuPrUoHTiITIU8MZzCPbal8A/DLuCmi7oEE8
	 1v/N/Q4KZDdTw8q3RQUR6svm34F7Qoxyx7b5NpsPOOZFQEvFa6dQPmgIDBEr6Uy2qTO79
	 O67ZOdZ3nDmXQOTUTTM7PODe8t3IpxZtoy94JQa3kQiRoF1MK0EDJr3qSKvx/lXpRZy7v
	 yeS7v3n1wEiiE6OccPtwAs6STaGoGhpWyPCIOl7rLjfm2e133+nAsqxyCoYiluebYrzLo
	 clRw/Buim6FPEPtXpsUvQiHi88KAhVnEUO5yoZkaXkidBYMiEy4OBqykwagw6t3dqZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032836;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=lDXhbpMKUl7ISgBnZfj/IedauZ9SDiSIZpfzv9Z13y8=;
	b=avpmQeXqNti5o36KyhFqEIVH/Y9vxxdapdofEFiVh0rMIvT1FcrEPaR80irmqDUm02to
	 g5VkWdxCkYRMQRnMByvxAgEE/+lfgZa4iApNTBBXSsVGikPhDKRfDrE2i6lq1qgmS6EbL
	 6EzUKzoxIhj5+xxCMkivZPiZsRu/oRBdV9fcohO1m0vNpK7OI3/LsuM+Lpbqosskfmp9y
	 jvq5yvcxsL7v7P7jnupnAGp1pgg7DWS4mJlB+UnstasC4tBY4ImD+BnF860cZSy5iVbG0
	 bHd9XyBX1mUy1mLfPg57Ps5oKOeEPOjzE3mhvdK+4n0fiCbfiVjgp2NzCvJ/HJ25Oyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Jpep7sDz;
	arc=none smtp.remote-ip=74.125.82.225
Received: from mail-dy1-f225.google.com (mail-dy1-f225.google.com [74.125.82.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB71260A2620
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 20:13:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB71260A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Jpep7sDz
Received: by mail-dy1-f225.google.com with SMTP id 5a478bee46e88-3704d30b84fso2227160eec.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:13:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795032835; x=1795637635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lDXhbpMKUl7ISgBnZfj/IedauZ9SDiSIZpfzv9Z13y8=;
        b=r7g0fkRY3qhqfSlUXUjZp9wXqdaJAQ4KhW2x6g/0qIz112Q9DTOU0rajPlJMIFdSk/
         IQ2zwo7qMfOpFHxQqmdZEHxmrPOu6jYTHtrLsfUpbHTrjvOUilAMCPv9ovokf1d+/LXq
         BUXTqFk9t8W0hH93i/axa68uag8tFk0wPk32Q8vOp0YbZDxzGDum0E5tV4/eXqNLky9x
         rn6Dx7EBkgK5KMZpcemfcELhXeGxLvBTcVWJbScPp3c5kAOuI5tW5HTPKT62ymmOsAVb
         ubTos4d4ziQRIsIzBg4/eb1pKoSPc8vrvrXDzFKOpvbI45QB0FiuLK+hEXAYdSW3+uLi
         L/oA==
X-Forwarded-Encrypted: i=1; AL+hErFocDismZNoOaQnK/BinL+XaqIiIfaHrGTKAn6y5q/lu0NJZkt4J6X4XOTxVLan2ss09Vuz6mCN/Budg2W44MI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+vgUWC4hOdxpqeCD5TFyqc3Kki1llSnbEj/z1cIGY6yXztiY1o
	Qqglf3sfimyOsCz/x1/4UsIqWmsfKfpz+NXrTJ3dOpDKQ/mBfsiOStNqvDGw3pBIQ49Lblr4TuI
	7ZranebM/iRRjKtxdYzrxAgxYn5EqZ4JJZGeSi1eXuWR1l4p18KAgnXnAWRx5CQwwCidiBgVXOJ
	iFcPberjO1slu9jdvd5L3kW1KSK6fhflM72q4qo3PIiMFjPn/UWkTWo7MRW8jZqjjyrl6mENi0b
	SoTXd2tGE7PbjGPDFEmrMx5MuzV
X-Gm-Gg: AYBFou1PnCtxXcpjWXzMxk/H0AseaKom9M36mT3utuR9nGMcOaPxV0DoPDdM15aiWUP
	9ahvExezo7MFWxdV2r31MB+iLVfGs9h/DGHnYfzVXppttxEzguqatBSdR7bvjYIQoKO+24fafv1
	WQMb/2ir2sAnFTvJpXvcT2LdAspL+e1ylGJNeoKDUGoliuCMEew/gLOzKhKgynwDlrFkvj/ZP/5
	WGptS8BujJlHNBDgaTH62OCOyWBiMvCTdp6mNsObhT8JTvxrdUe5iZBi/ctQdMnNOSJNAJ2one5
	TTqihd3nEr41jw7RFq/9TFisqi6edwtNdfKb6x7PB5zkpkPHvA/TG8XQ/Ql4IUIKnSeTmWPfP6v
	f8KlMGRnNl96u6xgmn2VegGtrIwyMFcj+hqhRH9ui4pByOGU+tLTcbWQP9xSEusIePCCEHiAv+T
	kZgFf/HuIVgpnSCz7FYnjiyU8UM6e7OhF/wwSFyyXgeF4=
X-Received: by 2002:a05:7301:714:b0:376:f63a:cb24 with SMTP id 5a478bee46e88-3827da11892mr3393682eec.3.1795032834304;
        Wed, 18 Nov 2026 12:13:54 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-382a7db18desm141556eec.25.2026.11.18.12.13.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 12:13:54 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-55d3e7ba879so26926681cf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795032832; x=1795637632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lDXhbpMKUl7ISgBnZfj/IedauZ9SDiSIZpfzv9Z13y8=;
        b=Jpep7sDz2EJWI9hZMR2W0pc+SzWJf4CIrgdpDZqXr9JYyExwWMH71NbYuJ6s7WyY8B
         HlAplMcZDeObXddACBH9ztkkIgoZEsz9dfhA909cJyu4zoNjMwS8KFffuFaJdUHa+bti
         IM0ZeUpvk6UGOin1OLdfHMySzP6fXtO666MoI=
X-Forwarded-Encrypted: i=1; AL+hErGXgEYYK0hTotQj2K8B/MUygo9JXTFjlDjGC7666HY4U+1BHaEoPyJIcIicwGjoT95ax1uxBiI6NBlvuo4U47I=@vger.kernel.org
X-Received: by 2002:a05:622a:2306:b0:535:a5fb:6446 with SMTP id d75a77b69052e-55d5a7351damr52255371cf.64.1795032832277;
        Wed, 18 Nov 2026 12:13:52 -0800 (PST)
X-Received: by 2002:a05:622a:2306:b0:535:a5fb:6446 with SMTP id d75a77b69052e-55d5a7351damr52254921cf.64.1795032831764;
        Wed, 18 Nov 2026 12:13:51 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66c2a5a2sm7675091cf.21.2026.11.18.12.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 12:13:51 -0800 (PST)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Toshiaki Makita <toshiaki.makita1@gmail.com>,
	linux-kernel@vger.kernel.org (open list),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH net 1/4] netfilter: flowtable: do not queue offload work after DESTROY
Date: Wed, 18 Nov 2026 12:12:47 -0800
Message-ID: <20261118201250.2075007-2-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
References: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

nf_flow_offload_refresh() can be reached by a packet path reader which
looked the flow up before it was torn down. NF_FLOW_PENDING keeps the
DESTROY work from being queued while another work item is pending, but
once the DESTROY work has run and cleared the bit, a reader can take it
again and queue a REPLACE (or STATS) work for a flow which is already
being removed.

GC removes a hardware flow after NF_FLOW_HW_DEAD is set, and frees it after
an RCU grace period, which the reader can outlive in a preemptible RCU
read-side section. The queued work then dereferences a freed flow and
the flowtable, and can program the hardware again with a rule keyed by
the freed flow's cookie.

NF_FLOW_HW_DYING is set when DESTROY is queued, and DESTROY needs
NF_FLOW_PENDING, so a work item which holds the pending bit and finds
NF_FLOW_HW_DYING clear prevents DESTROY from being queued until it
completes. Check it after taking the pending bit, and do not queue
anything other than DESTROY when it is set.

Not reproduced: this is a race between a long RCU read-side section and
the GC and offload workers. Found by review of a related change.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..62f460d38efa 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1088,6 +1088,19 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
 		return NULL;
 
+	/* GC only removes a hardware flow after its DESTROY work has run, and
+	 * NF_FLOW_PENDING keeps another one from being queued, so nothing can
+	 * free the flow while this work is pending, unless DESTROY was queued
+	 * before we took the pending bit. A reader which found the flow before
+	 * it was torn down must not queue more work then, as the flow could be
+	 * freed before that work runs.
+	 */
+	if (cmd != FLOW_CLS_DESTROY &&
+	    test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
+		clear_bit(NF_FLOW_PENDING, &flow->flags);
+		return NULL;
+	}
+
 	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
 	if (!offload) {
 		clear_bit(NF_FLOW_PENDING, &flow->flags);
-- 
2.53.0

