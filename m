Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3922882AC
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104760; cv=none; b=eElZMMcyyY896gG52lbkQ6Y2kkGkd70EeELaV01jmRwFHXiuSNCWy4EnkrETMLT94VHKMDTuG6DzIpqEgISvRxAsXBew1KOan/IB3vZG8EBXez68eeVrkqFENLvvdOI/npssrqXK6ykMOfhR0LhKn/XQ+FIs8/vYaEb2X5ABO0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104760; c=relaxed/simple;
	bh=xBZWKBJ22WhWQbsZhcjX/br4iulwq5LAhdorFN2vMwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XAVjlgCM5V6t2MP/iTzLRD64NzjPNiA0rslxDKfaCAc+hDNw/Xhl9+tZMIBeT7gBpuUncFJ+blsH+7iFDroCE4KyEqkBoRAF19UGCh5L0WdkzDOiGt9GwLY1iQjx0Xcal5u5r859/MUMoooZjTVQRSIQe+YAsWCfTVhsr3mD22o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iv0DDIPC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iv0DDIPC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QxSz/2g7m6pX1VuDhxUNDilIqUSht46nGX9aZVt9inw=; b=iv0DDIPCx2ZmeAHhTxPE9S7plO
	rHzfwtyopRV3l5duMspw/Z2IsyWqdRj9u0lYuWfUFXoLnTCSRLAzLm014/Q/fdvHn3XVH1lUVJFcb
	4OUo+/D5NPN/9xkXLwCcGZl5WPK28Fp//BCBQv9dH2obrL0y+lLXY6xcWyc6FH7R0lle1HJOj0jNA
	5s0cwGw5siz0SdqcsOD6Zql6lHhYwYQKwmlwdJTaYNlDGYOa5y+CXVbfCg6fClanhGrpVnp+/CAeC
	WOwZtG6Jk4v42LnW+DdhU2ycEchb3mQmSTgq8ytQhpYOwpnqGzmRJLqLVtFnifUe2ghArAYzEKuDH
	FhdjFwcA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvC-000000003nJ-405a;
	Wed, 13 Aug 2025 19:05:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 00/14] json: Do not reduce single-item arrays on output
Date: Wed, 13 Aug 2025 19:05:35 +0200
Message-ID: <20250813170549.27880-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series consists of noise (patches 1-13 and most of patch 14) with a
bit of signal in patch 14. This is because the relatively simple
adjustment to JSON output requires minor adjustments to many stored JSON
dumps in shell test suite and stored JSON output in py test suite. While
doing this, I noticed some dups and stale entries in py test suite. To
clean things up first, I ran tests/py/tools/test-sanitizer.sh, fixed the
warnings and sorted the changes into fixes for the respective commits.

Phil Sutter (14):
  tests: py: Drop duplicate test in any/meta.t
  tests: py: Drop stale entries since redundant test case removal
  tests: py: Drop stale payload from any/rawpayload.t.payload
  tests: py: Drop duplicate test from inet/geneve.t
  tests: py: Drop duplicate test from inet/gre.t
  tests: py: Drop duplicate test from inet/gretap.t
  tests: py: Drop stale entry from inet/tcp.t.json
  tests: py: Drop duplicate test from inet/vxlan.t
  tests: py: Drop redundant payloads for ip/ip.t
  tests: py: Drop stale entry from ip/snat.t.json
  tests: py: Drop stale entries from ip6/{ct,meta}.t.json
  tests: py: Drop stale entry from ip/snat.t.payload
  tests: py: Fix tests added for 'icmpv6 taddr' support
  json: Do not reduce single-item arrays on output

 src/json.c                                    |   8 +-
 tests/py/any/log.t.json.output                |  15 +-
 tests/py/any/meta.t                           |   1 -
 tests/py/any/meta.t.json                      |  38 ---
 tests/py/any/queue.t.json.output              | 117 ++++++++
 tests/py/any/rawpayload.t.payload             |   6 -
 tests/py/inet/fib.t.json                      |   8 +-
 tests/py/inet/fib.t.json.output               |  87 +++++-
 tests/py/inet/geneve.t                        |   1 -
 tests/py/inet/geneve.t.json                   |  29 --
 tests/py/inet/gre.t                           |   1 -
 tests/py/inet/gre.t.json                      |  17 --
 tests/py/inet/gretap.t                        |   1 -
 tests/py/inet/gretap.t.json                   |  17 --
 tests/py/inet/snat.t.json.output              |  22 ++
 tests/py/inet/synproxy.t.json                 |   8 +-
 tests/py/inet/synproxy.t.json.output          |   8 +-
 tests/py/inet/tcp.t.json                      |  31 ---
 tests/py/inet/vxlan.t                         |   1 -
 tests/py/inet/vxlan.t.json                    |  29 --
 tests/py/ip/ip.t.payload.bridge               | 261 ------------------
 tests/py/ip/ip.t.payload.inet                 | 176 ------------
 tests/py/ip/masquerade.t.json.output          |  46 +++
 tests/py/ip/redirect.t.json.output            | 118 ++++++++
 tests/py/ip/snat.t.json                       |  33 ---
 tests/py/ip/snat.t.json.output                |   8 +-
 tests/py/ip/snat.t.payload                    |  14 -
 tests/py/ip6/ct.t.json                        | 164 -----------
 tests/py/ip6/dst.t.json                       |  23 --
 tests/py/ip6/dst.t.payload.inet               |  10 -
 tests/py/ip6/dst.t.payload.ip6                |   8 -
 tests/py/ip6/frag.t.json                      | 121 --------
 tests/py/ip6/icmpv6.t                         |   2 -
 tests/py/ip6/icmpv6.t.json                    |  58 ----
 tests/py/ip6/icmpv6.t.json.output             |  36 +++
 tests/py/ip6/ip6.t.json                       |  40 ---
 tests/py/ip6/masquerade.t.json.output         |  46 +++
 tests/py/ip6/meta.t.json                      |  58 ----
 tests/py/ip6/redirect.t.json.output           |  70 +++++
 .../cache/dumps/0002_interval_0.json-nft      |   4 +-
 .../netdev_chain_dormant_autoremove.json-nft  |   4 +-
 .../json/dumps/0001set_statements_0.json-nft  |   4 +-
 tests/shell/testcases/json/single_flag        |  48 ++--
 .../listing/dumps/0010sets_0.json-nft         |   8 +-
 .../listing/dumps/0012sets_0.json-nft         |   8 +-
 .../listing/dumps/0022terse_0.json-nft        |   4 +-
 ...5interval_map_add_many_elements_0.json-nft |   4 +-
 .../dumps/0006interval_map_overlap_0.json-nft |   4 +-
 .../dumps/0008interval_map_delete_0.json-nft  |   4 +-
 .../maps/dumps/0012map_concat_0.json-nft      |   4 +-
 .../testcases/maps/dumps/0013map_0.json-nft   |   4 +-
 .../maps/dumps/delete_element.json-nft        |   4 +-
 .../dumps/delete_element_catchall.json-nft    |   4 +-
 .../maps/dumps/map_with_flags_0.json-nft      |   4 +-
 .../maps/dumps/named_ct_objects.json-nft      |   8 +-
 .../maps/dumps/named_limits.json-nft          |   8 +-
 .../maps/dumps/pipapo_double_flush.json-nft   |   4 +-
 .../maps/dumps/typeof_integer_0.json-nft      |   4 +-
 .../dumps/typeof_maps_add_delete.json-nft     |   4 +-
 .../maps/dumps/typeof_maps_update_0.json-nft  |   8 +-
 .../maps/dumps/vmap_timeout.json-nft          |   8 +-
 .../testcases/maps/dumps/vmap_unary.json-nft  |   4 +-
 .../dumps/0012different_defines_0.json-nft    |   8 +-
 .../nft-f/dumps/0025empty_dynset_0.json-nft   |  12 +-
 .../testcases/nft-i/dumps/set_0.json-nft      |   4 +-
 .../optimizations/dumps/merge_vmaps.json-nft  |   4 +-
 .../dumps/skip_unsupported.json-nft           |   4 +-
 .../packetpath/dumps/set_lookups.json-nft     |   8 +-
 .../dumps/0004replace_0.json-nft              |   4 +-
 .../dumps/0011reset_0.json-nft                |   4 +-
 .../sets/dumps/0001named_interval_0.json-nft  |  16 +-
 .../0002named_interval_automerging_0.json-nft |   4 +-
 .../0004named_interval_shadow_0.json-nft      |   4 +-
 .../0005named_interval_shadow_0.json-nft      |   4 +-
 .../dumps/0008comments_interval_0.json-nft    |   4 +-
 .../dumps/0009comments_timeout_0.json-nft     |   4 +-
 .../sets/dumps/0015rulesetflush_0.json-nft    |   4 +-
 .../dumps/0022type_selective_flush_0.json-nft |   4 +-
 .../sets/dumps/0024synproxy_0.json-nft        |   4 +-
 .../sets/dumps/0027ipv6_maps_ipv4_0.json-nft  |   4 +-
 .../sets/dumps/0028autoselect_0.json-nft      |  12 +-
 .../sets/dumps/0028delete_handle_0.json-nft   |   4 +-
 .../dumps/0032restore_set_simple_0.json-nft   |   8 +-
 .../dumps/0033add_set_simple_flat_0.json-nft  |   8 +-
 .../sets/dumps/0034get_element_0.json-nft     |  12 +-
 .../0035add_set_elements_flat_0.json-nft      |   4 +-
 .../sets/dumps/0038meter_list_0.json-nft      |   4 +-
 .../sets/dumps/0039delete_interval_0.json-nft |   4 +-
 .../0040get_host_endian_elements_0.json-nft   |   4 +-
 .../sets/dumps/0041interval_0.json-nft        |   4 +-
 .../sets/dumps/0042update_set_0.json-nft      |   4 +-
 .../dumps/0043concatenated_ranges_1.json-nft  |   8 +-
 .../dumps/0044interval_overlap_1.json-nft     |   4 +-
 .../sets/dumps/0046netmap_0.json-nft          |  16 +-
 .../sets/dumps/0049set_define_0.json-nft      |   4 +-
 .../dumps/0051set_interval_counter_0.json-nft |   4 +-
 .../sets/dumps/0052overlap_0.json-nft         |   4 +-
 .../sets/dumps/0054comments_set_0.json-nft    |   8 +-
 .../sets/dumps/0055tcpflags_0.json-nft        |   4 +-
 .../sets/dumps/0060set_multistmt_1.json-nft   |   4 +-
 .../sets/dumps/0062set_connlimit_0.json-nft   |   8 +-
 .../sets/dumps/0063set_catchall_0.json-nft    |   4 +-
 .../sets/dumps/0064map_catchall_0.json-nft    |   4 +-
 .../sets/dumps/0069interval_merge_0.json-nft  |   4 +-
 .../0071unclosed_prefix_interval_0.json-nft   |   8 +-
 .../sets/dumps/0073flat_interval_set.json-nft |   4 +-
 .../dumps/0074nested_interval_set.json-nft    |   4 +-
 .../sets/dumps/concat_interval_0.json-nft     |   8 +-
 .../sets/dumps/concat_nlmsg_overrun.json-nft  |   4 +-
 .../sets/dumps/dynset_missing.json-nft        |   4 +-
 .../sets/dumps/exact_overlap_0.json-nft       |   4 +-
 .../testcases/sets/dumps/inner_0.json-nft     |   4 +-
 .../sets/dumps/interval_size.json-nft         |   8 +-
 .../sets/dumps/meter_set_reuse.json-nft       |   4 +-
 .../dumps/range_with_same_start_end.json-nft  |   4 +-
 .../set_element_timeout_updates.json-nft      |   4 +-
 .../testcases/sets/dumps/set_eval_0.json-nft  |   4 +-
 .../sets/dumps/sets_with_ifnames.json-nft     |  12 +-
 .../sets/dumps/typeof_sets_concat.json-nft    |   4 +-
 .../transactions/dumps/0002table_0.json-nft   |   4 +-
 .../transactions/dumps/0037set_0.json-nft     |   4 +-
 .../transactions/dumps/0038set_0.json-nft     |   4 +-
 .../transactions/dumps/0039set_0.json-nft     |   4 +-
 .../transactions/dumps/0047set_0.json-nft     |   4 +-
 .../transactions/dumps/doubled-set.json-nft   |   4 +-
 .../transactions/dumps/table_onoff.json-nft   |   4 +-
 126 files changed, 944 insertions(+), 1305 deletions(-)
 create mode 100644 tests/py/inet/snat.t.json.output

-- 
2.49.0

