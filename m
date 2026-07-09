Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0075449981
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783627450; cv=none; b=e6Bz7nl//ajhg7bjB1xi8AraNHaVo+JFnQbqNvZPvmxIF9T/o9bHi5xY+KxA09oxhnNb10xAce2R6VCoocXt+j9Eaidl3OfzZjC4lH/R5iu80GmZAk6Ae/991tal7YimykA+LLiE1dNY/4DARNwBBj0CyD+TfG94EpkIWUE96yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783627450; c=relaxed/simple;
	bh=5HKjGEuE8dtpLjVIAemkaVLhEcnvBZ0GB2zBNawWwVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rcq1IDFxYyCO7QKyMl3GwkKkZ6OgF3u1zw/CAe2CBqhY461tYpBe1n7TOsMwueFnd4RrLxiAzpXuLCnuG1AlviaLj3PUCA/Z+x1qgOwakhJ+37FLJSp4dSpGjcompmF90JQW6sFZPfPM4A+EUBy3Do7qsjixW8g1q3vMbpsLwBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B207A602A9; Thu, 09 Jul 2026 22:04:05 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 0/7] test updates
Date: Thu,  9 Jul 2026 22:03:51 +0200
Message-ID: <20260709200358.15504-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jozsef,

This contains various enhancments for the ipsets tests/runtest.sh.

The largest enhancement is the removal of the sendip dependency,
in the last patch -- this adds a sendip emulation via scapy.
Note that 'sendip' will be used if present and the bundled scapy
sendip.py otherwise.

Main motivation was to make runtest.sh work with my CI pipeline.
This uses nipa (https://github.com/linux-netdev/nipa.git).
Test scripts spawn kernels via virtme-ng.

1) resolve the above. Add a temporary directory, export IPSET_TMPDIR
to all scripts and use that in the tests to write files there instead
of cwd.

2) make test setup simpler: re-exec runtest.sh in a new namespace if
IPSET_UNSHARED is unset (the default).  A dummy eth0 device for tests
is added in the new namespace.  This makes ./runtest.sh self-contained,
no extra work needed.  Also avoids clashes with the test network
addresses used by test scripts.

3) diff.sh: preserve file names in diff output: use the new temporary
directory to store the postprocessed dump files before compare.
This isn't needed but it helps to spot the cause of failures more
easily, as the failing dump name is preserved in the diff output.

4) check_klog.sh: Enable direct fallback to dmesg without error messages.
Not needed either, but it un-clutters stderr in my environment.

5) Use the local ipset binary instead of host binary.
Allow fallback to plain "unshare -n" if user namespaces are not
supported. Parallelize the test and increase iteration count to 124.
'unshare -Unr' doesn't work in my setup but 'unshare -n' does and it
should be good enough.  Note the script will still unse unshare -Unr
by default, it only falls back once the first try fails.

6) Make setlist_resize.sh more verbose on error:
Capture command output to a temporary file, then dump log on failure.
This also fixes a spurious error, the script uses 'set -e' and
occasionally the first 'rmmod' try fails here which made the script
exit too early.

7) Add scapy-based sendip emulation to runtest.sh.  Fall bacl
to a scapy-based alternative if sendip isn't found in PATH.

Florian Westphal (7):
  tests: make runtest.sh work with readonly-cwd
  tests: runtest.sh: run inside namespace
  tests: diff.sh: preserve file name
  tests: check_klog.sh: unclutter stderr
  tests: setlist_ns.sh: use local ipset binary and don't rely on userns
  tests: make setlist_resize.sh more verbose on error
  tests: runtest.sh: add sendip emulation via scapy

 README                      |  13 +--
 tests/big_sort.sh           |   8 +-
 tests/bitmap:ip.t           |  30 +++----
 tests/check_klog.sh         |  11 ++-
 tests/check_sendip_packets  |   2 +-
 tests/comment.t             |  32 ++++----
 tests/diff.sh               |  13 ++-
 tests/hash:ip,mark.t        |   8 +-
 tests/hash:ip,port,ip.t     |   8 +-
 tests/hash:ip,port,net.t    |   4 +-
 tests/hash:ip,port.t        |  32 ++++----
 tests/hash:ip.t             |  30 +++----
 tests/hash:ip6,mark.t       |   8 +-
 tests/hash:ip6,port,ip6.t   |   8 +-
 tests/hash:ip6,port,net6.t  |   4 +-
 tests/hash:ip6,port.t       |   8 +-
 tests/hash:ip6.t            |  32 ++++----
 tests/hash:mac.t            |  16 ++--
 tests/hash:net,iface.t      |  12 +--
 tests/hash:net,net.t        |  32 ++++----
 tests/hash:net,port,net.t   |   4 +-
 tests/hash:net,port.t       |   8 +-
 tests/hash:net.t            |  16 ++--
 tests/hash:net6,net6.t      |   8 +-
 tests/hash:net6,port,net6.t |   4 +-
 tests/hash:net6,port.t      |  16 ++--
 tests/hash:net6.t           |   8 +-
 tests/ignore.sh             |   2 +-
 tests/iphash.t              |  20 ++---
 tests/ipmap.t               |  28 +++----
 tests/ipmarkhash.t          |   8 +-
 tests/ipporthash.t          |   8 +-
 tests/ipportiphash.t        |   8 +-
 tests/ipportnethash.t       |   8 +-
 tests/iptables.sh           |   8 +-
 tests/iptree.t              |   4 +-
 tests/iptreemap.t           |   4 +-
 tests/macipmap.t            |  16 ++--
 tests/match_target.t        |   2 +-
 tests/nethash.t             |   4 +-
 tests/portmap.t             |  16 ++--
 tests/restore.t             |   2 +-
 tests/runtest.sh            |  52 +++++++++++-
 tests/sendip.py             | 154 ++++++++++++++++++++++++++++++++++++
 tests/sendip.sh             |   8 +-
 tests/setlist.t             |  28 +++----
 tests/setlist_ns.sh         |  29 ++++++-
 tests/setlist_resize.sh     |  34 ++++++--
 tests/sort.sh               |   6 +-
 49 files changed, 541 insertions(+), 283 deletions(-)
 create mode 100755 tests/sendip.py

-- 
2.54.0
