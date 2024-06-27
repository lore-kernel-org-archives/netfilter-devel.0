Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BDD73467
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 08:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719476309; cv=none; b=Jy6kcl16Qm/vOtSQh+xmFgzz2JAMoEZchOuqJLPnRDSGMxUn1fnKPRHg5aBLbi2Lpjb4N2en4uO+BUMihvNa3qQTOKplWDLQ8JrViiDitLGjqE3J1/k+rKWlNV1z6RGId5bfjwah4G2bP008qf51mLS53xJt3TzcPIzXrmgXE5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719476309; c=relaxed/simple;
	bh=AvP4Cg3U9YuTlDnE27Sc640xLifAKeM6mNZ6nX5nTWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rT/3201CdCHnaGkj36unVPH8Hlk4c2GuBQnY1QJzLqfMkV8QYWhCgKDM4QL/LiXEidkwjSSCgwwU+Z04IXhB5hE00bx/VCftsVSredi/oGjFniN+Oue8tHnoxfoT1wYUvPXwdmDjgrIOO1nXr5uxAzg77IjYLhy7OUuuF9PyDxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iuGGRBK2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iuGGRBK2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jxL6ybm4Zk9eB2hWrD01/rxPpTjUaeFXkJjJ4lpXkNg=; b=iuGGRBK2r26bJfVFe+ce/KhGPe
	KvqK9z1kAg6BFws7XzIyFQvSKjxwnOyxDyxpBtJANr/DNlXhYIS0ui6t8z/arRlJ+/aryl//FXQAz
	wMrm6Tktxhcdl2YOoo85y6HAoele5j5Tm2OQ9JhWQ6NAdqk7ah+lIHqxe4el2Anf75o2naXBjdZta
	sfQVV/FPUxt5O/eSCU+PmulX7yT4Rck/CWvvpx0gyhWjUFk7XqWWvUug4muvEI3I+VgJeBtcdXWug
	QKKFl94j7olso/rJyBCvUlKCtYDemMameXsBhhzZVPdZfpGucJJlUY1kWoiVFRncgjuPcGhnuevly
	tvRLK4sQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sMkKl-0000000080J-2olq;
	Thu, 27 Jun 2024 10:18:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 0/3] Two fixes and fallout
Date: Thu, 27 Jun 2024 10:18:15 +0200
Message-ID: <20240627081818.16544-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two cases of illegal memory access and speed up the testsuite while
waiting for results.

Phil Sutter (3):
  lib: data: Fix for global-buffer-overflow warning by ASAN
  lib: ipset: Avoid 'argv' array overstepping
  tests: Reduce testsuite run-time

 lib/data.c              |  3 +++
 lib/ipset.c             |  4 ++--
 tests/resize.sh         |  4 ++--
 tests/resizec.sh        | 32 +++++++++++++--------------
 tests/resizen.sh        | 49 ++++++++++++++++++++---------------------
 tests/resizet.sh        | 40 ++++++++++++++++-----------------
 tests/setlist_resize.sh |  4 ++--
 7 files changed, 69 insertions(+), 67 deletions(-)

-- 
2.43.0

