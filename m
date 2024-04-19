Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DBA823AF
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Apr 2024 11:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713527029; cv=none; b=XSvUBgiHWU5q8xqe6G0ZnVMofy0zld75ubY3oyn4qKVStzDQ7s7Asd3HWv6MhZKL4rU7vtmHXzwP6dBUPJtVCXvegY/ZnCoG7XBg0FhjH4FdOzPcsMqADMZXZazJpSopWQq38Tx/E6Fo90lesfb0GhIZCIAZvean9myH2J6LLXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713527029; c=relaxed/simple;
	bh=gpao3DgWjyuKRDRVk32PdTrKvcg/UJkAbQTS7C1xY+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KTvsmSDvN+TSch0cF0p0Kw5AWOPj3BmwtVy3Tz1CU5U+HeyeE23UMJdXL8JTfp5CQUzTvzx9i2S2yjVS9aCWIj65qfoygj/sFWIzQJN5WeUmXgsa1voQXRIFpl6m/YlUl+hSIcw7cjKU0XKyN8wwImfn5/mmIQn2VvdN8Y70Cyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxmee-0006cV-Vm; Fri, 19 Apr 2024 13:43:44 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: documentation: remove reference to non-existent sysctl
Date: Fri, 19 Apr 2024 13:39:31 +0200
Message-ID: <20240419113933.13269-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The referenced sysctl doesn't exist anymore.

Fixes: 4592ee7f525c ("netfilter: conntrack: remove offload_pickup sysctl again")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index c383a394c665..238b66d0e059 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -222,11 +222,11 @@ nf_flowtable_tcp_timeout - INTEGER (seconds)
 
         Control offload timeout for tcp connections.
         TCP connections may be offloaded from nf conntrack to nf flow table.
-        Once aged, the connection is returned to nf conntrack with tcp pickup timeout.
+        Once aged, the connection is returned to nf conntrack.
 
 nf_flowtable_udp_timeout - INTEGER (seconds)
         default 30
 
         Control offload timeout for udp connections.
         UDP connections may be offloaded from nf conntrack to nf flow table.
-        Once aged, the connection is returned to nf conntrack with udp pickup timeout.
+        Once aged, the connection is returned to nf conntrack.
-- 
2.43.2

