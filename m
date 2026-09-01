Received: from mout-b-106.mailbox.org (mout-b-106.mailbox.org [195.10.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E3935F5E4;
	Tue,  1 Sep 2026 12:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.10.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265916; cv=none; b=akUZm2ncpOsh2Cenpr99zFIrORB0cl6vfqh7BYoVXKItIbxufGBwljxJgGJJMhNS1Dqsgi00f3IfV/kHioE5GshtT4iVci33X1jD5kdMLYZqBiZBSUW8SSHS6TyXnwZQ+r2Occ9Bh8DQjNwGx+/f5AT5hcjrSygTUhMps7rpY3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265916; c=relaxed/simple;
	bh=PMpxVeo8/K+WkAG4crP0i3QfmVnqXj6Y1JQkz8g4L3k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ILz9G+6dFuaZ20SdY/e4HHhQaB63p1vpuRkbgAvHCgP9lwf8Nuq9Lx9V8rBz+jSrvUNvnRtdW7j2QfjHCnMxYz4pdI9XRBfnpIWJ8PYJWLj//ppSYTboSMJA/JQBX0Ym1rFyOITnQ8vZyOOGE8r4bzZIkTb5neX4WXqkdOEv/gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=d+Chb3Xn; arc=none smtp.client-ip=195.10.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="d+Chb3Xn"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-106.mailbox.org (Postfix) with ESMTPS id 4hZ4nN5gMSzNm0Z;
	Tue, 01 Sep 2026 14:25:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1788265512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pt8q8SslG4nV7I2Us5/9H2w2vOb/dJSWRlAn+mdagcE=;
	b=d+Chb3XnA1jUv1Dsp7+FizYruRBRVyTmE3cW0CKSrhfZO8nWqOANtIzuw7Rq2VvvYDjA82
	qziMtREuM3P/qUMVW0K4hVk4RpGUnZ1EMe8ENeXSBWub8IkNyqj2ALEUJpijRy2Wn1MHKI
	rhoQLQD8s72fDr9BVQEGe3sy4bfPsSbZ9eaDLYOQPmN42LvsJB1ao66+PJd8cgEeUrjHd8
	JxYseVvsvj8ZOHGPDOwo5qxf0AbKTHiUeUutz0LnV59YwV4+d5y/VEMnIFXQpyNT4M2L1R
	FTtHRqUkZC8Gz4fjk6LcMIiOj6si+4zL12Df7PEFh92Kvd4h4drXyc60qmcBpA==
From: Ralf Lici <ralf@mandelbit.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: [RFC] ipv6: preserving route lookup provenance in dst caches
Date: Tue,  1 Sep 2026 14:24:59 +0200
Message-ID: <20260901122501.482920-1-ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

While fixing an ovpn IPv6 dst-cache bug, I found what appears to be a
more general race between IPv6 route lookup and cache publication.
Following a suggestion from Sabrina during review, I would like to get
feedback on the intended FIB6 serial-number model and on a possible
kernel-wide fix before attempting a fairly invasive refactoring.

The race
========

For routes without their own rt6_info::sernum, rt6_get_cookie returns
the current fn_sernum of the fib6_node associated with the route's
fib6_info. Persistent caches generally obtain a dst first and sample
this cookie later when publishing it.

This permits the following sequence:

  CPU0                                  CPU1
  ----                                  ----
  ip6_dst_lookup_flow()
    returns Dold

                                        add a more-specific route (for example a blackhole /128)
                                        stamp the affected node and its parents C0 -> C1

  rt6_get_cookie(Dold)
    reads C1 from Dold->from's node

  publish (Dold, C1)

The next dst_check(Dold, C1) compares C1 with the same node's current
fn_sernum, accepts Dold and can continue bypassing the more-specific
route indefinitely. This is different from the normal bounded case in
which one packet uses the result of a lookup concurrent with a FIB
update because the stale result has been paired with a newer validation
token and preserved for future packets.

I reproduced this in ovpn by inserting a delay after
ip6_dst_lookup_flow, adding a more-specific IPv6 blackhole route in the
window and then letting dst_cache_set_ip6 sample the cookie. The cached
route continued to bypass the blackhole.

ovpn can avoid the problem locally by bracketing its lookup with
rt_genid_ipv6 reads and not populating the cache if the generation
changes, as implemented in [1]. However, the same late rt6_get_cookie
pattern exists in several persistent caches, including socket TX and RX
caches, XFRM route/path cookies, dst_cache users, SCTP, flowtable, IPVS
and RXE. Fixing every user independently would also leave future users
exposed.

Proposed model
==============

The cookie is a property of the lookup which selected a dst, rather than
a property that can safely be recovered from a shared dst at some later
time. I'd therefore suggest making cache-producing route lookups return
the pair explicitly, for example:

  struct dst_lookup_result {
          struct dst_entry *dst;
          u32 cookie;
  };

Pointer-only APIs could remain as wrappers for one-shot users which do
not persist the result.

For FIB6 policy lookup, the result would be constructed approximately as
follows:

  gen0 = rt_genid_ipv6(net);
  smp_rmb();

  dst = fib6_rule_lookup(..., gen0);
  cookie = rt6_get_cookie(dst_rt6_info(dst));

  smp_rmb();
  gen1 = rt_genid_ipv6(net);

  result.dst = dst;
  result.cookie = gen0 == gen1 ? cookie : gen0;

The result remains usable for the current packet when the generation
changes. Returning gen0 as the cache cookie makes the result fail later
equality validation, unless the selected node's serial is gen0.

The latter case should also be safe, provided the following writer-side
contract holds:

  1. a routing-visible update is published before its serial is
     allocated and stamped;
  2. node serials are not overwritten with an older allocation;
  3. every invalidation represented by fn_sernum uses a freshly
     allocated serial.

rt_genid_ipv6 reads the same fib6_sernum counter from which node serials
are allocated. Therefore, if a node still has serial gen0, any update
represented by gen0 was visible before the lookup. A relevant later
update must stamp the node with a different serial and make the cached
result fail validation. An unrelated update can conservatively make the
result miss, but it cannot bless a stale route.

Writer-side prerequisites
=========================

Two current paths appear incompatible with that contract.

First, fib6_flush_trees allocates one serial before walking all IPv6
tables, while __fib6_clean_all locks the tables one at a time. A writer
can stamp a not-yet-walked table with a newer serial, after which
fib6_clean_node overwrites it with the older flush serial. For example:

  flush allocates 10 and starts walking table A
  route insertion in table B allocates and stamps 11
  flush reaches table B and overwrites 11 with 10

That regression could revalidate a result carrying fallback cookie 10.
One possible fix would be to allocate the flush serial after acquiring
each table lock, so no writer for that table can allocate a newer serial
before the walk stamps it. This also avoids introducing wrap-aware
serial ordering.

Second, ip6_link_failure writes -1 directly into fn_sernum for a default
route. I think this should instead take the appropriate table lock on
this failure path and perform a normal fresh node/ancestor serial
update.

Routes with rt6_info::sernum
============================

Routes with a nonzero rt6_info::sernum need special handling because
ip6_dst_check currently ignores the supplied cookie and validates them
against the global generation. The pre-lookup generation would need to
be used when obtaining or materializing these per-CPU routes, and
validation should also require the route serial to match the lookup
cookie.

Propagating the result
======================

The pair would have to follow whichever dst ultimately wins through the
higher-level IPv6 APIs, including source-address selection, a possible
second output lookup and optimistic-DAD route replacement. Persistent
caches would store the supplied cookie instead of calling rt6_get_cookie
after the lookup.

XFRM would propagate lookup results through bundle construction, pairing
cached route and path pointers with their cookies instead of sampling
those cookies after the fact.

Two skb handoff points need separate handling.

TCP and UDP obtain an input dst from the skb but sample its cookie only
later when installing sk_rx_dst. A fresh coherent lookup at cache
installation appears less invasive than adding the cookie to every skb.
The sk_rx_dst pointer, cookie and (for TCP) ingress ifindex also form a
logical cache entry and could be published together as an immutable RCU
object.

Flowtable has a similar skb handoff point for the observed direction,
while the opposite direction already comes from a fresh nf_route lookup.
Performing a fresh route lookup for the observed direction at flow
installation would avoid adding provenance storage to struct sk_buff.

Questions
=========

1. Is this race already known, or is there an invariant that makes late
   cookie sampling harmless here? The number of users following this
   pattern makes me wonder whether I have missed some intended
   semantics.

2. Does the proposed approach, including the (dst, cookie) result and
   the implementation details outlined above, look sound, or is there a
   simpler way to preserve route lookup provenance across these users?

I have not started implementing this larger design yet. I wanted to
check the model and expected scope first, rather than produce a large
series based on assumptions that are currently not documented.

[1] https://lore.kernel.org/openvpn-devel/25d830e082b03afb4615aaeed6e0dc1d1370ecbc.1785308184.git.ralf@mandelbit.com/

Thanks,

-- 
Ralf Lici
Mandelbit Srl
