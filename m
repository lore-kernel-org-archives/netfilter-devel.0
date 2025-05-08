Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DAB21ADA3
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746740853; cv=none; b=t3ryjWlYs77BpQNeujPwAmNKlgVvQnXHwxfUZ/B7G9Fu6jYKe2fGfEBPiNBxqipVV86Kp6qcRV5OsjCsVtetX9MLTkWPxofoa4rrhSr8G0R+86CZnZ0j5ZSEiuzRfyZOa3aFFTzw6gt+zNlXBgRMVuSm/RYZ9VRm+23qGqKwudc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746740853; c=relaxed/simple;
	bh=LjvmQ2q0LJjgwPwPBcwb/Ar7NdlbTC9MKSbYTNOh0fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQvgb5gf/O937SV5I91lofeh1t9dxz0TzpqfhjUvb7JCZi9nJ6ohVcaJfxdYpPqSKzcRdHRcVjPLGacJDqICxXMX/viYVRNohC2lD2KdR6NQACY5EIFPovnjqTVDPYKt4T3pURVhNi9/gNb+UZNLaIdQllDEkrtI5RphaTNXRKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XqmL7SUn; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XqmL7SUn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=x7fPDt483Yq4VU3STxn0iXTKvHl6ubQ/BGSVZEKcgMw=; b=XqmL7SUnstf3OlMR/hjISGwx0D
	Spcv2HBFvKBqC27ikqcapfiA89JNBnBs2QMgWHIqCW56LlrA5komHn9+i/vVU7QHIsuxLOwD1oGCX
	zaF1kN87xPawVdm2ZLCexUSwDcOOn2higoQPsBnRaR+eqe3StsrP8UaAWyC09myVRcYIiZz7oYAbX
	sD7KONOir4El6QKJOzEesiOFVeB+SmN0Aqf0aRzdXdJKQ4/LQGc7sNJB6jSme+qbQSoIujEn0Jd9V
	/JE+Lfsvj6+vNM5Mh+l4itQnnJMYhVN9dW1+nBpLguOnEILWGXi5s1LDu0saXtVs/5xGQa87w/39t
	1VHa17/A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uD95V-000000000n9-3u5x;
	Thu, 08 May 2025 23:47:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/6] Add test for parse_flags_array()
Date: Thu,  8 May 2025 23:47:16 +0200
Message-ID: <20250508214722.20808-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507222830.22525-1-phil@nwl.cc>
References: <20250507222830.22525-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function introduced in previous patch relaxes JSON syntax in parsing
selected properties which usually contain an array as value to also
accept a string representing the only array element.

The test asserting correct parsing of such properties exposed JSON
printer's limitation in some properties to not reduce the array value
when possible.

To make things consistent, This series enhances the JSON printer by
support for array reduction where missing (patches 2-4), then introduces
a shared routine to combine the common idiom in patch 5. Patch 6 finally
adds the actual shell test case. Patch 1 is merely fallout, a trivial
fix identified when working on the test implementation.

Phil Sutter (6):
  doc: Fix typo in nat statement 'prefix' description
  json: Print single set flag as non-array
  json: Print single fib flag as non-array
  json: Print single synproxy flags as non-array
  json: Introduce json_add_array_new()
  tests: shell: Add test case for JSON 'flags' arrays

 doc/statements.txt                            |   2 +-
 src/json.c                                    |  89 +++------
 .../cache/dumps/0002_interval_0.json-nft      |   4 +-
 .../json/dumps/0001set_statements_0.json-nft  |   4 +-
 tests/shell/testcases/json/single_flag        | 189 ++++++++++++++++++
 .../listing/dumps/0010sets_0.json-nft         |   8 +-
 .../listing/dumps/0012sets_0.json-nft         |   8 +-
 .../listing/dumps/0022terse_0.json-nft        |   4 +-
 ...5interval_map_add_many_elements_0.json-nft |   4 +-
 .../dumps/0006interval_map_overlap_0.json-nft |   4 +-
 .../dumps/0008interval_map_delete_0.json-nft  |   4 +-
 .../maps/dumps/0012map_concat_0.json-nft      |   4 +-
 .../testcases/maps/dumps/0013map_0.json-nft   |   4 +-
 .../maps/dumps/map_with_flags_0.json-nft      |   4 +-
 .../maps/dumps/named_limits.json-nft          |   8 +-
 .../maps/dumps/pipapo_double_flush.json-nft   |   4 +-
 .../dumps/typeof_maps_add_delete.json-nft     |   4 +-
 .../maps/dumps/typeof_maps_update_0.json-nft  |   8 +-
 .../maps/dumps/vmap_timeout.json-nft          |   8 +-
 .../nft-f/dumps/0025empty_dynset_0.json-nft   |  12 +-
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
 .../sets/dumps/dynset_missing.json-nft        |   4 +-
 .../sets/dumps/exact_overlap_0.json-nft       |   4 +-
 .../testcases/sets/dumps/inner_0.json-nft     |   4 +-
 .../sets/dumps/meter_set_reuse.json-nft       |   4 +-
 .../dumps/range_with_same_start_end.json-nft  |   4 +-
 .../set_element_timeout_updates.json-nft      |   4 +-
 .../testcases/sets/dumps/set_eval_0.json-nft  |   4 +-
 .../sets/dumps/sets_with_ifnames.json-nft     |  12 +-
 .../transactions/dumps/0037set_0.json-nft     |   4 +-
 .../transactions/dumps/0038set_0.json-nft     |   4 +-
 .../transactions/dumps/0039set_0.json-nft     |   4 +-
 .../transactions/dumps/0047set_0.json-nft     |   4 +-
 .../transactions/dumps/doubled-set.json-nft   |   4 +-
 75 files changed, 311 insertions(+), 353 deletions(-)
 create mode 100755 tests/shell/testcases/json/single_flag

-- 
2.49.0

