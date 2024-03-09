Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE25364AB
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984138; cv=none; b=cUs0bG0k87zn7MUniKVUnUYNrfTlpLUESSr0Hg3be7EUOvOeMT0wI5FLvltPdjF7yHu8+xvIxugAaqqLhZQAXeVXqAUwDeTW77/UqQ1IquEQ9yAJSZF1PNAIKQ3uc6FNu+GF2JVrgthGyqngn13a/T/pyuqyrpI2ktXkgapOl64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984138; c=relaxed/simple;
	bh=bDxBplO8hEXClJ0sEF7Yv2U6GRfZlmERZApqYteYFbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=luJwX2bn7RxEEq4rWr4WD7nLSbSbkYYMyMOqDcuWS5bQd/+Fab6HdrsJjtd2/dgw2X68aIOKlL8dYe2dXTbN3sINmXVir9VihET0k+5KmbV0O7uWfiBFDZnFvVU0+v06wmBrG5A9Gl3iVRhi9PakJEo5RuK+As7f2NvHKoALz+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mnZ5N8By; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mnZ5N8By"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H96mLM5u4mDbjezNkVtzB3YCjNX2AgWTb+/H4HOOSfM=; b=mnZ5N8By1xnV2s3Pu3HU31k7Ny
	h2BUjxIJBf6RCZT65QSq9cLSpcKHf3I3XVtM/OsZMG5TuOn1tZrdLd4VXkdARyND1SnTTVbBXYSR7
	zRayF4QPqJGrLTcWWpDrAujqsuYDW8U1CC7UJ+arZNv4Xbx0LmEPSZgtLLW3XLNWOvSxddX9fzGiD
	SJMIUhX4wSlEdEtj9iBCyaqj62AO5vqgReY7omFflYxi6qmOcFIEgL8Jbd0dlg1VzqBmPrxmIlgRT
	Y1mNgdxCmYvviqEcAgWi24uiJ2RoY+vIyPRb3yU8qCR+VOsYwbjlqNox6/wlAKPha8Ena3srjpd6z
	/NNvNiLg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riuzF-000000003hP-3bHV;
	Sat, 09 Mar 2024 12:35:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 0/7] A bunch of JSON printer/parser fixes
Date: Sat,  9 Mar 2024 12:35:20 +0100
Message-ID: <20240309113527.8723-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the following flaws in JSON input/output code:

* Patch 3:
  Wrong ordering of 'nft -j list ruleset' preventing a following restore
  of the dump. Code assumed dumping objects before chains was fine in
  all cases, when actually verdict maps may reference chains already.
  Dump like nft_cmd_expand() does when expanding nested syntax for
  kernel submission (chains first, objects second, finally rules).

* Patch 5:
  Maps may contain concatenated "targets". Both printer and parser were
  entirely ignorant of that fact.

* Patch 6:
  Synproxy objects were "mostly" supported, some hooks missing to
  cover for named ones.

Patch 4 applies the new ordering to all stored json-nft dumps. Patch 7
adds new dumps which are now parseable given the fixes above.

Patches 1 and 2 are fallout fixes to initially make the whole shell
testsuite pass on my testing system.

Bugs still present after this series:

* Nested chains remain entirely unsupported
* Maps specifying interval "targets" (i.e., set->data->flags contains
  EXPR_F_INTERVAL bit) will be printed like regular ones and the parser
  then rejects them.

Phil Sutter (7):
  tests: shell: maps/named_ct_objects: Fix for recent kernel
  tests: shell: packetpath/flowtables: Avoid spurious EPERM
  json: Order output like nft_cmd_expand()
  tests: shell: Regenerate all json-nft dumps
  json: Support maps with concatenated data
  parser: json: Support for synproxy objects
  tests: shell: Add missing json-nft dumps

 src/json.c                                    |  18 +-
 src/parser_json.c                             |  35 +-
 .../dumps/0001_cache_handling_0.json-nft      |  16 +-
 .../dumps/0005_cache_chain_flush.json-nft     |  28 +-
 .../dumps/0006_cache_table_flush.json-nft     |  28 +-
 .../dumps/0011endless_jump_loop_1.json-nft    |  75 +++
 .../comments/dumps/comments_0.json-nft        |  16 +-
 .../flowtable/dumps/0001flowtable_0.json-nft  |  16 +-
 .../dumps/0005delete_in_use_1.json-nft        |  16 +-
 .../dumps/0014addafterdelete_0.json-nft       |  22 +-
 .../json/dumps/0001set_statements_0.json-nft  |  24 +-
 .../json/dumps/0005secmark_objref_0.json-nft  |  18 +-
 .../listing/dumps/0013objects_0.json-nft      |  16 +-
 .../dumps/0021ruleset_json_terse_0.json-nft   |  16 +-
 .../listing/dumps/0022terse_0.json-nft        |  24 +-
 .../dumps/0007named_ifname_dtype_0.json-nft   |  16 +-
 .../dumps/0008interval_map_delete_0.json-nft  |  24 +-
 .../maps/dumps/0010concat_map_0.json-nft      | 106 ++++
 .../testcases/maps/dumps/0011vmap_0.json-nft  | 145 +++++
 .../testcases/maps/dumps/0012map_0.json-nft   |  16 +-
 .../maps/dumps/0012map_concat_0.json-nft      |  24 +-
 .../testcases/maps/dumps/0013map_0.json-nft   |  24 +-
 .../maps/dumps/0024named_objects_0.json-nft   | 165 ++++++
 .../maps/dumps/anon_objmap_concat.json-nft    |  24 +-
 .../dumps/map_catchall_double_free_2.json-nft |  46 ++
 .../testcases/maps/dumps/named_ct_objects.nft |   4 +-
 .../maps/dumps/named_limits.json-nft          |  24 +-
 .../maps/dumps/named_snat_map_0.json-nft      |  16 +-
 .../maps/dumps/pipapo_double_flush.json-nft   |  16 +-
 .../dumps/typeof_maps_add_delete.json-nft     |  40 +-
 .../maps/dumps/typeof_maps_update_0.json-nft  |  32 +-
 .../maps/dumps/vmap_mark_bitwise_0.json-nft   | 158 +++++
 .../maps/dumps/vmap_timeout.json-nft          | 229 ++++++++
 tests/shell/testcases/maps/named_ct_objects   |   2 -
 .../nft-f/dumps/0002rollback_rule_0.json-nft  |  22 +-
 .../nft-f/dumps/0003rollback_jump_0.json-nft  |  22 +-
 .../nft-f/dumps/0004rollback_set_0.json-nft   |  22 +-
 .../nft-f/dumps/0005rollback_map_0.json-nft   |  22 +-
 .../nft-f/dumps/0017ct_timeout_obj_0.json-nft |  16 +-
 .../dumps/0018ct_expectation_obj_0.json-nft   |  16 +-
 .../nft-f/dumps/0022variables_0.json-nft      |  24 +-
 .../nft-f/dumps/0029split_file_0.json-nft     |  18 +-
 .../nft-f/dumps/0032pknock_0.json-nft         |  24 +-
 .../optimizations/dumps/merge_vmaps.json-nft  |  26 +-
 .../optimizations/dumps/skip_merge.json-nft   |  32 +-
 .../dumps/skip_unsupported.json-nft           |  16 +-
 .../dumps/comments_objects_0.json-nft         | 102 ++++
 .../owner/dumps/0002-persist.json-nft         |  19 +
 .../testcases/owner/dumps/0002-persist.nft    |   3 +
 .../packetpath/dumps/set_lookups.json-nft     |  24 +-
 tests/shell/testcases/packetpath/flowtables   |   6 +-
 .../dumps/0011reset_0.json-nft                |  32 +-
 .../sets/dumps/0001named_interval_0.json-nft  |  16 +-
 .../dumps/0008create_verdict_map_0.json-nft   |  78 +++
 .../dumps/0022type_selective_flush_0.json-nft |  16 +-
 .../sets/dumps/0024synproxy_0.json-nft        | 131 +++++
 .../sets/dumps/0026named_limit_0.json-nft     |  22 +-
 .../sets/dumps/0028autoselect_0.json-nft      |  24 +-
 .../0037_set_with_inet_service_0.json-nft     |  24 +-
 .../sets/dumps/0038meter_list_0.json-nft      |  16 +-
 .../sets/dumps/0042update_set_0.json-nft      |  16 +-
 .../dumps/0043concatenated_ranges_0.json-nft  |  24 +-
 .../dumps/0045concat_ipv4_service.json-nft    |  16 +-
 .../sets/dumps/0048set_counters_0.json-nft    |  24 +-
 .../sets/dumps/0049set_define_0.json-nft      |  24 +-
 .../dumps/0051set_interval_counter_0.json-nft |  24 +-
 .../dumps/0058_setupdate_timeout_0.json-nft   |  16 +-
 .../dumps/0059set_update_multistmt_0.json-nft |  24 +-
 .../sets/dumps/0060set_multistmt_0.json-nft   |  24 +-
 .../sets/dumps/0060set_multistmt_1.json-nft   |  24 +-
 .../sets/dumps/0064map_catchall_0.json-nft    |  16 +-
 .../0071unclosed_prefix_interval_0.json-nft   |  16 +-
 .../sets/dumps/dynset_missing.json-nft        |  24 +-
 .../testcases/sets/dumps/inner_0.json-nft     |  16 +-
 .../testcases/sets/dumps/set_eval_0.json-nft  |  24 +-
 .../sets/dumps/sets_with_ifnames.json-nft     | 551 ++++++++++++++++++
 .../sets/dumps/type_set_symbol.json-nft       |  32 +-
 .../transactions/dumps/0040set_0.json-nft     |  20 +-
 78 files changed, 2490 insertions(+), 677 deletions(-)
 create mode 100644 tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0011vmap_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0024named_objects_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_objects_0.json-nft
 create mode 100644 tests/shell/testcases/owner/dumps/0002-persist.json-nft
 create mode 100644 tests/shell/testcases/owner/dumps/0002-persist.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft

-- 
2.43.0

