Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C81D21256E
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273481; cv=none; b=MrodF1oQkHB/p58uUD7zOvsx05NDKTRuSPj+GCTVosQGRvh3JJGdRfiWRNvkp3qE0okjeYanc39bHcZFRLjpzAtNHNIEW9aiBXKbSWfoVFgZ7RC3EVpPdLm794fF39f+OV24ZODpIOngl/zg0upyuwurbWpN3hIhXn1/bwrYRL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273481; c=relaxed/simple;
	bh=+VgWpkUpdaVFnIecZ2MqRSI1audfVIemTExxbDo4hAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s5o0AUu64K8Zh3HEXv4GLky+lqCRCOhKtwuXIKj6FwCxFU0HG3Ny90QnNVysGFIahJE99tSp7bEeJELYCQ8URAIGqih/eVVZ8qrDJVy5oFHga+13W5s5zwwZITEIn7ZL0XbGDPeaDE5WIMqjqQIez6cb3M46afCwfbhtqfw7PJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qYtAWDB2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qYtAWDB2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SqHTdMdmDVrZtxAefEFxvzxpxdHj/12tzex/HyiSIV4=; b=qYtAWDB2WaLiJgVk/0GV7BaMID
	jXPFC/yzoa/4EBlMY7Uh7UPK3l6XKrofbvAnj+aeNbbXtSrPc41pmjgUAiEApzNCdeBPhS0BgshoU
	nROMEol0TrpTY8cJr6ocooYdN7H2esetKbCIz7rzB24o0FIIc9BtC3ejPUHZVOcwiUdwQI90xby5/
	j6zT+F7m04IEwz0vemYYmMYkVGBMfjwA9nihVaA6V3kLuk0/wVkanSl0cP3935NuE//Q3ndGTYH8j
	MfJYR0ix6JsjcQNnirvOJgbGWqtYd45YmNPsuvPOgW1+e68Q80bgTkEnLLzj7+UVbPeyeTWLIBnUH
	dNx6zSvQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umwoV-000000002wt-487m;
	Fri, 15 Aug 2025 17:57:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Yi Chen <yiche@redhat.com>
Subject: [conntrack-tools PATCH] nfct: helper: Extend error message for EEXIST
Date: Fri, 15 Aug 2025 17:57:50 +0200
Message-ID: <20250815155750.21583-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Users may be not aware the user space helpers conflict with kernel space
ones, so add a hint about the possible cause of the EEXIST code returned
by the kernel.

Cc: Yi Chen <yiche@redhat.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/nfct-extensions/helper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/nfct-extensions/helper.c b/src/nfct-extensions/helper.c
index 894bf269ad2bb..5592dc1340bea 100644
--- a/src/nfct-extensions/helper.c
+++ b/src/nfct-extensions/helper.c
@@ -229,6 +229,9 @@ static int nfct_cmd_helper_add(struct mnl_socket *nl, int argc, char *argv[])
 	portid = mnl_socket_get_portid(nl);
 	if (nfct_mnl_talk(nl, nlh, seq, portid, NULL, NULL) < 0) {
 		nfct_perror("netlink error");
+		if (errno == EEXIST)
+			fprintf(stderr,
+				"Maybe unload nf_conntrack_%s.ko first?\n", argv[3]);
 		return -1;
 	}
 
-- 
2.49.0

