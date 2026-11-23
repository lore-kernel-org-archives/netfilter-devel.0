Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443445;
	b=n4zTB7zesdpPpNTyl0+owQi6bomjQ81rHEM3xL9FR4vMv6DdSvOr/LQba8Ygs8npDgOL
	 XCuU63GmF0Of/KsgV4ot5sjpZ7t+CTQN+sqfPXgfvYhO80JVS16MHqEMB8o2CWme4zHeQ
	 +/SUwXkNSDVgdYfWS3KDLe4d/0Cn/GnGi3JYs3QzBMqINeO1aDXG9/jmOwqJ1F9ewQ0G3
	 F+L6Uhw0o/LKVvLcyLid69oAoejFC2YiXVjfsxnI1TnjVbqhWDGPe6hfgIrMtSsLLsdg9
	 WCzIR2bKCXPFJZ56c8tu0TBKhPT7nIZdDcvlN47d0bz50a/8qxBc9e2GSMmtw5vKpUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443445;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=NKubuRVGcjnT8cD0gBndGJpHfd9KmEb8Mzby7IEk1GI=;
	b=tDdiHe+NDsCUWabpnJwYUYKut9m6iHzbqeVJorZPfc4reHgCrvea09kcY9qkbY8tl6v3
	 sop9RiT3urGX7WqS45QfLTxVQuV4kVvti0JWPRNlOb7W4EHfRidzxDtqq3XKUpmJ2K0Et
	 oKbMqSmvVjdOOWMF8IrvQNQEGlMo+wjq7QqNTD1sHdPS5v89X2Fu5vYTEgHDJDU5z4oLD
	 TIs0DSGqhWFeVpWr6lv5ost8z3HsdVWl+f682Chu5fBec1/HlVf1AUgLD99X3cGPFCpGa
	 mYDQNX3IY4HHu4VqLOVKC3+pFi65u685g4zDQLfVz9HFojUTCO/YQszYcdnUx5YtDSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tt0GohgS;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D2715606A33F;
	Mon, 23 Nov 2026 14:17:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2715606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tt0GohgS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795443441;
	bh=NKubuRVGcjnT8cD0gBndGJpHfd9KmEb8Mzby7IEk1GI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tt0GohgSM8ldK70LOPdbpenp1UJij8tFcObznYSRwNoyTWk3Y1ZrJKrsAfVw58p+i
	 G5IhfEuyxBDVkpNwt1PcKdE/g0rNioerwpO+h0FK9KqjPB1Zk2SstUn6Hw5GO3EZNc
	 jAIASx8RXYXEHq9O8p9BxunL8mdfUdr0wcWT3wqtkBIWCXwYKIeRJ8/OsHKdnCCkS2
	 pbrGlNcj/JgNA97j+1STntC6UVlM3AP9mIs5oZPlNJH5ewzxtQRGauUqsiGRMbjGVO
	 ewG8Ja2MNc7Xn5pNzYiN4JXsE+XxxdlhPTFhIuMo8GU/5TbznSTsINmNmYlFZPWkNb
	 3Au8MjVsLYMrg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A8C116005F;
	Mon, 23 Nov 2026 15:17:21 +0100 (CET)
Date: Mon, 23 Nov 2026 15:17:19 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/15] netfilter: conntrack: prevent
 nf_conntrack_buckets race condition
Message-ID: <awRK74KlQb4lAxWD@chamomile>
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <20261123135726.3940688-2-pablo@netfilter.org>
 <179544257400.3294.16481017816141150879@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179544257400.3294.16481017816141150879@kernel.org>

Hi,

On Mon, Nov 23, 2026 at 02:02:54PM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.

These are LLM findings, proved in runtime by PoC, not hit in production.
Issues are not theoretical, but not so easy to trigger. Plus one found
by syzkaller in the nft_synproxy code.

For the conntrack series, you need a misconfiguration in place (packet
mangling after conntrack already exists + use of conntrack
timeout/helpers).

For ipset, you can trigger the bugs if you try a bit hard on purpose.

The conntrack bucket sysctl race, again you have to search to hit this
race bug too.

Then, the synproxy issue was found by syzkaller.

TL;AI; Here comes a fashionable lengthy LLM generated summary (now
that generating text is cheap :), I have used the shortened version in
the pull request summary, because I think this is what a human would
like to read, I presume.

(1) Fix race condition in the nf_conntrack_buckets sysctl handler, from
    Fernando Fernandez Mancera.  A single global variable was used as
    temporary parse buffer; since sysctl handlers are not serialized, a
    concurrent reader/writer can clobber it between parse and resize,
    e.g. a monitoring daemon reading while an orchestrator writes.  The
    global state is gone, a local stack variable is used instead and
    serialization is delegated to nf_conntrack_hash_resize().

(2) Validate skb->_nfct against the packet headers.  Loopback skbs
    already come with a conntrack attached, act_ct may attach one too,
    and clsact/pedit may rewrite headers, so a TCP nf_conn can end up on
    a UDP packet.  Revalidate that the skb matches its l3/l4 headers
    and, if not, drop the stale reference and let nf_conntrack_in()
    re-lookup the entry.

(3) Refactor the helper call logic in nf_confirm() into
    nf_confirm_get_protoff() and nf_ct_call_helper(), no functional
    change intended, except that NF_CT_STAT_INC_ATOMIC() is now
    incremented on any NF_DROP, it was elided in some cases before,
    which looks like a bug.  Preparation for the stricter checks in the
    followup patches.

(4) Verify the L4 protocol number matches helper->l4proto before
    calling a helper.  Helpers could be invoked on packets they were not
    designed for, e.g. related ICMP(v6) errors in the original direction
    or conntrack attached via TC/act_ct and the ip protocol later munged
    by pedit.  IPv4 explicitly skips fragments (conntrack normally
    depends on defrag, but that is not guaranteed for ovs/tc) and the
    helper is skipped when the packet carries no payload.  nft_ct.c sets
    l4proto on the helper it allocates to not trip the new guard.

(5) Replace the open-coded helper invocation sites by the new
    nf_ct_call_helper() helper, no functional change intended besides
    the extra checks.

(6) Complete the hardening of the helper invocation sequence: extract
    the *current* tuple from the packet and verify it against the
    conntrack entry, so helpers are not run on packets munged after the
    lookup (act_ct -> pedit) and not on ICMP(v6) PMTU errors, and add a
    full/sane TCP header check for TCP traffic.  Also adds the missing
    nhoff to ipv6_skip_exthdr(), which is needed for conntrack over
    bridge.

    Patches (8) to (12) are a single hardening series for the helper
    invocation path, they should be kept together.

(7) Validate the timeout object protocol in nft_ct before attaching it.
    nft_ct_timeout_obj_eval() only compared the object protocol against
    packet metadata, which does not necessarily describe the entry since
    the header may be modified after conntrack attached it.  Timeout
    objects carry protocol specific arrays, so attaching an object with
    fewer timeout states to an entry with more of them lets the tracker
    read beyond the object.  Require the object protocol to match the
    conntrack tuple protocol, as named timeout policies and the ct
    helper objects already do.  Based on a patch from Kyle Zeng.

(8) Handle only pure SYN and pure ACK packets in nft_synproxy, from
    Nguyen Ngoc Thang.  Any segment with SYN was taken as the client
    initial SYN and any segment with ACK as the client final ACK, so a
    SYN-ACK was answered with a fresh SYN-ACK cookie; when that reply is
    routed back to the same host (e.g. a peer address on lo) it re-enters
    input, it is answered again and never stops, until NET_RX softirq
    keeps the CPU busy and memory fills with skbs and rtable entries and
    the machine OOMs.  Use the same flags as ip(6)t_SYNPROXY: SYN
    without ACK/FIN/RST is the initial SYN, ACK without SYN/FIN/RST is
    the client ACK, anything else falls through.  Two syzbot reports.

(9) Validate hook and priority for the ct zone set expression.
    nft_ct_set_zone_eval() attaches the shared per-cpu template conntrack
    to the skb so that defrag and nf_conntrack_in() pick up the requested
    zone, so this only makes sense before the real conntrack hook: NAT
    chain types are nonsensical since the eval becomes a no-op.  Add a
    .validate callback that restricts the expression to
    PREROUTING/OUTPUT, to priorities before conntrack, to non-NAT chain
    types and to the families where that hook/priority namespace is
    meaningful (ip, ip6, inet, bridge), mirroring the classic xtables CT
    target restriction to the raw table; bridge is further limited to
    prerouting since locally originating traffic is already tracked at
    the IP layer, other families are rejected.  Without this, the
    unconfirmed per-cpu template can reach the confirm hook on paths
    where no conntrack hook runs afterwards and get inserted into the
    global hash table as if it were a genuine connection.

(10) Add rhashtable_flush_and_free() and its rhltable counterpart, from
    Herbert Xu.  ipset needs to flush a live set while readers are in
    flight, so the table briefly becomes NULL to quiesce insertions on
    the old table, then in-flight insertions/removals are waited for,
    rehashes are cancelled, ht->nelems is reset to zero and the new
    table is installed.  Walkers are detached from the old table and the
    dying flag replaces the rcu_head_after_call_rcu() check in
    rhashtable_walk_stop().  The rest of rhashtable is updated to cope
    with a NULL ht->tbl, and the self-rearming of the deferred worker
    moves inside the mutex so rehashes are fully disabled during the
    flush.

(11) Add the rhashtable boilerplate stubs to ipset: the hashtable is
    allocated, initialised and destroyed, but no element is inserted
    yet.  This patch is meant to be devoid of side effects, it is kept
    separate only to reduce the size of the conversion patch.

(12) Replace the ipset internal hash table implementation with
    rhashtable, joint work with Jozsef Kadlecsik.  Notes on the
    behavioural changes:

    - Forced GC on insertion into a full set is removed, it is too
      expensive from the packet path; users can enable FORCEADD or
      reduce the GC frequency.
    - FORCEADD and the MULTI hash type (hash:net,iface) are dropped here
      and added back in patches (5) and (6) of this same series to keep
      the diff size reasonable.
    - initval, bucketsize and hashtable bits options are still accepted
      for backward compatibility, but they are not used anymore.
    - Automatic shrinking stays disabled: ipset hash types only grow,
      and shrinking would also make the dump walker hit -EAGAIN during
      resize, which results in duplicated or omitted elements in a few
      ipset test cases.
    - Left-overs from the old implementation are intentionally kept to
      avoid growing this diff any further (data_next stubs, region
      locking, resize callback and the resize checks in the ipset core);
      they will be removed in a followup series.

(13) Report the size of the dynamically allocated cidr storage in the
    memory usage reported to userspace, this accounting was lost in
    8e5fd2a55e24 ("netfilter: ipset: rework cidr bookkeeping").

(14) Re-add IP_SET_HASH_WITH_MULTI support, i.e. the hash:net,iface set
    type, on top of rhashtable.  A net/cidr/physdev key maps to one
    struct mtype_group which owns a small RCU-protected list of the
    elements sharing that key, each element holding one distinct
    interface/wildcard value.  An rhltable was tried first, but
    hash:net,iface requires control over the insertion order.
    mtype_group_find()/mtype_group_test() give exact elements priority
    over wildcard ones via the mtype_data_isexact() hook, independently
    of the list order, so that:

    - mtype_del() does not remove a wildcard element instead of the
      specific element named in the request,
    - mtype_test()/mtype_test_cidrs() do not shadow an earlier, more
      specific (e.g. nomatch) element,
    - mtype_add() with IPSET_FLAG_EXIST does not tear down an unrelated
      wildcard element while refreshing a specific element that shares
      its key.

    The element count is tracked explicitly through htype->nelems since
    the rhashtable only counts the group heads.  The new
    IPSET_GROUP_MAX_ENTRIES limit bounds the group list length; this is
    not a new restriction, the old implementation provided the same
    implicit upper bound through AHASH_MAX_TUNED (64), and it is kept
    explicit because the list walk becomes expensive as it grows.

(15) Re-add forceadd support that the conversion in (3) removed.  New
    mtype_remove_random() helper looks up a random key slot, a group for
    IP_SET_HASH_WITH_MULTI sets or a plain element otherwise, and evicts
    it so the new element can be added, as it used to be before the
    rhashtable conversion.

Thanks.
