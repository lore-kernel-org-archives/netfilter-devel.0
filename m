Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="E4ZLkF63"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778AC11D
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oGl/2XaVYLInZjqkdLgOwSlD7g1wLoDsW4K7SWfaEhY=; b=E4ZLkF63O+Ia/VlBwEkTT5xGug
	W/hQTiaWatDaBzrYDgzOipfGOngjj3GWa8XTHkDCMZrRd1vFUmuqQE/TUAAq2Efvwg6Ax8aaIiauO
	ycCMkWE/QMejVERCGeVjLs8Ok2Qgrlk+vwyIe7GqZZNkyCN/WgU+5ZjNCPddshkX65MbMA8da1LQH
	0x/BePGH/MyuM7qXr/OnmaWG6Ho3UiWPdLE8hqfB8jgrjqyjx/T6K3+UX+AKBakZX8dJff/ZvBijF
	+S5El64+St2EKXQAZvcjat4mDTtFbJSzax7tTWHFC80dF5MxNJSUw+3Tl/6Jfj1yxcv8eivP9nIXO
	YIr7HZvA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDlJN-0032wj-1f
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 12:59:33 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables 0/7] Autoools silent-rules fixes
Date: Thu, 14 Dec 2023 12:59:15 +0000
Message-ID: <20231214125927.925993-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

The build system defines variables similar to the ones automake provides
to control the verbosity of the build.  However, the iptables implemen-
tation is only partially effective and was written fifteen years ago.
This patch-set brings the variable definitions in line with the current
automake recommendations and fixes some bugs.

Patch 1 contains some unrelated formatting changes.
Patches 2 & 3 remove some unused variables.
Patch 4 brings the remaining ones in line with automake.
Patch 5 adds a new variable for `ln`.
Patches 6 & 7 fix some problems with the man-page rules.

Jeremy Sowden (7):
  build: format `AM_CPPFLAGS` variables
  build: remove obsolete `AM_LIBTOOL_SILENT` variable
  build: remove unused `AM_VERBOSE_CXX*` variables
  build: use standard automake verbosity variables
  build: add an automake verbosity variable for `ln`
  build: replace `echo -e` with `printf`
  build: suppress man-page listing in silent rules

 extensions/GNUmakefile.in | 79 ++++++++++++++++++++++++---------------
 iptables/Makefile.am      | 15 ++++++--
 2 files changed, 60 insertions(+), 34 deletions(-)

-- 
2.43.0

