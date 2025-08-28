Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB9730CDAD
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 12:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756384420; cv=none; b=YVAflov12fc3cD2LOphDryIB+zfu54CcThvERiIGIYTixL5+68c08JFNTYIGI8qXy+oWpE/cHm3d+X6jipGuPsJsUu/ZbkBbJm+gpGhO2rk5y2SidKChdMjwj7FNIGeD2SR68842LJOwklOT9L/uCsaj86GDntKUU0CXRj9pgwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756384420; c=relaxed/simple;
	bh=SQtCixyOPyciDn+8HzLUqYs79LhjImzPYmiYYGijFzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tiEn4OHAM3S1AoRt17peuJqe8M2zuyr+DfiGlEOBm/DflvaO9pYDegCl1DIeGTd70cBz4OIfp7DKkJs3dEoJKNm4ijgEPh6KOYQSykL6YMRYmZHWErKQ6cAIBCH/Fjw8M8NyRcH+BMoV4w/X7HLBOP9Or3Lxuvt20eJmYPB14zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lVOH0p4Y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lVOH0p4Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5pnrYyctC08Mc8qqkUkN0aIMmEQifD0tOEiNpmMSDW4=; b=lVOH0p4YmxPMEl/fX+k/AeE6q9
	72CzZj99FOrDNj+jTOctrIlZcj9gTfcEzwunPh+FKoWutwH2NBrI8rYgw08TJKjxlKJH9m3Pw63+S
	Nyog39KiS9YwDIazStkPAqdxmBdYCY5ymOmnq/xHi2nfmaOIRHTCAWYriyZDnngQIuoqMhEH7GyTL
	ZgosF3WgDMFRTgt3nANzHD7/3iUXc1M4F+TNPIPHya4V6h73WYBEOpJzK0BVGv2H8buwbzP+0gFBd
	snph6vMbfw7OYhVl8tUD4gShZXCII85/fDHGtje6ansNIgf7v7FRWyngxhixpiwI2ZImes3xXEwrh
	og+GK1+g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urbou-0000000078K-0Y3t;
	Thu, 28 Aug 2025 14:33:36 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Yi Chen <yiche@redhat.com>
Subject: [conntrack-tools PATCH v2] nfct: helper: Extend error message for EBUSY
Date: Thu, 28 Aug 2025 14:33:02 +0200
Message-ID: <20250828123330.30625-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Users may be not aware the user space helpers conflict with kernel space
ones, so add a hint about the possible cause of the EBUSY code returned
by the kernel.

Cc: Yi Chen <yiche@redhat.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- React upon EBUSY instead of EEXIST to cover for recent kernel changes.
---
 src/nfct-extensions/helper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/nfct-extensions/helper.c b/src/nfct-extensions/helper.c
index 894bf269ad2bb..3d32703d13903 100644
--- a/src/nfct-extensions/helper.c
+++ b/src/nfct-extensions/helper.c
@@ -229,6 +229,9 @@ static int nfct_cmd_helper_add(struct mnl_socket *nl, int argc, char *argv[])
 	portid = mnl_socket_get_portid(nl);
 	if (nfct_mnl_talk(nl, nlh, seq, portid, NULL, NULL) < 0) {
 		nfct_perror("netlink error");
+		if (errno == EBUSY)
+			fprintf(stderr,
+				"Maybe unload nf_conntrack_%s.ko first?\n", argv[3]);
 		return -1;
 	}
 
-- 
2.51.0

