Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794251996;
	b=maGMyJ9JGVzY8hSBHT813c1vraP2XCK95ZA7u40jjeNT4ro1grdZrCzFHrxCnoNIU7ah
	 zHpsi7RU/MIGWn4rlzfOaEqEd68BpVMTseBXnpJfLSac9vX2Ztp7HCmM6bncnPiPaA7jT
	 upj/BIrTMbC3rnNVRo2eoDIuiW8DfO9npMKuREVFO/cn0UQid9zHBlL0qHrg00cM82eCo
	 A0pTgRfiu1mEgVPHAQapOyfquOjQR+W3CRSMMCEV5rwRV6tsYzJQwWUIlm0Qc9u8CF7mg
	 S7QMH/Jav7RneQaE55U2GsLeMXgXTVnSwAoPF3y06SpepcQb0ZFloxffOovAHgXRcvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794251996;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-ZohoMailClient;
	bh=xXRdPVb50TWlk0L6/I1UtmIuajNdhex23Kf/XiKuJzg=;
	b=m74sFqePxIf2C7nAecDdzWN4XLqrCHooQaBYIFjdDWIe22J6Fassm2QczcB6YuJ6iOz/
	 OZobF0Nqp7rjd112LC3JpElx8mE15RIjhHppzQhft3rfz/0guB3xdJaMtTZRTeXaZopw/
	 ztmdFeuJd9psPljQh1XapPFYPWWblynKrqfOeipw2+XWQhjM1OjiNSOhvXav+lRIbJhU8
	 xMfRTiZulTFWkuB58Ut9QS6O3O/XfPNkho8QziappJ3+S9SOUJ3u/Oc4wRrG0tfw6LmPI
	 KAtyp0tl629h8AZ+h0AQ9m0ICtW/lwmc+B/pn/WUOiQhAHdkxpK4CZsKwYbeashL7WA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=O135p7wq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06684606A325;
	Mon,  9 Nov 2026 19:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06684606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=O135p7wq
ARC-Seal: i=1; a=rsa-sha256; t=1794251965; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TqTJOIrRy9nmy6yVksJ69y0B43f/fEog5gMZXAUpd8qmplpqoELUwZAGT5QtraG0RJi9q7b5+ZFoXcNcmRGkB/cAVDkVqLYKvX0przYosV1qplbwZfuSCiyccElYYBNejcx6VFpZvnYAyCP7LwONo/aoDfhvAGOv0n9l8RJiwU0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794251965; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xXRdPVb50TWlk0L6/I1UtmIuajNdhex23Kf/XiKuJzg=; 
	b=i5nM/A3/bRLgwyiJFt78q40+sES7z3VyNm5Jx3tNDM2ImM3c2M//83BZDCmH9FGfv7QNrsLEi9PLFjXsPjz+VEN7xC+Mq0Xb5+5wqwD4L6athFfw3y10m3rulu3skWZhfzhG2RA0FFkZ0COdmvflBU0JX8lNM26I2TviFZqOAw4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=O135p7wqSldtUDN6yRfrG0r7O3ZzhFrZJ6+KsZl/HPlwUQgXes0WtldUXAvninIL7fWzcJNiJwkrgMk1Iezocpkapis8UF1/fvXfnfpTI/GJcymu+aH30dUSwhUjIsVpl/zrJvzAz2/l7+u/jhdkfZHM6Na/nqlZrLdOwrnYaAY=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=xXRdPVb50TWlk0L6/I1UtmIuajNdhex23Kf/XiKuJzg=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794251964738187.39484140775266;
	Mon, 9 Nov 2026 11:19:24 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH nf-next 0/2] netfilter: bridge: refragment packets with a vlan tag moved by the bridge
Date: Mon,  9 Nov 2026 11:18:40 -0800
Message-ID: <20261109191842.57359-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
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
X-ZohoMailClient: External

Fragmented packets are dropped on a vlan filtering bridge with bridge
conntrack when the protocol of their vlan tag differs from the bridge's
vlan_protocol, an 802.1Q tag on an 802.1ad bridge for instance. Patch 1
handles the tag when refragmenting. Patch 2 adds a selftest.

As discussed with Pablo in the first posting
(https://lore.kernel.org/r/atck-NoWvemxIsF6@chamomile), the
DEBUG_NET_WARN_ON_ONCE() change went to nf on its own and is now in the net
tree as 683ff28ab18a. This series is based on that commit and is meant
for nf-next, which does not have it yet.

Changes since the first posting
(https://lore.kernel.org/r/20261020000308.37362-1-laveeshb@laveeshbansal.com):
patch 1 keeps the tag together with the ethernet header instead of in
separate fields, and the selftest runs its checks even if the kernel had
warned before.

I used an LLM tool for the analysis, the code and the test runs.

I tested the series on arm64 and x86_64, with and without KASAN, lockdep
and kmemleak. The selftest fails without patch 1.

Laveesh Bansal (2):
  netfilter: bridge: refragment packets with a vlan tag moved by the
    bridge
  selftests: netfilter: add bridge conntrack test for vlan protocol
    mismatch

 include/linux/netfilter_bridge.h              |   4 +-
 net/bridge/netfilter/nf_conntrack_bridge.c    |  46 +++-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/bridge_ct_vlan_proto.sh     | 198 ++++++++++++++++++
 tools/testing/selftests/net/netfilter/config  |   1 +
 5 files changed, 241 insertions(+), 9 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/bridge_ct_vlan_proto.sh


base-commit: 683ff28ab18accb25268741a724645eee839d41a
-- 
2.43.0

