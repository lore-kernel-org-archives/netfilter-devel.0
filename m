Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A713210E6
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868357; cv=none; b=PZ9tBrWgnW5/KtYl9wUGFGCIK7DK7rL6EDXQrltQRj7H1CTHvPqd0UN5aQ1vwam+6UuO0uNOzkOlmdKjrwDduO49jbeiei20GkC65lp1L4VAqvkzs71whWyyR1gxNfYUY7P48tyO8d74x+DCXjCYijPnybM0JgHxm4mKixK1R0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868357; c=relaxed/simple;
	bh=0ZDhdv0NfCiL9qYrX6gY0QftdqRKpEZozaLPZqnFkY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbTOoW3mz8g3twQi1/fke04L2szwLp5kTmQieg4qK6QUaV2yqyqvEwGM3TFYGbY484wdXnUuaP33iIEMJKlps4eeUczBm2RUMkHXkQ2BC6qJXMCuOQZKbPgKSrcu4BCDh2N7EdUi7d+jhYnjT320LV0zx6BTA3uPqOtr1AJVw8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BZYvIjC8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BZYvIjC8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nuh2W8iWi0GebTWGb1kc53n7wjGnslXAIFAaskF2gIU=; b=BZYvIjC8Kjs68hFlsCJv5aacDh
	Fy3jzTbqyqiYVwZFZZ0gq+Gb3L54f1AE7pvGcB0nKsLhFPurruqLSathOUiQSmjfMi22vc4lyYNby
	qFuRecXmmbPxMq9oTqLCIFtjKpDYWmIuR5aNWZSU5A+muOjZukrx3pCiw9AAB5ShmwK1P/Scs6/DR
	PIdIN410P/Vq1YS2I6WvrwIJH+HASlM2hwj2aD7SyvR6WQsn+w87XnhEep+Tt5c5kBUyhrzV0MYis
	aEjFzSKx695Y8vM84Nstv9MdlP4kw6VbL913MG/Yor8ewn2JgIqirwZw6jpDqocc7U+mWqzWSnApi
	5AvfPJvw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0s-000000007gO-3Cg4;
	Tue, 19 Mar 2024 18:12:34 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 09/17] utils: Fix for wrong variable use in nftnl_assert_validate()
Date: Tue, 19 Mar 2024 18:12:16 +0100
Message-ID: <20240319171224.18064-10-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This worked by accident as all callers passed a local variable 'attr' as
parameter '_attr'.

Fixes: 7756d31990cd4 ("src: add assertion infrastructure to validate attribute types")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index ff76f77ebb351..eed61277595e2 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -37,9 +37,9 @@ void __nftnl_assert_fail(uint16_t attr, const char *filename, int line);
 #define nftnl_assert_validate(data, _validate_array, _attr, _data_len)		\
 ({										\
 	if (!data)								\
-		__nftnl_assert_fail(attr, __FILE__, __LINE__);			\
+		__nftnl_assert_fail(_attr, __FILE__, __LINE__);			\
 	if (_validate_array[_attr])						\
-		nftnl_assert(data, attr, _validate_array[_attr] == _data_len);	\
+		nftnl_assert(data, _attr, _validate_array[_attr] == _data_len);	\
 })
 
 void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
@@ -79,4 +79,7 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 			  	     uint32_t cmd, uint32_t type,
 				     uint32_t flags));
 
+int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
+		       uint16_t attr, const void *data, uint32_t data_len);
+
 #endif
-- 
2.43.0

