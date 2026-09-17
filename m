Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD84379C26
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 02:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789611447; cv=none; b=CRD8CmvFfycnbbUF3rqcUMv6osnyZIH7BgFvuKibMeMX3NDsBsXw7muNKOQv9mWEYHBtXlVaa64B+uMbpDDugQIvGghnx5rV/aOJc4Uwz6HHSZPAF4t674s8o1WhzJcJ/FKZ20cW7fQ/MTuH5wwATvmnIw33bRq3y+UF+dEWgHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789611447; c=relaxed/simple;
	bh=6ZKkVFe30ui4+BMavPMekwCbHs+/Mni0LzTbLyfg8Zg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=BO1HZLXMZnTB/xclruX9kbiPorskSpKrhD/HAJwBR3C2QyfAGFWcxr9O+9rrvSLDSXrhngAfmgL1fJZZ/T1ToM4s7E3hMMQ3sLnkAOA6AiM4NP3MDCcoC0TmXEE0NkkCmEaH87+jv/NYY8ksQPNH02uEpRmlR/6npncuOM+M1g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SH/T9r2C; arc=none smtp.client-ip=91.218.175.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SH/T9r2C"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6ZKkVFe30ui4+BMavPMekwCbHs+/Mni0LzTbLyfg8Zg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789611443; v=1; x=1790216243;
 b=SH/T9r2CxIow3ov2kN79+LbKILtiqFRpSuWnKadHcVqQ+45wpm3b6pVZP9mlVOxE1G02TS2s
 8OCDj9gxTjmyuwzegZEFwOs7GHhAJ7cXHuQsnDmPPrdkMZadvfW2LxmSvsdBbakznlYfbNMlk24
 05d8PInjJlaW53waTDdslLQs=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a56a1f4abc55b453;
	Thu, 17 Sep 2026 02:17:23 +0000
X-Mizu-Trace-ID: a56a1f4abc55b453
X-Migadu-Flow: FLOW_OUT
From: Hangbin Liu <hangbin.liu@linux.dev>
Date: Thu, 17 Sep 2026 10:17:01 +0800
Subject: [PATCH net] selftests: net: update netfilter netlink config
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260917-selftest_config-v1-1-bf25ccbfb18e@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MTQqAIBBA4avIrBNqiP6uEhGpYw2EhSMRRHdPW
 n6L9x4QikwCg3og0sXCR8ioCgV2W8JKml02YIlN2VetFtp9IkmzPYLnVWPXGOfq2iAayNUZyfP
 9H0cIlGB63w8i6rrnZgAAAA==
X-Change-ID: 20260917-selftest_config-286bdd44b22b
To: Matthieu Baerts <matttbe@kernel.org>, 
 Mat Martineau <martineau@kernel.org>, Geliang Tang <geliang@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Hangbin Liu <hangbin.liu@linux.dev>, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 mptcp@lists.linux.dev, Hangbin Liu <liuhangbin@kylinos.cn>
X-Mailer: b4 0.14.3

From: Hangbin Liu <liuhangbin@kylinos.cn>

Since commit d4349ba9872d ("netfilter: allow nfnetlink built-in only"),
NETFILTER_NETLINK was changed to a bool. Use 'y' instead of 'm'.
Otherwise the build emits:

  .config:5688:warning: symbol value 'm' invalid for NETFILTER_NETLINK

Fixes: d4349ba9872d ("netfilter: allow nfnetlink built-in only")
Signed-off-by: Hangbin Liu <liuhangbin@kylinos.cn>
---
This is a simple update addressing the same issue, so I’d like to post it
directly to netdev instead of bothering two separate subsystems
(mptcp and netfilter).
---
 tools/testing/selftests/net/mptcp/config     | 2 +-
 tools/testing/selftests/net/netfilter/config | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
index 59051ee2a986..bb9c4c97c620 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -18,7 +18,7 @@ CONFIG_NET_CLS_ACT=y
 CONFIG_NET_CLS_FW=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
-CONFIG_NETFILTER_NETLINK=m
+CONFIG_NETFILTER_NETLINK=y
 CONFIG_NETFILTER_XTABLES=m
 CONFIG_NETFILTER_XTABLES_LEGACY=y
 CONFIG_NETFILTER_XT_MATCH_BPF=m
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index c3c121b6f300..629b2b29ed1a 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -44,7 +44,7 @@ CONFIG_NET_CLS_U32=m
 CONFIG_NETDEVSIM=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
-CONFIG_NETFILTER_NETLINK=m
+CONFIG_NETFILTER_NETLINK=y
 CONFIG_NETFILTER_NETLINK_QUEUE=m
 CONFIG_NETFILTER_SYNPROXY=m
 CONFIG_NETFILTER_XTABLES=m

---
base-commit: 1dd85662fee6e2ac580b1c4f9a0c0a7ae6e31f0e
change-id: 20260917-selftest_config-286bdd44b22b

Best regards,
-- 
Hangbin Liu <liuhangbin@kylinos.cn>

