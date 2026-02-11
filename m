Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1E42EA151
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 19:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770838932; cv=none; b=lsnmciSAfoaiBFFL+xmgNoImFd8bVmQWgy53ssyDZFndHGH0XlwHIZSu9FAworZ066s2gQMHSkO3O5vqQUl8KEe0+1xcK40ATyV5Bsz8tLrsxU47Jqli6/ayLk85HNhHcTk8NIPKZz5Bh089RCsgGkMdRyRxN+wr7VIe0S3DW4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770838932; c=relaxed/simple;
	bh=AaOVsMJ9nNyQj/TV7p3bOd7pUUnxVHC5KhOqJXCzv98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kFPRhgy20QVgu2inaha7FpHVwuanZ3bdvkABKFB8/Qq1+khGnUVCaJpwh7V8N0W26Zqmct1AAjzdtF9/LXG8o5w0u9o3WsjqpjZJLaZDnrdxwaJK7pSU/Vny8Rix6umfLgGeoSqNuMd3aUvl5Zl+QKNlb1N8JVCeejDnBkkgKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LQ5YhA5t; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LQ5YhA5t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2kPf047R1Di0aVgyxICoK+C27DTwRvqHzFsVAJskX1o=; b=LQ5YhA5tZPabHAze/ujq/CjhhL
	M9r/jcjmGlR8ZRFJVbu/uMgwtpfoh/0Q0oRNI/J/1pXiCpbnbt3fL/zcYih0x6H4WqWGdoAywidnU
	5tD+nmjWf/9vJpodwsFuRaIba3yKob06CZhy/kb/O3R0bfPpZTMkgx3cjox49/MQX4iayTDOPpckf
	KC/Ndekf64FaL9BTvlMwoV8InDh1s3LofX3/0Ye6GSbbc7p87JHEBuOaPxBfbeeDukJbaT+u9fY1r
	m/8xlqgyvQl/km62DXpBfqAam3Enfv2dU9BPlQpFWk3C85w3rGdmrb8y8y9/tOHzWOXS0gADCVGzh
	9ek+bzEA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqG6D-000000007jP-0SSR;
	Wed, 11 Feb 2026 20:42:09 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Ilia Kashintsev <ilia.kashintsev@gmail.com>
Subject: [ebtables PATCH] useful_functions: Fix for buffer overflow in parse_ip6_mask()
Date: Wed, 11 Feb 2026 20:42:03 +0100
Message-ID: <20260211194203.6383-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ilia wrote:
> I have found several global buffer overflows in
> useful_functions.c
>
> They both occur in the function parse_ip6_mask() and are caused by
> unconditionally writing to p[16].
>
> The first overflow occurs when bits is equal to 128,
> which causes p[bits / 8] = 0xff << (8 - (bits & 7)); to write at p[16].
>
> The second overflow occurs when bits is equal to 8,
> which causes memset(p + (bits / 8) + 1, 0, (128 - bits) / 8); to write
> 15 bytes starting at p + 2, which leads to the same issue.

This patch contains a simplified version of his fix:

- The original code attempted to div_round_up() for the second memset(),
  to zero the fully empty mask bytes. It used the term '(bits / 8) + 1'
  which misbehaves if bits is equal to 8.

- Addressing p at offset 'bits / 8' is illegal if bits has the legal max
  value of 128. Also, zeroing this byte is needed only if bits is not
  divisible by 8.

Reported-by: Ilia Kashintsev <ilia.kashintsev@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 useful_functions.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/useful_functions.c b/useful_functions.c
index 133ae2fd61eae..7378fc9a6e924 100644
--- a/useful_functions.c
+++ b/useful_functions.c
@@ -364,8 +364,9 @@ static struct in6_addr *parse_ip6_mask(char *mask)
 	if (bits != 0) {
 		char *p = (char *)&maskaddr;
 		memset(p, 0xff, bits / 8);
-		memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
-		p[bits / 8] = 0xff << (8 - (bits & 7));
+		memset(p + (bits + 7) / 8, 0, (128 - bits) / 8);
+		if (bits & 7)
+			p[bits / 8] = 0xff << (8 - (bits & 7));
 		return &maskaddr;
 	}
 
-- 
2.51.0

