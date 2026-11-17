Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.64.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916427;
	b=kMKU5Ctfg1ArJhNuc6sI+0/DFCJem3wKBMRyC/PMRwjGDt7oYlENWd70ZJg+bi4Bs3L+
	 QjJcT+/dBX7X9BEq4GEOr2und5sZGFSxzKXl/8UmJEnMbQPYVibLCyuhDXToNWuim257G
	 sbpejg8/FEUI+wAFKzUBM4f4KVNspaeUgvN0MT6RySiuwUsq2kHjnzcblXEhnrCqHBzmY
	 a6wVxx5n4F2jhOJqlWcpI+ej1OEPuRAMaNk7QL743V9rYyD+xJxB/R09Ecl3cFLzyFCFC
	 tsA0F94W7RJjXxF4Rt3zg7hExQDRBMHDjmi27umUpsJ3yYf1uhhma5WE2IH+JQR3JoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916427;
	h=DMARC-Filter:Received:X-ICL-RepId:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Info-Out:X-Proofpoint-GUID:
	 X-JNJ;
	bh=ns7yWOxeWCLlUtscnHrHlNmxNz7q83rrXK4tG+VKh8Q=;
	b=VWJEcSPkuKUkF7yjn+c+sdvm4V2kAv2zABW7NOrtQbbKpYpq8ePWCA+AhLKIpAHgz0wg
	 gUz6O/sBXSbiaNtJOOT9bQqMslmzwcBmVzY/p9ht/oOlEBSVD/A7rUDawZkwdVKQe7SMD
	 nf43V1/f8B2LZ4o+Ogamc7C3g0lxHFUhgbq1XLbiNWa9l7A7dcf2VIrRU/hg1Msqpghjx
	 D5wpn+anKPAKuumM//g2sL7npEfxlbYQADAH5y7Ps6VLBdPVA+w3on94GC5MlrIvJgCm8
	 pfv7GnvvHHxh9FuTqQvPPf6NF75gLNhk/LH9hnS0bUKjOOsWD3q7cXp8gkMgGx7VdEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=verdict.gg;
	spf=pass smtp.mailfrom=verdict.gg;
	dkim=pass header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=CeOBFq9W;
	arc=none smtp.remote-ip=57.103.64.226
Received: from outbound.pv.icloud.com (pv-2002f-snip4-5.eps.apple.com [57.103.64.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9426C606A32A
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9426C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=CeOBFq9W
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPS id B31C0180021F;
	Tue, 17 Nov 2026 11:53:42 +0000 (UTC)
X-ICL-RepId: 01a1e95b-134a-7881-8211-7e3aa6e1aea3
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1794916424; x=1826452424; bh=ns7yWOxeWCLlUtscnHrHlNmxNz7q83rrXK4tG+VKh8Q=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=CeOBFq9Wq6SF12AI3PIzC+yhacxQt06xNouKJjDYd/qlyO54ahFa5blSVQqEIW8aBrn0DFA/uxXTz61OcMdOHpxWquuFr/humHVgOfb+KCc6v7ayUySzfKoV0Js+0hG6eaM0BL8OJdYUmtse09rKsObZ3Feq5ZHn1ly7uXiVC8zPV+nGBkHhVfGkTWa+QjC/aIwb4CfPxh2uzCXKQ84uh6wofzK/2/7ODq+K3Khk0x7jc30H//h2h8iFpd2dpla2lZixugv0DmKIMqYjlfJNjgHeb3b1goy2Y5qS+GlOAo3Cphw3bGa4uNy6K4A8AR/8TBAb4XWQjfgQZJMBCil+gA==
mail-alias-created-date: 1621344842221
Received: from DelNac.mail.msk (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPSA id D715218001BF;
	Tue, 17 Nov 2026 11:53:37 +0000 (UTC)
From: Vladimir Vdovin <deliran@verdict.gg>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dev@openvswitch.org,
	linux-hardening@vger.kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Vladimir Vdovin <deliran@verdict.gg>
Subject: [PATCH nf-next v1 0/5] netfilter: nf_conncount: reduce list_lock contention at the limit
Date: Tue, 17 Nov 2026 14:53:03 +0300
Message-ID: <20261117115308.95134-1-deliran@verdict.gg>
X-Mailer: git-send-email 2.56.0
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
X-Proofpoint-ORIG-GUID: gEgYC-vKQFDSq_RvjCOrLk78npJMFyKi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA0NyBTYWx0ZWRfX5PyWIkEjCkfp
 UVH0iuk1ep33Ra8VI5YwxsacQFIG2OLtr85rLHrCgMggSnsssrCSnTdCqlU3vmLIsQ13RtJvm5c
 i3QCpr+zKIdlJ05RuRQZrd7inXU3H7k=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA0NyBTYWx0ZWRfX+266nEAjpd+A
 ZlpjiECXwQSLGExP/07Il/YeSYfZzFeK9iVxRdVG7/1NJrM7q29LS/hrjjUUeNlUHpC8D40UQq4
 XV/OT9MK3x84ZK8fMeIzC6WIhcO/uLkxx6bynHzXFaiXutwnZoY/Gv4uQ8D/W6eeVB8YhIw4jM8
 nxSJxkhk1sq8C0yxnXwHfty0fXywKSjf0xkEJeDF9dZFoz27yMetHtCrE9lFhVA/d+LS8Pg54ca
 TPRGWNWMCpeE6q2t0Ugs+LR7ydbeyiNtBf+TdDV0jLCWm6xsgCHlJ/Sr1PNs9DY0nGRcS64nYxf
 sORcIXaXKqht2bfbKOH+E5i8HUpIygof/C5lrvllmQm/BRy/rCEnmItUlh5j9o=
X-Authority-Info-Out: v=2.4 cv=INaXmQvG c=1 sm=1 tr=0 ts=6afc4048
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=51JdnUhQRHFq8RItG6ly:22 a=fpMW3eChgMEhEGMGJwAh:22 a=VwQbUJbxAAAA:8
 a=gNQ-XgrdbNVyKNSONi8A:9
X-Proofpoint-GUID: gEgYC-vKQFDSq_RvjCOrLk78npJMFyKi
X-JNJ: AAAAAAAB2ZSvn9er+OVtv4+IN7hZNp8adE7ID9HES50oPVljIASVO1/9qXGk/kl/jZf/OW
 AUNCFd9hm1k5trrijJTAzELliLWlBVqwEwS5PRDwTCLVOnoQo61AexRBfwNO52YoAnlIdk
 4V7KPRZ6qjv8A/KDx1awDHaMrL3O5ONEEJ8lk2o84l44SeozKP5f3BQ6YO81PoiYbKpH3T
 rl0D9rofM3eiXShp1WxJFliV7nOtwRc3GOPYZuq5NEsNOx5EA3+K3k1rYNJKD0EEQRbC0D
 hWc/JqN48XBivY5J4JmC8i6Y8DLhgH/bFeOZMZpuIWZlHKkzdAPNVJ9llIqT56MJK/t58m
 DQBrOzslF4mbH+Vj0IpH7FOyUmjzXBMHsHLYS/06xkTsk97crQo5b2NKdHeCADawn+X4hc
 /0/RmekxVFvqsC4GEK8r2tRLdabZq69ILntLNIotlbPhuNDswursJV8Uvambj5hEzqGWaX
 ZPR7GAOouw3Xyltc/PDQI38AiPHHZiW/L4RXIaAtvC4XpQqX34BZ84e1W25p9Fhjvj6L26
 oXWKMuJfIJqshiHRihMDY0or2BiKUBX+WGCGsWS61faWFJUZKxx/2TiQaDACTqcVRitJ8P
 qFW/D1x7FeKaqufZ4FGfy6AVsZXf73fSKNIGXOA5OW9AQ2BC3xujuImig82HrfYIn5i9sJ
 QBUVP2Xk6qTrtF2FkzmID84jRUTvbvMRaOko4s20dUEqMdH+QRtHo6EgLBmcBkqzEdoB10
 2JnpMPqsOPrZH0jPRlY6JmHB6eh1b3vPRKUn0yVSTozJ98os0XCXtHz54Q5MFlPEV+nklM
 E3qzqs2yoFHiTG8bphsvsmS3epSddwtq2x02VzZARQUvIVHOWYYBlfZHUoqTMY63Z1WgWv
 VqBkgWjDL9vGJ/gFyj2Pcqt75vB6+tYqcpMZu6u23k3F+CDxhOG02mpgwbhLqCS0DAvOHV
 rvzKy5z/dkeia9rEDbeKn5Z2BM2MBwcWJYjYltsQTrTi7Ss6+3FagVIWP7voHLfPwtCesD
 wU3ts0p9fcNa5RcYExxat+lbE3lTlb2JZO9pAPW1A4vtqfXZqszuGgrmhF6oGKJYYOzr9I
 CXKuNwkpOkTd6R4EXXF/esmWbXhAGGNCyTM3DVA53gw0TKW7UeSquvsmVXp+qGmQ4zT/ZQ
 9A9WA/j7EEiiMS1kz4D9Xco9enqvrzE7ANb0aUeLhKZuAApJz3ZoJ4UjqZyphhl3PkOFoZ
 /guLMvpZueJ/5bir5xkRmczLMZzLOTFyAJz21rIAR5aV8XrMFSHAMCc5aW2EIE7C4Q7Qev
 HJG5DREYdE4fdQozRFNEB9cStHQUQvozDSlyp6BVC3RjhnfJR/8IDk/2NBv0bx1u5cVWsq
 jG/mxnlBL7qAxPMEeXsYjJqVeEv2SVCms4JaH/OCR5fDnbWHPDTkrArr

Follow-up to [1]: Florian asked for the slot count to come from the
cpu count, Fernando for a way to see the contention. Additional
profiling showed the slot locks were not the main problem, the
per-key list is.

The setup is a 128-cpu hypervisor (64 rx queues) running openvswitch
with per-zone conntrack limits under a 2 Mpps SYN flood against one
VM. OVS keys nf_conncount by zone id, so the whole zone shares one
nf_conncount_list and its list_lock. Once the zone is at its limit
(500k), 96.8% of all cycles are in native_queued_spin_lock_slowpath
behind the spin_lock_bh() in count_tree(), and the host is
unreachable.

Two things add up to that:

 * openvswitch has no way to ask whether the zone has room without
   recording the connection, so above the limit every packet still
   takes list_lock, records an entry that ovs_ct_commit() rejects at
   once, and leaves it for gc to evict;

 * the gc walk stops after 64 *evicted* entries, but live entries and
   -EAGAIN entries do not count, so under flood every walk covers the
   whole list: 500k nf_conntrack_find_get() under list_lock with BH
   off. And nf_conncount_gc_list() takes the trylock before it checks
   whether gc already ran this jiffy, so the count-only lookup is not
   lockless either.

Patch 1, nf_conncount: bound the gc walk by examined entries.
  A pass stops after 128 examined entries and the list is rotated so
  successive passes still cover all of it.

Patch 2, nf_conncount: check last_gc before taking list_lock.
  The count-only lookup stays lockless when gc already ran this
  jiffy; one cpu per jiffy touches the lock, the rest read the count.

Patch 3, nf_conncount: size the number of slots from the cpu count.
  Florian's suggestion from [1].

Patch 4, openvswitch: do not record connections above the zone limit.
  Look the count up first with the existing count-only mode of
  nf_conncount_count_skb() and record only below the limit.

Patch 5, openvswitch: warn about a zone above its limit without a lock.
  The shared state of net_warn_ratelimited() was 2.7% of all cycles.

Each half was also tried alone: patches 1-3 without 4 leave the host
as it was (94% in the slowpath, recording path), patches 4-5 without
1-3 too (97%: the check and the recording are not atomic, every gc
pass that dips the count below the limit lets a burst of cpus record
past it, and the first of them walks the whole list under list_lock).

Numbers, two separate before/after measurements on the same machine.

1. The production case, before and after the whole series:
   openvswitch, zone at its limit, 2 Mpps SYN flood.

                      spinlock slowpath   softirq   host
    unpatched         96%                 100%      unreachable
    patches 1-5       0%                  40%       responsive

2. The nf_conncount part alone, without openvswitch, before and after
   patches 1-3: two netns over a veth pair, iptables "-m connlimit
   --connlimit-above 10000 --connlimit-mask 0" in the receiving one
   (one list, the same shape as a zone), trafgen in the other with 64
   threads sending SYNs from random sources to random ports. veth
   delivers on the sending cpu, so that is 64 cpus on one list_lock.
   Measured with the list full:

                      nf_conncount_count_skb()   calls/s
    unpatched         0.5 - 4 ms                 40k
    patches 1-3       16 - 64 us                 340k

   The lock stays contended here, over 90% of all cycles in the
   slowpath both before and after, because connlimit records every
   connection, see below. What changes is how long the lock is held
   per acquisition, and with it how many packets get through.

The connlimit matches record before they compare, as openvswitch did,
and unlike openvswitch they cannot stop: a match does not know whether
the connection will be dropped, and a softlimit setup needs the
connections above the limit counted. So they keep the convoy, and
patches 1-3 are what helps them.

Tested on the nft side with a ct count test between two netns (limit
enforced, closed and dropped connections reclaimed, list recovers
after being full) under DEBUG_LIST and lockdep.

[1] https://lore.kernel.org/all/20260413123712.42993-1-deliran@verdict.gg/

Vladimir Vdovin (5):
  netfilter: nf_conncount: bound the gc walk by examined entries
  netfilter: nf_conncount: check last_gc before taking list_lock in
    gc_list
  netfilter: nf_conncount: size the number of slots from the cpu count
  openvswitch: conntrack: do not record connections above the zone limit
  openvswitch: conntrack: warn about a zone above its limit without a
    lock

 net/netfilter/nf_conncount.c | 86 +++++++++++++++++++++++++++++-------
 net/openvswitch/conntrack.c  | 31 +++++++++++--
 net/openvswitch/datapath.h   |  1 +
 3 files changed, 99 insertions(+), 19 deletions(-)


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.56.0

