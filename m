Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D561E14A99
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Mar 2024 17:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658668; cv=none; b=GSUgXVjgwrq9LFGh5TIWyOKsa27NoYI4iFFYWlKR1PizTs/nzQnW5GQ+46T7qC+hGLly59czUtWkbdT3+ZCjhQ+7M6QBsHkpmcs1shvJnbeGJTTFXdjqpqYJZXtLV5KjfC3aNANTB9DNuH5ry/4tLgA0+bjD9cPAjjzqQyBmltU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658668; c=relaxed/simple;
	bh=NgtqRjl4DQBIyH7HlOXfwMVvlIDNoqQvRasKtg7aOsM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIfd58a/Hp3LcAZDVAOHy0YEEmzR7fF9Jugy5COnJZzc8eBW+mqCDQzOJydZ/+2HzQLQf+WtrmDFSVP/gzyHaJOzqoeTO9mz7aDortTd65cZeoEklkq+PltA5EEwTIY0hrD4y5p+sIuLWJws+cQIZmCKe1bBXToJkQ7uGmsCNfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LplLaQBI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LplLaQBI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZlrodjD7TmuSta8uguaQe3MnKLddeOvV7yKfVd4KyoU=; b=LplLaQBIk68gRaw9pXV2TpbXyn
	WqsHxWs5cTCRAWdAWZVRxDVxFveqUOnSqgaHPT/89kMLcrJPuh0bQj0Lpinjz4bWn5sLoeXujHE++
	sLCj/9Fqs57Fej/YQBitACJy1ijfddzyNqsCXZa5rMRP5PbWr4pe3UNzMwR94oPAMsa/idcaGwmPZ
	cryYxCRhS2n3YCXk+eIFa8W3SCdiGNR6BXTPwC1sArkiNj5LnzeZwnZoJt9KaLcbRdYvx6KxfNPws
	0xcYKMy8cSgtl6ghjIHX4sFiTF1jSPfwI8DdZPhq3D4UlK9PJvXosDLG4J9kOohuKOwB3zDxopouq
	LcJlAV0g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rhYJk-000000008Q6-13VI
	for netfilter-devel@vger.kernel.org;
	Tue, 05 Mar 2024 18:11:04 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] xlate: libip6t_mh: Fix and simplify plain '-m mh' match
Date: Tue,  5 Mar 2024 18:10:59 +0100
Message-ID: <20240305171059.12795-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240305171059.12795-1-phil@nwl.cc>
References: <20240305171059.12795-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since core xlate code now ignores '-p mh' if an mh extension is also
present in the rule, mh extension has to emit the l4proto match itself.
Therefore emit the exthdr match irrespective of '-p' argument value just
like other IPv6 extension header matches do.

Fixes: 83f60fb37d594 ("extensions: mh: Save/xlate inverted full ranges")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_mh.c      | 4 +---
 extensions/libip6t_mh.txlate | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 3f80e28ec94c8..1a1cee832b584 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -214,11 +214,9 @@ static int mh_xlate(struct xt_xlate *xl,
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)params->match->data;
 	bool inv_type = mhinfo->invflags & IP6T_MH_INV_TYPE;
-	uint8_t proto = ((const struct ip6t_ip6 *)params->ip)->proto;
 
 	if (skip_types_match(mhinfo->types[0], mhinfo->types[1], inv_type)) {
-		if (proto != IPPROTO_MH)
-			xt_xlate_add(xl, "exthdr mh exists");
+		xt_xlate_add(xl, "exthdr mh exists");
 		return 1;
 	}
 
diff --git a/extensions/libip6t_mh.txlate b/extensions/libip6t_mh.txlate
index cc194254951e9..13b4ba882c948 100644
--- a/extensions/libip6t_mh.txlate
+++ b/extensions/libip6t_mh.txlate
@@ -5,7 +5,7 @@ ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
 nft 'add rule ip6 filter INPUT mh type 1-3 counter accept'
 
 ip6tables-translate -A INPUT -p mh --mh-type 0:255 -j ACCEPT
-nft 'add rule ip6 filter INPUT meta l4proto mobility-header counter accept'
+nft 'add rule ip6 filter INPUT exthdr mh exists counter accept'
 
 ip6tables-translate -A INPUT -m mh --mh-type 0:255 -j ACCEPT
 nft 'add rule ip6 filter INPUT exthdr mh exists counter accept'
-- 
2.43.0

