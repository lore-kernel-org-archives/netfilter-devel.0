Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="sCfpfZS+"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B3810F
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 08:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ojcdrKre1+cMsd8RNAYxdif4uurn6CHtSrfM0usovGI=; b=sCfpfZS+eei+08RqN3ZNpeWK7X
	7ZXWb3WrJv7SZwFPqv/8En3r7JnbhiEZP1FIIBs1zc7IG9oK7ycOHRoUltu8DOki60z5/PxyJEpOk
	7Kmgs15+KbYeLVklUBnN2UoMwF76YmR0oGvEz3i8wNXwFyYe6v1Bt8Tso2uN1XZDXslib/eNBmbOg
	0hNDIv2dkMTCNrSFK04pZpdkhxu0vXz80rGmBs5NyqDu7ryseQG9S8uQFMqauLUneBNdlKRFVcg15
	1HMzMJQDcmIzUzGdeh6Z50I4QglshLur/WA8MjneRCiHFdgyVOWcbwCh6lCrud27mOWTyWa3oNXkB
	SwunGciA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDoor-0038UN-1c
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 16:44:17 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables v2 0/6] Autoools silent-rules fixes
Date: Thu, 14 Dec 2023 16:43:59 +0000
Message-ID: <20231214164408.1001721-1-jeremy@azazel.net>
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
Patch 6 fixes a problem with the man-page rules.

Changes since v1

  * Patch 6: missing newlines added
  * Patch 7: dropped after feedback from Jan Engelhardt

Jeremy Sowden (6):
  build: format `AM_CPPFLAGS` variables
  build: remove obsolete `AM_LIBTOOL_SILENT` variable
  build: remove unused `AM_VERBOSE_CXX*` variables
  build: use standard automake verbosity variables
  build: add an automake verbosity variable for `ln`
  build: replace `echo -e` with `printf`

 extensions/GNUmakefile.in | 75 +++++++++++++++++++++++----------------
 iptables/Makefile.am      | 15 +++++---
 2 files changed, 56 insertions(+), 34 deletions(-)

-- 
2.43.0

