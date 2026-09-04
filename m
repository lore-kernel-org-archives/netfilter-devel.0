Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF3A4FDE42;
	Fri,  4 Sep 2026 16:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538406; cv=none; b=mRmO1+J5K5Be+FS5vCW96wDgx0WNAY79PqZCb/5UI6rbU59KGXGR/thCcPU2tWKz3GlEJ+Ss8LIYuMx89Uti+TT0BRI+UmK6ocfyZ3qZATCwt0nNMF0lLOvkhD681LUxoJTn+h4nQtTaI/khBQjX5cLLneIO06TA1Yl2JMCtK7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538406; c=relaxed/simple;
	bh=dzju0TRS8yOv+Ti9MIMOxB1AobIxGglQ1e4DTYB2hrc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F3B38DR79qUezvBIpXXi1I+Lhwc+BCt7mLYTRzaK8em1A8gVD1Dr8bz+kk1nMqr58fsIRB5lIPz41XBuAWE6a0hTrQDV+7A65J//wGHSYG1WfEENUuB5towdZGMc4z0UPT4Nh5Y3idVaSAV3gk8bAtegZdQ3rxA8LmBc8zUIF1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AgNP91nM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgNP91nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6C31F00A3D;
	Fri,  4 Sep 2026 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538403;
	bh=pm/aLNMZvwldSI6W1O18kovgzqqfKKbWsctXnaREAwE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AgNP91nM/ecghVz2CnCw2PWO62UD83tLfUXwdZmd9Zf8D+2oKOGf875y3VF4jCogQ
	 AiZTQx8YXK4yoLnJ4LnWpNQHRLWavOlHLh7Ttpx29uZKTYpJqd+UkzSubTQCbLozRf
	 usTsiZ9MdWK34u3bD1wD6txWp7vUJq88SKuHrTYrkv1MhFwQCP6ZB5BwWJCDA0PybH
	 YSqir3BdCDcDLF/na3oDSljWV5aEQJ1Og8D53wfb1F/Cu3Db0wIUtEDVPP+6ZhmiBV
	 jxs+6rTGhtxVd4e+mLqoLViSeY2QTEWXWf0LckliwctXYlwPncZvqgyDrdc+V7U3YR
	 pPM89WSYrIx+A==
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Date: Fri, 04 Sep 2026 18:13:03 +0200
Subject: [PATCH net 2/2] selftests: forwarding: use KHDR_INCLUDES in CFLAGS
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-net-sft-nf-khdr_includes-v1-2-92455af428e9@kernel.org>
References: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
In-Reply-To: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>
Cc: Ilya Maximets <i.maximets@ovn.org>, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1268; i=matttbe@kernel.org;
 h=from:subject:message-id; bh=dzju0TRS8yOv+Ti9MIMOxB1AobIxGglQ1e4DTYB2hrc=;
 b=owGbwMvMwCVWo/Th0Gd3rumMp9WSGLJmvZP0kuw/Osfk39day+ezL5XNc5kStEWh+8aOR2JaC
 wOTv5561lHKwiDGxSArpsgi3RaZP/N5FW+Jl58FzBxWJpAhDFycAjCRUE6G/2G6wUkT79qyv1vM
 EJTSm+frm3/ML090m17VE/s9nVvDNzL8T591KfjQmdertgRl5Icen7+4LkroHOPmNVZy35Y0Tzr
 zhhsA
X-Developer-Key: i=matttbe@kernel.org; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073

KHDR_INCLUDES is typically used to include headers from the kernel
source directory instead of only relying on the ones from the host: they
can be missing or outdated.

The kselftest doc recommends assigning KHDR_INCLUDES to CFLAGS in a
target Makefile. lib.mk will set KHDR_INCLUDES to "-isystem
$(top_srcdir)/usr/include" if the user didn't set it, e.g. if the kernel
was built in a different build directory.

Other net targets have KHDR_INCLUDES added to their CFLAGS.

Fixes: 05068eaa67b2 ("selftest: net: Add basic functionality tests for ipmr.")
Link: https://docs.kernel.org/dev-tools/kselftest.html#contributing-new-tests-details
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
---
 tools/testing/selftests/net/forwarding/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index bbaf4d937dd8..1bdfd141c0fb 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0+ OR MIT
 
+CFLAGS += $(KHDR_INCLUDES)
+
 TEST_PROGS := \
 	bridge_activity_notify.sh \
 	bridge_fdb_learning_limit.sh \

-- 
2.55.0

