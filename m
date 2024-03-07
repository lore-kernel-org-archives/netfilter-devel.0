Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF33128378
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 12:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814762; cv=none; b=Rh5FpH/yma88kweiGnGW6OEoQHLOyyhkmYswj2XRan/pRek0LijUrg5SRfpiP4YVw3lhlRm/IGnr0L9FtPvbNt9ZA6xzh9+TZ0L0KD6KPduUjmxpYkmHJSY8XewGOYvoAJglj/YvvGQpjXmayW7ZAMkFVp0WD3TFL3LWO9tTcCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814762; c=relaxed/simple;
	bh=JxdIMktNf1qIXPU6LVkEgVPFOKUXpisO2ez5sW+PLaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U0XdfKBgNTfNW2V1askEo/hw4INg2D5PAcJltBAXMZLq6WWrVQbvMAh2Y8ehOw9LWO6I0NeZWY7fy97RFbpT0x5/W28+1lv8YbiyQfkKWOSctqGnToEBCT0aatP6Irs3OlTSx5zgHcO6GfmSBhEUVWSFs+SSVbWKG0JK1aJq37Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1riCvO-00072H-VS; Thu, 07 Mar 2024 13:32:38 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: phil@nwl.cc,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/5] parser_json: fix up transaction ordering
Date: Thu,  7 Mar 2024 13:26:30 +0100
Message-ID: <20240307122640.29507-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing parser cannot handle certain inputs.  Example:

  "map": {
   "table": "test",
   [..]
   "map": "verdict",
   "elem": [ [ "*", {
        "jump": {
           "target": "testchain"
[..]
    },
    {
      "chain": {
        "family": "ip",
        "table": "test",
        "name": "testchain",
        ...

This will fail to load because the generated transaction
adds the element containing the jump to 'testchain' before
the 'add chain'.

The normal (bison) parser does not have this issue, elements get
added to the map, the map is added to the table.

Then, *after* parsing, the 'add chain' and 'add element' commands
are generated via command expansion.

Change the json parser to do the same and avoid cmd_alloc where
possible.

Patch 4 is the main change, patch 5 adds test cases that did not
work before.

json parser still cannot handle several existing tests due to lack
of 'typeof' support (dump would contain base types like 'integer' which
are rejected as they lack the needed key length information).

Florian Westphal (5):
  parser_json: move some code around
  parser_json: move list_add into json_parse_cmd
  parser_json: add and use CMD_ERR helpers
  parser_json: defer command allocation to nft_cmd_expand
  tests: shell: add more json-nft dumps

 src/parser_json.c                             | 331 ++++++++---
 .../dumps/0011endless_jump_loop_1.json-nft    |  75 +++
 .../testcases/maps/dumps/0011vmap_0.json-nft  | 145 +++++
 .../dumps/map_catchall_double_free_2.json-nft |  46 ++
 .../maps/dumps/vmap_mark_bitwise_0.json-nft   | 158 +++++
 .../maps/dumps/vmap_timeout.json-nft          | 229 ++++++++
 .../dumps/0008create_verdict_map_0.json-nft   |  78 +++
 .../sets/dumps/sets_with_ifnames.json-nft     | 551 ++++++++++++++++++
 8 files changed, 1516 insertions(+), 97 deletions(-)
 create mode 100644 tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0011vmap_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft

-- 
2.43.0

