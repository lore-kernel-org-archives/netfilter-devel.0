Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3BE171BB;
	Sun, 14 Jun 2026 05:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781414706; cv=none; b=oE7h56tA56Ylx+uu+nr+jXJSeXTZqny7rF6xtzvj0wqPdlq6wcpZBypVFEPwMBKtG6xolsLgUkPxpduaR/6Mg9l/5VPxpLISenBW09vgU0Ri3L+6pLAskWqLqA8ElfL8+2kdE+Ih5vLUhXVnS+kCesfr3Y5OlBJXYWZWDzHm1hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781414706; c=relaxed/simple;
	bh=jKNFQoYyYRNM6RN88LE0ftXAaIzYOVu4XaPPMvfQ23w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DXS0Pi/sjm1P7Z4jXWMRoGRK66FRbRPS5SiA+PV5D9pKw6ZUkWTuI0NlV7pCEZl6cmLGtlALv8+J2ZBvE+KmyXSjDGqLtF8ScVXquMW/afkuySIUo8K0Kb7yvzZnDnEwHg6XBFAiDMnsDA3d3qOB0JQ3ixulX434tnDohAJaJjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FAl0yXEr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FAl0yXEr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4+ezzVnmGX883Tcu2dMk/g9oTPSI9CcgmXMGW8cRAkI=; b=FAl0yXErwl8YxSwUca7gGHKoZh
	eAAh10O16P4MQMAPGfCm+gjTj/SU+ioDdlbs1ypa4JXUeAX+cWfQ4VG8DiJMA3rWEJPddarKW+e3l
	cI5F72mKzJqZqpNHK5QnRgKwNUe4/TcuaPFtlHY35pSn/V9Gr8CgjT7096uf5/5LW1edVym+SV3Zk
	Cd+fIB5GKmO1Hc/FdDXLcNg6hWpqBQZ+mCIWwYR38DFqCu4KQU5UyaX7BP3WWiJQA/7E8OYQ6aV5P
	lM0JzOEutocCVbdvvH60SUJr06qb242WTN2zKmN1k2VfV4MyolRHcxeV0KLKU9SCoFGw5lQWMZaLN
	TIJdLh5Q==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wYdL4-0000000ClD2-0NT5;
	Sun, 14 Jun 2026 05:24:54 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-doc@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH] kdoc: xforms_lists: handle DECLARE_PER_CPU() in kernel-doc
Date: Sat, 13 Jun 2026 22:24:52 -0700
Message-ID: <20260614052452.1557987-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for DECLARE_PER_CPU() as a var (variable) as used in
<linux/netfilter/x_tables.h>.

Warning: include/linux/netfilter/x_tables.h:345 function parameter 'seqcount_t' not described in 'DECLARE_PER_CPU'
Warning: include/linux/netfilter/x_tables.h:345 function parameter 'xt_recseq' not described in 'DECLARE_PER_CPU'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: netfilter-devel@vger.kernel.org

 tools/lib/python/kdoc/xforms_lists.py |    1 +
 1 file changed, 1 insertion(+)

--- linext-2026-0610.orig/tools/lib/python/kdoc/xforms_lists.py
+++ linext-2026-0610/tools/lib/python/kdoc/xforms_lists.py
@@ -118,6 +118,7 @@ class CTransforms:
         (CMatch("__guarded_by"), ""),
         (CMatch("__pt_guarded_by"), ""),
         (CMatch("LIST_HEAD"), r"struct list_head \1"),
+        (CMatch("DECLARE_PER_CPU"), r"\1 \2[PER_CPU]; }"),
 
         (KernRe(r"(?://.*)$"), ""),
         (KernRe(r"(?:/\*.*\*/)"), ""),
