Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D508E2DF68
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104831; cv=none; b=h5by3jSt6GYGNpqdCmw9SFWkeWF/jZSwPX6T2cVEQD+xOTk4ydRGkXQZtl/nSNOtVG66CHuxhxveAsESHzHmjUjYOLx+/dPR3mv++0bbTuRXTpcUwnHv3XfT4a6BvSkj0f38GgK7BQYQVGbkJxPvloEBWabht4ccVo7RTEiqKd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104831; c=relaxed/simple;
	bh=8isHp2pywYgi2h4NB4ZP81sB37NGv67faFvMPTwjdjo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ERyqpE0jVj2J3YBYPEjmDm1W6qLR9gUqTCbh4VYViAKMOetRhzogmEwhUfHNE5V5PhCDswRFkAnTJz/ARRzF1+KXHSx9FeYq9EVs93TfyMoKUAuo4DS20q0Pr4CphkDZS8Zm3kEtU2SkA+39zIBelyfha3jJvBO9xiSgj8NIYS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B7fLCGye; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B7fLCGye"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Gm+Tw8+XSa+bJ+oI1D+twdriz3XQBghe3n+jEbk3kuw=; b=B7fLCGyegLqKbBlkuZFremb4NC
	NMcaW0sVTvXJSzec2kuQBwyZK9cFTJm99rT3CwJVPq84iKpy6NdgAJLp/aW4+8fBcgNxr9Tkp/0qu
	xadjcui3y+5Yy0cbNcSE77Md9cNWtD7kdvZg6GpOBJa6crrbN39N4f0aND4yYeM0mMiUZEM4sRgg1
	6AOzzcbVTu0TYrOg5bbseRqkXwCWgHzz2HBdvMAyUHIjW0HOlVOYT2Trw9Vde9P5dIt5USpqYkEeF
	dghXsfl1mReVjTpoOScfSg9+sxgeyJozpK9RHnJDD9vxSHkYYx9B273At1OdPX/clGN4BeUO9F1af
	WyIxMQ5g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEwO-000000003pQ-0wBj;
	Wed, 13 Aug 2025 19:07:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] udata: Introduce NFTNL_UDATA_TABLE_NFT{VER,BLD}
Date: Wed, 13 Aug 2025 19:07:03 +0200
Message-ID: <20250813170703.28510-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register these table udata types here to avoid accidental overlaps.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/udata.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index dbf3a60ff06e9..9b8a3b639adc0 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -11,6 +11,8 @@ extern "C" {
 
 enum nftnl_udata_table_types {
 	NFTNL_UDATA_TABLE_COMMENT,
+	NFTNL_UDATA_TABLE_NFTVER,
+	NFTNL_UDATA_TABLE_NFTBLD,
 	__NFTNL_UDATA_TABLE_MAX
 };
 #define NFTNL_UDATA_TABLE_MAX (__NFTNL_UDATA_TABLE_MAX - 1)
-- 
2.49.0

