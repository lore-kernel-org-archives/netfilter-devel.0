Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAF313D245;
	Thu,  3 Oct 2024 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727966427; cv=none; b=m/r92+KAHf/BGOSku+KMCSdTxfCTwyuoo1nG0GIWakOHmlpwWTBy8PlfYGOR/766wUUxwsouAD9MLS2bxMQqfLoXbfDxrkms8i8+N3KgYxv4DwOOG27j+cLVDATNfz4ZD5JSCLHz93OInMTAooagembF29Zl6K72v4W6LrJAR2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727966427; c=relaxed/simple;
	bh=Ag9CE0Os/fSUy/WEvYzwyNkYAqAJSuHL6ie5DqfPOhs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i6L2KBLeorcv/ihGs9MsswfWvVS68xDeFLO7sY9JIrRkZ6snCmQgVGoZxnElWiGoUV9oLNsQVcc259JF94vngbncLNSd9AS/0dGicttucDerxhGsn2SoM0A6D1GTeju0Z7P4lCBuRuFZkHP4SQN0r9fPe7GrDs+ILW/+khShBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XKDn04n8fzpWGd;
	Thu,  3 Oct 2024 22:38:12 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A1F61800D5;
	Thu,  3 Oct 2024 22:40:13 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Oct 2024 22:40:11 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 0/2] Fix non-TCP sockets restriction
Date: Thu, 3 Oct 2024 22:39:30 +0800
Message-ID: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100004.china.huawei.com (7.188.51.133) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Hello!
This patch fixes incorrect restriction of non-TCP bind/connect actions.
Added tests cover all protocols which were incorrectly restricted. But I'm
not sure this coverage is necessary (considering a little complication of
network selftests), probably checking a single protocol (e.g. MPTCP) will
be enough. WDYT?

Closes: https://github.com/landlock-lsm/linux/issues/40

Mikhail Ivanov (2):
  landlock: Fix non-TCP sockets restriction
  selftests/landlock: Test non-TCP INET connection-based protocols

 security/landlock/net.c                     |   2 +-
 tools/testing/selftests/landlock/common.h   |   1 +
 tools/testing/selftests/landlock/config     |   5 +
 tools/testing/selftests/landlock/net_test.c | 212 ++++++++++++++++++--
 4 files changed, 199 insertions(+), 21 deletions(-)


base-commit: af3319b445a28d51bf936cf4fe350f9c8eda5a3a
-- 
2.34.1

