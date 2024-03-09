Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF84364A8
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984137; cv=none; b=bJUcUAh5BLtR3AJDcz7ButQTQ3QN5iHrZ9SXtr9pG4AUacpUUHOg7IqS0w1+IuRtnDsIHqzIffFDqUzFtDIDF25dAg4u5dqnAK26H+1IAnV08H09IvUVsbv8hhWTzRtyepftxgv0rVRUxnGnPZOTWShobTk8x+O6cnhEc7k7OH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984137; c=relaxed/simple;
	bh=QZaCRS9bVnWk/smub4KfW7SxoSeoMf5BXT4BVCP3Zgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCpIhKudCzSnS2yQb4UPqYgikJ+0zYJFMzDBIZAKHa9Mmv2z0bnDe4+HALncjAl5Edou3we+n2j/2gGHjYHnfPYXtEG/NOZnKcpo4oDafnefUssJ8tc8V5Gv6U4bGJog7brlc+89md1imvfbZ6gOG7b+spxL05GDWEs/OFYbfNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Y24wGmqB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Y24wGmqB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fFcoqbUv2nOCsDixgeUFozx43v71PoUyHfayCgXuh6g=; b=Y24wGmqBIYPZWjvziG7By+4mqd
	gbm1qRsZajd596OaR1re0PsHK0vk9bWtmmt+VWSNK+2z6PyfnQ38S49JWTruqYNVzMy6Uf6WiXXLN
	EiG4QOFqhbf9SzPN3CpsAVlstV14VHSnv1b2HyydULp5NW1KRw94/UrGEZP1BlX7EJ18hGLDsB/cR
	bEVUa+weEbQhXeJf7EZiDN9m4uVjMECmsQNdUWVwPloCGRWnrF/aG++byukYEKpkyJp+hUueNKQlW
	POe3A+daxsGgdzCz+17x+0nnls34m+CwpjhHcjfK/4Z45vbE9Bm+W55BtO6ePKzrh9DOwhcMtRmqv
	RppcTUIQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riuzF-000000003hJ-10bw;
	Sat, 09 Mar 2024 12:35:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 1/7] tests: shell: maps/named_ct_objects: Fix for recent kernel
Date: Sat,  9 Mar 2024 12:35:21 +0100
Message-ID: <20240309113527.8723-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240309113527.8723-1-phil@nwl.cc>
References: <20240309113527.8723-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since kernel commit 8059918a1377 ("netfilter: nft_ct: sanitize layer 3
and 4 protocol number in custom expectations"), ct expectations
specifying an l3proto which does not match the table family are
rejected.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/maps/dumps/named_ct_objects.nft | 4 ++--
 tests/shell/testcases/maps/named_ct_objects           | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.nft b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
index 59f18932b28ad..457a08ebc32ca 100644
--- a/tests/shell/testcases/maps/dumps/named_ct_objects.nft
+++ b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
@@ -4,7 +4,7 @@ table inet t {
 		dport 9876
 		timeout 1m
 		size 12
-		l3proto ip
+		l3proto inet
 	}
 
 	ct expectation exp2 {
@@ -12,7 +12,7 @@ table inet t {
 		dport 9876
 		timeout 3s
 		size 13
-		l3proto ip6
+		l3proto inet
 	}
 
 	ct helper myftp {
diff --git a/tests/shell/testcases/maps/named_ct_objects b/tests/shell/testcases/maps/named_ct_objects
index 61b87c1ab14a9..d0bf95012491c 100755
--- a/tests/shell/testcases/maps/named_ct_objects
+++ b/tests/shell/testcases/maps/named_ct_objects
@@ -9,7 +9,6 @@ table inet t {
 		dport 9876
 		timeout 1m
 		size 12
-		l3proto ip
 	}
 
 	ct expectation exp2 {
@@ -17,7 +16,6 @@ table inet t {
 		dport 9876
 		timeout 3s
 		size 13
-		l3proto ip6
 	}
 
 	ct helper myftp {
-- 
2.43.0

