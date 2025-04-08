Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214911A8F68
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122131; cv=none; b=DkqvxNF+FwDMau9ENoNlYfqqWKRqewNUC/ycS27T0ZFUB+F3knQSLFeX7SzK2OCAEvbqDMAozU3WusHRftuJ5U3AEi3cUdtP2BB+59GaSRGZzYpWkG3MEnj5T/a1Taz+sJH8viQKjGNMy/kweAqnuFAbfWHGlaKP/ffPDVBiFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122131; c=relaxed/simple;
	bh=TzmMWBuU1sJ7MdT7w0Ga9tB5S7KGzMT/pHtzE+tTyfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=csTSiau7J5gI6kPwKh/SS673mgisnPcgXdnqdjqSmTAT8tEg0GGaesbb2pgvlgW1k1NiVZp449IkfgGCrfB5wIUDXHSNtpOdJKkql1BY3/a3vFaIbS+Of9TFPIDWCBWxusw2PAtvm0o7rmfvlHZ7YsM+J/Y0YkCrI2nyk9qjPqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u29q3-0002xV-Gm; Tue, 08 Apr 2025 16:22:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 0/4] src: print count variable in normal set listings
Date: Tue,  8 Apr 2025 16:21:28 +0200
Message-ID: <20250408142135.23000-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print the number of allocated set elements if the set provided
an upper size limit and there is at least one element.

Example:

table ip t {
   set s {
       type ipv4_addr
       size 65535      # count 1
       flags dynamic
       counter
       elements = { 1.1.1.1 counter packets 1 bytes 11 }
   }
   ...

First patch prepares python tests to skip the new debug
information coming with updated libnftnl.
This is needed to avoid a (large) update of all the
existing / recorded dumpinfo.

Second patch dumps set debug info with --debug=netlink flag,
i.e.:
nft --debug=netlink list ruleset
family 2 s t 0 backend nft_set_rhash_type
family 2 __set0 t 3 size 3 backend nft_set_hash_fast_type count 3
(actual ruleset omitted)

Third patch includes the new 'size <value> # count <value>'
output.

Last patch fixes shell tests:
Dumps are updated with the new format (not too many changes,
the change is only needed for sets that have both 'size' set
and are not empty at the end of the test).

For old kernels (missing COUNT attribute), the dumps will be
postprocessed after failure to strip '# count', then re-diff
happens.

Florian Westphal (4):
  tests/py: prepare for set debug change
  debug: include kernel set information on cache fill
  src: print count variable in normal set listings
  tests: shell: add feature check for count output change

 include/rule.h                                |  2 ++
 src/mnl.c                                     | 15 +++++++--
 src/netlink.c                                 |  6 ++++
 src/rule.c                                    |  9 +++--
 tests/py/nft-test.py                          | 15 ++++++---
 tests/shell/features/setcount.sh              | 13 ++++++++
 tests/shell/helpers/test-wrapper.sh           | 33 +++++++++++++++----
 .../testcases/rule_management/0011reset_0     | 30 ++++++++++-------
 .../rule_management/dumps/0011reset_0.nft     |  2 +-
 .../sets/dumps/0016element_leak_0.nft         |  2 +-
 .../sets/dumps/0017add_after_flush_0.nft      |  2 +-
 .../sets/dumps/0018set_check_size_1.nft       |  2 +-
 .../sets/dumps/0019set_check_size_0.nft       |  2 +-
 .../sets/dumps/0045concat_ipv4_service.nft    |  2 +-
 .../sets/dumps/0057set_create_fails_0.nft     |  2 +-
 .../sets/dumps/0060set_multistmt_1.nft        |  2 +-
 16 files changed, 102 insertions(+), 37 deletions(-)
 create mode 100755 tests/shell/features/setcount.sh

-- 
2.49.0

