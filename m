Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416517;
	b=zZPVJOXbIKR6o1i+HONk1t86/AYMLKRu15V4RBjdzP8SB5jFlx1DgP3OTmadn9hEjt7r
	 zdpCr4+o7pIktv9iw7wgjVkaSZRTv8TFcf/+e03GGViPiw2e0/biS8ToruC+7FIDkeJag
	 RUqhBFJqmnjWDcx/11XR8IQVnLiSNzFYrlfl6Bn1RyXeGOtN0cA7xm7MKrZe7uSnWvTw3
	 ldJfwK3iFAdikO/jmP6LflOUD1VirZNRbC+JUlWWPZhvVyFcJ6ihKzbwa+MvC1KWW9KYY
	 Lxzlk7ZVeZ8ke4hAzsvxrc0zfvpwzrNVjLgYRTPd+1LUHktmRokN6BO/MR7fhUEf0HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416517;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/Er+9VZttcGvFY1zEgh6l6eFabyevuO1vR3rmADyYRA=;
	b=cUBOINN3Jj05IaeLWVFsiZekcp6whDwQXRo645Eg1k6Ace77JTImr6G8KWrLZOwPFDVD
	 ysO/fsUe310WBAa3UGxmwIkjJhrk5QwH0GB/1NFaFBUN1CXBdT+Q/Ki+aiAJuRdnTTbVy
	 KrlUW78vJJ/rCTrmBE9n8zkRt6kj7DdT6za0jMVQ3p6Lcdsz02S0xe11Twmzbm/nzPVCK
	 wG0wCuYjxAES3SGuZjd49lyIAqAXnB0CzKY9PP7IboXEIMTUiGQ58NwHhK+fDJwf7QZqG
	 dekq/2zvHm4rMWD8ELi40bNtegSAE9c1eMphF8ybwExcpbkkh1U9MLW4ZRm6PRAdYcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=Gb4wCAwB;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073C8606A324
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 17:01:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 073C8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=Gb4wCAwB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/Er+9VZttcGvFY1zEgh6l6eFabyevuO1vR3rmADyYRA=; b=Gb4wCAwBXPoPxel0PIr/QoLW+5
	dvwBFhN1Yal/mVfemVBIDGx9YyxUW9aq3JEFbGzCMygIkXOYw6I4T5vVTbGCxEtbT+L9FkVUvmuL4
	wF4/tpOblj6p+4YeFLw1i/em5qtydPLPYgaegh+0zQDCU9TTRp76TAuvROJkg57ifYvbod7zrW8Qs
	g6RNDQICzMMpYx24LSFdOt5GxvXriXKW/VkoRwx24n2DBnxJYQjsRTyuMghuer007E5URrIztRHNv
	AlkelHoQluqrVm2Dc2uhTanzgyq6HIer6QhXOym+oPKZ6/JmUv1c2boAMPY02q4YMTtRhECL3JPyv
	qoGy0bow==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xRBhp-000000006yh-2fnh;
	Wed, 11 Nov 2026 18:01:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/3] bison: Drop pointless NULL-check
Date: Wed, 11 Nov 2026 18:01:47 +0100
Message-ID: <20261111170147.47501-4-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111170147.47501-1-phil@nwl.cc>
References: <20261111170147.47501-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The value returned by basehook_device_name is never NULL since scanner
always sets yyval to an allocated pointer before returning STRING
token.

Fixes: b98fee20bfe23 ("mnl: revisit hook listing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 83c0f32322a93..bf2a136796619 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1815,10 +1815,8 @@ basehook_spec		:	ruleset_spec
 			}
 			|	ruleset_spec    basehook_device_name
 			{
-				if ($2) {
-					$1.obj.name = $2;
-					$1.obj.location = @2;
-				}
+				$1.obj.name = $2;
+				$1.obj.location = @2;
 				$$ = $1;
 			}
 			;
-- 
2.54.0

