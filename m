Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AAE2B9B9
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868352; cv=none; b=kL9FUXuVGT3wzPJQ/fAS53usLW8JKKGCreqKHaRZwQQd9hUlzN7BXsGOW0OlP/wBN0SgyDfnNZcpH2Ja8RANUvQ/9Gzav3EY4rvEQUIktfvkpO/3FSgGImOwYoqaCeMmX/FYSeEJ6JlJPV0z0DwpwZSi8+qt0W+BW2OK1E2JV+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868352; c=relaxed/simple;
	bh=eQdmxNZJS5QBmSb5L+0e8DJFDKa9WdjJAcruRndQgTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihcVHLJzT5/M1WM29oN3od9FeZQ0nqUPrtFVP39hs3wjD3ZMjN456i5TJuvPbWOcgg0mM5/kr6N9mYsreF+yI+GjiFjjlks55WxiTNrHB/36sw4nih9FUwc1DhSJk1ermq4ALfAeZ7Hwfx/780xx77DQKitwPTYmURkME1KE9k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cvIQEnwJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cvIQEnwJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=F2wijYqKAkmyq+HH33ShaVdGCnZK0OCflcWREj/o2z4=; b=cvIQEnwJzfxtDs4Tgim37UOzJK
	02N+M6RBmDIo+z+1HGdUqt9FVP0oP2xtbzHU0d12xZnqMCGv0DZe2eHf2wFVoQa8RAla+5SR0aRBr
	6sBs4BrqIKt4Eufn9yC8RRJIYjcqoleEdfrUo+fD7igHHb9YEkXmw4MMvgXU2J2biCkM69GgkVO1Y
	XuqSiiwDgaA/fLKYZtxZtlAS9iLVoOcfebDIghlu7DlDWvhi/7rlwWWy5PXOZIvGPSTev0F7MQcvk
	jg/LpwnRVESXoukPoXsMwNg97UF4t5oiEjfuPBkrCvOPFoPpsJfqZEP5TGpo3NNumNi1HmI9fA0pL
	pkXwlP7g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0n-000000007fc-1OiB;
	Tue, 19 Mar 2024 18:12:29 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 07/17] obj: Do not call nftnl_obj_set_data() with zero data_len
Date: Tue, 19 Mar 2024 18:12:14 +0100
Message-ID: <20240319171224.18064-8-phil@nwl.cc>
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

Pass 'strlen() + 1' as length parameter when setting string attributes,
just like other string setters do.

Fixes: 5573d0146c1ae ("src: support for stateful objects")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/object.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/object.c b/src/object.c
index d3bfd16df532e..b518a675c2fb0 100644
--- a/src/object.c
+++ b/src/object.c
@@ -185,7 +185,7 @@ void nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val)
 EXPORT_SYMBOL(nftnl_obj_set_str);
 void nftnl_obj_set_str(struct nftnl_obj *obj, uint16_t attr, const char *str)
 {
-	nftnl_obj_set_data(obj, attr, str, 0);
+	nftnl_obj_set_data(obj, attr, str, strlen(str) + 1);
 }
 
 EXPORT_SYMBOL(nftnl_obj_get_data);
-- 
2.43.0

