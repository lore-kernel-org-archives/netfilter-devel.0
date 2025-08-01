Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A068D86353
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754064677; cv=none; b=lmg5mQE+OB3AqMn+ueNyp1gZkeET61K3K8xMjNZyzyO+W++Q4vR2AoT7PemCLEbn/dnZVL3mt9CUzy8qFA6IMfgP6cCF1kRo6vt4ZtQpK4eUSfaBkS5MKvNqynL9BLma6N6sPcd1jWyxSWddCQxXBVJB/p6TISNROdQvtAf08bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754064677; c=relaxed/simple;
	bh=v+GLxSOLf251WpYmvNzebnuErymBfu+q6T41pZCbmYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtPBhBr84ZERVw2xY1x8nIh7pfveJH7Krbs4AExnmX6bLqw33JJvNkvT5rbs17GK9Z8EuaRGjLURLRuzofW0W8rlAlmA1sNt4RsmxBGKfAjG/vEX/sEYCe5nqyJw+q0WOTH+uWrP4ZQNd7asJ/iX2YipZBqNDmBzM3wx4f+pBL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WW08F61B; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WW08F61B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GBE6/YNTSjEKo5rky7tIW0RVXnYUSgqwqz4AZiuyGBE=; b=WW08F61BJUUOEpz6aHNTWvl1uh
	k1csTXChk1w1jFqBhNHc31XdCCG8GlHcqJhzPfEu0jobzTaB/Hg0fQ2/W3PGgWSuWnF06KX63GoWM
	YMvLICovEzGaJ7LgxILTNcUeNeOJlsfgWidfPVu/SmsKjoWhCu7uuebcK5jyg723BawBv9PNEseAj
	ziYE5tpGwEVbllbZo8VWEosbPe9xZUSHEaOWUnFMkQyPmj1632TbGmaDQZDzQ3r7dWnJE9K+hruOC
	7Zu4U23GZCdSjo+VdIqDQa5uiEXF2iUxBHMIrXNZDqz8CRmFVip62f/hX7egoFg14E9EzQh9aVAh1
	mB1Y/jxg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhsLe-000000005I6-1YhN;
	Fri, 01 Aug 2025 18:11:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/6] tests: py: Set default options based on RUN_FULL_TESTSUITE
Date: Fri,  1 Aug 2025 18:11:02 +0200
Message-ID: <20250801161105.24823-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250801161105.24823-1-phil@nwl.cc>
References: <20250801161105.24823-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Automake is supposed to set this for a full testrun.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 78f3fa9b27df7..52be394c1975a 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1517,6 +1517,13 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     signal.signal(signal.SIGINT, signal_handler)
     signal.signal(signal.SIGTERM, signal_handler)
 
+    try:
+        if os.environ["RUN_FULL_TESTSUITE"] != 0:
+            enable_json_option = True
+            enable_json_schema = True
+    except KeyError:
+        pass
+
     if os.getuid() != 0:
         print("You need to be root to run this, sorry")
         return 77
-- 
2.49.0

