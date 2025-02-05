Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BD222A4E8;
	Wed,  5 Feb 2025 09:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738748233; cv=none; b=F6y5rQ21CJxBnbQ9XhP+MTh3j3IXgJ9KpowhmcOUueyG15PFwZjzaelJTV2Hh7NFD3GsZBLec5EldHoSGTq01GBsXDHyfnRdvBF6qMTLRLxCJnWsY+JmLbrk6Ecvt6+i6M4zxvxGCMSmzxNj35LpY+OK6Rnk8i2UDH9s63KdEko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738748233; c=relaxed/simple;
	bh=Lg1j6RbsiZx0WEcUvereTbE7lg7iw5fnvk+9en3k8D8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=khY8aStfr+nJpCs7Krw56rTUH+LlGynwsi8rgJBzd55VfBwuSrPTsvJXIGjn1/eP7wuP3EbXfBe6tgcmlq+b+r27gWetcfUZZjcRBfmzJfPgWgofD2mijR1DfwJajOd5wSiqGsQ36pR9G4WegcMV/6dJDfXy/C6+eRLkiSKgQJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Ynw7B1zcmz6M4KQ;
	Wed,  5 Feb 2025 17:34:46 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id AEFA814034E;
	Wed,  5 Feb 2025 17:37:01 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 5 Feb 2025 12:37:01 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 0/3] Fix non-TCP sockets restriction
Date: Wed, 5 Feb 2025 17:36:48 +0800
Message-ID: <20250205093651.1424339-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Hello!

This patch fixes incorrect restriction of non-TCP bind/connect actions.
There is two commits that extend TCP tests with MPTCP test suits and
IPPROTO_TCP test suits.

Closes: https://github.com/landlock-lsm/linux/issues/40

General changes after v2
========================
 * Rebases on current linux-mic/next
 * Extracts non-TCP restriction fix into separate patchset

Previous versions
=================
v2: https://lore.kernel.org/all/20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com/
v1: https://lore.kernel.org/all/20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com/

Mikhail Ivanov (3):
  landlock: Fix non-TCP sockets restriction
  selftests/landlock: Test TCP accesses with protocol=IPPROTO_TCP
  selftests/landlock: Test that MPTCP actions are not restricted

 security/landlock/net.c                     |   3 +-
 tools/testing/selftests/landlock/common.h   |   1 +
 tools/testing/selftests/landlock/config     |   2 +
 tools/testing/selftests/landlock/net_test.c | 124 +++++++++++++++++---
 4 files changed, 114 insertions(+), 16 deletions(-)


base-commit: 24a8e44deae4b549b0fe5fbb271fe8d169f0933f
-- 
2.34.1

