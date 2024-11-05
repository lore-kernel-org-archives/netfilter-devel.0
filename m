Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D21215F50
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 20:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730838952; cv=none; b=rWf6MqNRzfr0Pr4biypFF+D8wUQszcYHmG6p0bMj879QxoKulgePfI4/4LTadjby9UuO/A9pamxzMxmGri0DGh8jLV7IDyHdTU2cVS6vsYGazy3BgyBsJQ/EjW3rzbas6X6o9VCGFyPWfy9YSaP9upP7hztcLjs7oglhFa5z+sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730838952; c=relaxed/simple;
	bh=SmkYLWnMTPOJOyp3c6FvtcvWKSBoD3xoVGHV+Yyq7n8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyQIUhAHpnoGaIS/PlN70f3dxF2pe7LsqUq2/zLqRyEI/F0jTKzeLiNR9m5DVUubLoSLPMtlZW6eClNRmgb0AdfGL8Q5gDW39RnoVBaWZcbC21CnNya3h6aRvBYGqtpuHcZ7Xe7veYYt9HG8/P68vsCJfRAKzuyri32v0vjBsJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dk3jzD4r; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dk3jzD4r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uc2q5pZnLodLKZwZk+tserQmPD5H3rVEQV3n8/R787k=; b=dk3jzD4reMvCmrXPu9Rwlo57Ic
	DLtTYxhAUIjuWwaoAtuUoY+JZtaUSxP4iNCR2pgq/TeFQd8X6QZRtuROf4ipRVGij8yziCLf1mbXw
	7WeiPzyaxA28GpsVvf1sMQ6H122ZmFU4QreeFAONHFfmkwXYWYgt1Q/9zNDFjRQqOQL5BCCAvwwhh
	hnf9g38qgESrtvHEwHuxHfaIMEacsJ18inxfa8jwRMiGexvSHFCSYL13Bxs+3AWxYWoH/d++exhdo
	Fe9k7EHVSGRJ2GMqer/7ktTMNERGI18qGplZKYiRf+fP76Oj2dRvqJIBmvEDeOqxng0UFcO0tF0gs
	n/JYlhZA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8QHE-000000002vs-1cIE
	for netfilter-devel@vger.kernel.org;
	Tue, 05 Nov 2024 21:35:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] tests: shell: Test ebtables-restore deleting among matches
Date: Tue,  5 Nov 2024 21:35:43 +0100
Message-ID: <20241105203543.10545-3-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241105203543.10545-1-phil@nwl.cc>
References: <20241105203543.10545-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rules containing among match would spuriously fail to compare if there
was a previous rule with larger among match payload.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../ebtables/0012-restore-delete-among_0       | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0012-restore-delete-among_0

diff --git a/iptables/tests/shell/testcases/ebtables/0012-restore-delete-among_0 b/iptables/tests/shell/testcases/ebtables/0012-restore-delete-among_0
new file mode 100755
index 0000000000000..165745e169f89
--- /dev/null
+++ b/iptables/tests/shell/testcases/ebtables/0012-restore-delete-among_0
@@ -0,0 +1,18 @@
+#!/bin/bash -e
+
+case "$XT_MULTI" in
+*xtables-nft-multi)
+	;;
+*)
+	echo "skip $XT_MULTI"
+	exit 0
+	;;
+esac
+
+RULESET='*filter
+-A FORWARD --among-dst de:ad:0:be:ee:ff,c0:ff:ee:0:ba:be
+-A FORWARD --among-dst de:ad:0:be:ee:ff'
+
+$XT_MULTI ebtables-restore <<< "$RULESET"
+echo "$RULESET" | sed -e 's/-A/-D/' | $XT_MULTI ebtables-restore --noflush
+
-- 
2.47.0

