Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9041F295DBD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236073; cv=none; b=N74A55ZBD7GSDX1RsT9z6Ok6KQFUt/SLSD4S/7/gZqPnBKGNpcMWSV06FjBP68nW2URgTEROywmfXq4miwCNXtDbU0sXNdHA/15SN7zXEhWiJ0xX1s6nUq6Cyaks5uskE+CV8g2WZ6ANXAvAaI8rpqO/aG3LKMysNKPleeCFlOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236073; c=relaxed/simple;
	bh=qbNbDpD1iQYK+1LsgL4BauNp5A7S6yo4hPhwfXC9zMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/HdkjeFlhAR655T25KbgD3PIKJtKFUUejHpq3TfSVxUmSBN2+8BET6aeubDFCGAHXj3wqUGZOzlWdMY2x9h8ponxN+iyrvM3ehwGVaO36IQ48SnLovnXbcgNYBDvtLA3uzxCpLZRyqr9Z83upJUsXWN/nRNJ7j9Py3OkZPyMhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LGw3RW43; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LGw3RW43"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c1/RhZqpms5iQmq3j3l7D0N3FKIWGA6jo8x4ZSPh1FA=; b=LGw3RW43wUZSplQYt2BsfDJD2b
	FtTHhjNM/4j5uQI3psv2bcpODg3IIJ6lgCl0C2kir8I6tsP/OwvtHdW4LKiqb7TgZmOIklTIQnPSp
	4tN8lAcvXh0bM6893gUdoz6nofyFRe1k97lLwdV5NMQlVFsXrgwmresg4+URkyCQw4uQpMQ3deSII
	O7QhfWc+y0AgIwIp6gpoAJ0talzvdX21GqJ9i9qdRgNXJu0jpdi+p5TRf9aOoPX1UXC6tlwAZDSX6
	TkN/HbLaM32ECA75QrySf9DEsdMfT96WSyBsnwsUbUeXSCkJMEPVmPVPE9HmIwt5iXqsatdFF39I8
	LM8WQawg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxN-0000000005T-0IQW;
	Thu, 23 Oct 2025 18:14:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 24/28] tests: py: tools: Add regen_payloads.sh
Date: Thu, 23 Oct 2025 18:14:13 +0200
Message-ID: <20251023161417.13228-25-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use this script to recreate all payload records.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/tools/regen_payloads.sh | 74 ++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100755 tests/py/tools/regen_payloads.sh

diff --git a/tests/py/tools/regen_payloads.sh b/tests/py/tools/regen_payloads.sh
new file mode 100755
index 0000000000000..9fcbc2c0912a5
--- /dev/null
+++ b/tests/py/tools/regen_payloads.sh
@@ -0,0 +1,74 @@
+#!/bin/bash
+
+# update payload records in an automated fashion, trying to reduce diff sizes
+
+
+# scan payloadfile and print record for cmd (if found)
+find_payload() { # (payloadfile, cmd)
+	local found=false
+
+	readarray -t pl <"$1"
+	for l in "${pl[@]}"; do
+		if [[ "$l" == "# "* ]]; then
+			$found && return
+			[[ "$l" == "$2" ]] && found=true
+		fi
+		$found && echo "$l"
+	done
+	$found || echo "Warning: Command '$2' not found in '$1'" >&2
+}
+
+cd $(dirname $0)/../
+
+# make sure no stray output files get in the way
+rm -f */*.got */*.gotgot
+
+# store payload records for later
+# clear payload files to force regenerating (but leave them in place)
+for pl in */*.payload*; do
+	[[ $pl == *.bak ]] && continue # ignore leftover .bak files
+	cp "$pl" "${pl}.bak"
+	echo >"$pl"
+done
+
+# run the testsuite to create .got files
+# pass -f to keep going despite missing payloads
+./nft-test.py -f
+
+# restore old payload records
+for plbak in */*.bak; do
+	mv "$plbak" "${plbak%.bak}"
+done
+
+# sort created got files to match order in old payload records
+for g in ${@:-*/*.payload*.got}; do
+	pl=${g%.got}
+
+	[[ -f $g ]] || continue
+	[[ -f $pl ]] || continue
+
+	readarray -t ploads <"$g"
+	readarray -t cmds <<< $(grep '^# ' $pl)
+	for cmd in "${cmds[@]}"; do
+		found=false
+		for l in "${ploads[@]}"; do
+			if [[ "$l" == "# "* ]]; then
+				$found && break
+				[[ "$l" == "$cmd" ]] && found=true
+			fi
+			$found && [[ "$l" != "" ]] && echo "$l"
+		done
+		if ! $found; then
+			echo "Warning: Command '$cmd' not found in '$g'" >&2
+		else
+			echo ""
+		fi
+	done | head -n -1 >${g}got
+
+	mv "${g}got" "${g}"
+done
+
+# overwrite old payload records with new ones
+for got in */*.payload*.got; do
+	mv "${got}" "${got%.got}"
+done
-- 
2.51.0

