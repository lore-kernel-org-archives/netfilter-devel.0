Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4CA189F59;
	Mon, 15 Jul 2024 13:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721049569; cv=none; b=YewwEcgSVCfz3DtIX1mqz8AfYyFsedCg2RLpv9r+LkgTrMxSbRjSxFyqQVcO7BcFk4KuK0Kjhk4YTuOG9frVnlMz5+X3A0vscCCCcXqeHSFWZ2EyTnMbThq8ahfE632zHgUgJcFZvXIbuHtQxZqWqNNVkl7swR1OmrNYFO+kVog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721049569; c=relaxed/simple;
	bh=A2MzHVm2704ZVOhFqo+pTDlbtY+sF5fEeAsMUtLmyqY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cwuMoLKmCNRtCbL2ydI+MwoRhI6fbUN1IG2rEMfDwJUtuD7zERj9uo4dlQdQttewZ5dqGZEE7jgaTHJEw2JYO9jGc+lalFBYNEx1xNkODu0Gu7+Uqfle8DWS+hVdIJiLuT9WSirYmeM9HGjDA5bU6iek4oFMFoLLFTrkoUTIh84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=none smtp.mailfrom=orbyte.nwl.cc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orbyte.nwl.cc
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <n0-1@orbyte.nwl.cc>)
	id 1sTLHu-000000006Xl-3LyZ;
	Mon, 15 Jul 2024 14:58:42 +0200
Date: Mon, 15 Jul 2024 14:58:42 +0200
From: Phil Sutter <phil@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.2.7 release
Message-ID: <ZpUdAmsdAZloGBgH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-announce@lists.netfilter.org, lwn@lwn.net
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fURed8NtU5OwByFY"
Content-Disposition: inline
X-DSPAM-Result: Whitelisted
X-DSPAM-Confidence: 0.9994


--fURed8NtU5OwByFY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.2.7

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

This release contains fixes only:

* Avoid potential use-after-free when clearing set's expression list
* Avoid misc buffer overflows in attribute setters
* Implement nftnl_obj_unset symbol already exported in libnftnl.map
* Remove unimplemented symbols from libnftnl.map
* Drop some unused internal functions
* Validate per-expression and per-object attribute value and data length
* Enable some attribute validation where missing
* Fix synproxy object setter with unaligned data
* Fix for unsetting userdata attributes in table and chain objects

See ChangeLog that comes attached to this email for more details on
the updates.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.

--fURed8NtU5OwByFY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnftnl-1.2.7.txt"

Florian Westphal (1):
  expr: fix buffer overflows in data value setters

Nicholas Vinson (1):
  chain: Removed non-defined functions

Pablo Neira Ayuso (7):
  object: define nftnl_obj_unset()
  set: buffer overflow in NFTNL_SET_DESC_CONCAT setter
  set_elem: use nftnl_data_cpy() in NFTNL_SET_ELEM_{KEY,KEY_END,DATA}
  obj: ct_timeout: setter checks for timeout array boundaries
  expr: immediate: check for chain attribute to release chain name
  udata: incorrect userdata buffer size validation
  utils: remove unused code

Phil Sutter (24):
  set: Do not leave free'd expr_list elements in place
  tests: Fix objref test case
  expr: Repurpose struct expr_ops::max_attr field
  expr: Call expr_ops::set with legal types only
  include: Sync nf_log.h with kernel headers
  expr: Introduce struct expr_ops::attr_policy
  expr: Enforce attr_policy compliance in nftnl_expr_set()
  chain: Validate NFTNL_CHAIN_USE, too
  table: Validate NFTNL_TABLE_USE, too
  flowtable: Validate NFTNL_FLOWTABLE_SIZE, too
  obj: Validate NFTNL_OBJ_TYPE, too
  set: Validate NFTNL_SET_ID, too
  table: Validate NFTNL_TABLE_OWNER, too
  obj: Do not call nftnl_obj_set_data() with zero data_len
  obj: synproxy: Use memcpy() to handle potentially unaligned data
  utils: Fix for wrong variable use in nftnl_assert_validate()
  obj: Return value on setters
  obj: Repurpose struct obj_ops::max_attr field
  obj: Call obj_ops::set with legal attributes only
  obj: Introduce struct obj_ops::attr_policy
  obj: Enforce attr_policy compliance in nftnl_obj_set_data()
  utils: Introduce and use nftnl_set_str_attr()
  obj: Respect data_len when setting attributes
  expr: Respect data_len when setting attributes

corubba (1):
  object: getters take const struct

--fURed8NtU5OwByFY--
