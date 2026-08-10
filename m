Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E6E3090D4;
	Mon, 10 Aug 2026 19:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388799; cv=none; b=CLtp8IWjvEdKlywoawsm9AORH/uh2pB/8t6LcXduTCofJH+twu1GoKH24aXJXmyQQC6bigzbme+t8eIH+lGgWjblu8Xlvu6uaHixWzdcRGlMgybj8OyLGSFrC1xg40WCvjgNZR5vYeHTuaJn8rmL0tHxPFrZMwpEWDskGGdlmvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388799; c=relaxed/simple;
	bh=rSmL7/s/IyFSLGfBK4kO8c5w7sqbFkp2nYbY1ZPEiPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Hc2AkjT4Qa6TU2QlK0Lv/WcUqUmA/N+90ltxIQKU9FmwOxpvjKGcpnesAkTX3gkFnWSl/QWh2QalLVsJLkXhbShtLGB+7V/ORubZvn/+BeECYZkS+98eiAPXsEgcmEeair+r8p/OSXLUbHOOhAZDcWDjEO3gzxweskN5SuNGHTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UaqMTBUv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UaqMTBUv"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 94697601A2;
	Mon, 10 Aug 2026 21:06:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388793;
	bh=II/BL1RzCR/uFQ8AnfIcxE7NgEePc/Fdwo7SSbtRAoc=;
	h=From:To:Cc:Subject:Date:From;
	b=UaqMTBUvx61AQfUowupIxFgQaSbQflWn6yWDBSUsm+pX0ea6bENy9Fn1qwgPBx3Qg
	 ulnZiFGoTwHSr4Q1vx856XiyZ+w2gxuSmL1ri68P7r03dviPpvGG7TZz27W5eEmc9Z
	 5S5O5MZGxwSZmM/N7Jq1LK0XppIRM3IieRv24G9rEfFZZyu8LBzPhH6LoYRgMvVaKA
	 0NzkWGeRVzpKiPe+PDWHytvYgZhqwokEJviG7k7jauO9IkAkuTFA79BMmxMyTNlA2g
	 l4DnKs3U7Lm56lRXA/iGCM4xQ/1dI9YM0HINU06ft1v3yykDLeg9pu8gAPqg3f4OGR
	 lflk569dSWwEw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 00/13] Netfilter/IPVS fixes for net
Date: Mon, 10 Aug 2026 21:06:08 +0200
Message-ID: <20260810190621.894119-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS fixes for net. Still
large batch for this late -rc cycle but at least have of these fixes in
this batch have been cooking for several weeks before:

1) Fix race between ipset list:set GC and swap, use write_lock instead
   of rcu read lock section when accessing the index to ensure
   interference with ip_set_swap(), from Xiang Mei.

2) Release template conntrack in bridge conntrack when packet is
   neither IPv4 nor IPv6 before setting skb as untracked.
   From Zhiling Zou.

3) A series of 3 patches for IPVS to address sashiko reports:
   Schedulers read destination overload state while connection
   accounting and destination configuration can update it concurrently.
   The first patch adds a single total connection counter. The second
   patch uses it to identify threshold crossings precisely, and updates
   OVERLOAD at the crossings and on a threshold edit under dst_lock.
   The third patch moves configuration-controlled AVAILABLE to a
   separate cflags word, so it cannot clobber OVERLOAD through an
   unrelated read-modify-write update.

4) Log invalid packets in TCP and SCTP connection tracking to address
   a deadlock when nfnetlink_log is used as logging backend and the
   nfnetlink_log conntrack glue support is used. From Zihan Xi.

5) Wait for rcu grace period before releasing pernet state in
   nfnetlink_log, otherwise packets can end up access already released
   memory, triggering UaF. From Florian Westphal.

6) IPVS needs to reset IP information in control buffer in skbuff when
   encapsulating IP packets in ICMP, from Kyle Zeng.

7) IPVS needs to validate ihl field of inner headers in when handling
   ICMP response, from Julian Anastasov.

8) Remove a WARN_ON_ONCE reachable from the nf_tables hardware offload
   when triggering ENOMEM on GFP_KERNEL allocation,
   from Alexey Velichayshiy.

9) Publish reply tuple into the flowtable hashtable first, otherwise
   GC might walk over a released tuple when insertion of the original
   tuple fail. From Jeremy Jean.

10) Elide counter increment when replacing an ipset element,
    from Florian Westphal.

11) Remove unneeded ipset accounting resets on destruction/flush,
    from Florian Westphal.

Sashiko reports pre-existing 8-bit shift and overflow in IPVS which is
planned to be addressed as follow ups.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-08-10

Thanks.

----------------------------------------------------------------

The following changes since commit dd057113ac7ba5bdd2aed3d9405305911152f911:

  mailmap: add entries for Christoph Paasch (2026-08-07 18:20:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-08-10

for you to fetch changes up to 490937b88cb592cc0c5367758edd700fd5abd15c:

  netfilter: ipset: let destroy callbacks adjust ext mem size (2026-08-10 20:28:25 +0200)

----------------------------------------------------------------
netfilter pull request 26-08-10

----------------------------------------------------------------
Alexey Velichayshiy (1):
      netfilter: nf_tables_offload: suppress WARN_ON_ONCE for ENOMEM in abort path

Florian Westphal (3):
      netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state
      netfilter: ipset: fix list type element drift bug
      netfilter: ipset: let destroy callbacks adjust ext mem size

Julian Anastasov (3):
      ipvs: add totalconns for dest
      ipvs: properly update the overload flag on dest edit
      ipvs: revalidate ihl to prevent out-of-bounds access

Jérémy Jean (1):
      netfilter: flowtable: publish GC-visible tuple last

Kyle Zeng (1):
      ipvs: clear IPv4 options after rebasing tunnel ICMP errors

Xiang Mei (Microsoft) (1):
      netfilter: ipset: fix refcount race between list:set GC and swap

Yizhou Zhao (1):
      ipvs: separate destination availability state

Zhiling Zou (1):
      netfilter: bridge: release template ct on non-IP path

Zihan Xi (1):
      netfilter: nf_conntrack: defer invalid log until after unlock

 include/net/ip_vs.h                        |  29 +++++--
 include/uapi/linux/ip_vs.h                 |   6 --
 net/bridge/netfilter/nf_conntrack_bridge.c |   1 +
 net/netfilter/ipset/ip_set_bitmap_gen.h    |   2 +-
 net/netfilter/ipset/ip_set_core.c          |  19 +++--
 net/netfilter/ipset/ip_set_list_set.c      |  10 ++-
 net/netfilter/ipvs/ip_vs_conn.c            |  45 +++-------
 net/netfilter/ipvs/ip_vs_core.c            |  18 ++--
 net/netfilter/ipvs/ip_vs_ctl.c             |  81 ++++++++++++++----
 net/netfilter/ipvs/ip_vs_dh.c              |   4 +-
 net/netfilter/ipvs/ip_vs_lblc.c            |   2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c           |   8 +-
 net/netfilter/ipvs/ip_vs_lc.c              |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c      |   2 -
 net/netfilter/ipvs/ip_vs_proto_tcp.c       |   2 -
 net/netfilter/ipvs/ip_vs_sync.c            |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c            |   7 +-
 net/netfilter/nf_conntrack_proto.c         |   6 ++
 net/netfilter/nf_conntrack_proto_sctp.c    |  12 ++-
 net/netfilter/nf_conntrack_proto_tcp.c     | 132 +++++++++++++++++++----------
 net/netfilter/nf_flow_table_core.c         |   7 +-
 net/netfilter/nf_log_syslog.c              |   4 +-
 net/netfilter/nf_tables_offload.c          |   2 +-
 net/netfilter/nfnetlink_log.c              |  13 ++-
 24 files changed, 270 insertions(+), 153 deletions(-)
