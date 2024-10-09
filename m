Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5B519048A
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 10:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471053; cv=none; b=FkagIPTJKh5AKZWYCQ8uzU5AyHl8gMX3yT9w7+nCIeK9sCnZrvdh7fdaagOWSbYSfbcQ7xlG4PLd2zxXtgH3eh0asKKLhfHxNOR24mAtT8RICXpvKw1VVwnzojsJug/fIdAHgqIiwkEUhq8n0MYwpRCp7xZxXu1k/OKsIlA8rtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471053; c=relaxed/simple;
	bh=MfcZeYV9sMDerxPl93oFnRskAaaNAcnWWp6NZAAFpm0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qE76nf4dVkqcL6LW5E2BXDKpHbyI15nwmk7fj4UX/Ik56+WJy8UAl45roiPrju1qhOH5XJp7RQSxqY0xKTYpF+kvdhWjOOHgApGMVx+5vDVk4jfmdmMI2cvTX1jjFuouf7ofwQPPbCSPJw+Pl+WkZ3eBQWBWkH6Mis072irmSyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KZtGRhTU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KZtGRhTU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=28cR+y0Nx4MItjoOmSzUdkg1s0LO1pfL4IqYV1KlbgA=; b=KZtGRhTU9AYB81eoTekWxFWf1A
	e0CM0QtrOO5S0ZYC+RbciUgvrzAP6ZFZvWWadZokgzwI+PYg49pPFaFdLF/VGuVBF9uYLcZTv510b
	taMtc8nmbsfrsrUQT9GLN4lAGOkAAHtAJH7iHobG584RB++PROrdWSgkFyzNJAdO/qivGEKp0BgXo
	Z5vqy2K1s8JR+Ml6ePJLo2B0hxkhw1OEy7tufBj3bXCWrqXBYyu11s6N1/U1AwUCWbzoO+XztXING
	ZOBnG02uDqM0KIn7u49lOR2kQCcpqPhYdzyFj6eNlv4990LcALqIXIzMiMn6Wt7SQWmidXev1Q4d6
	4D8CoQyQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syUHE-000000007Qc-190j
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 12:50:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/5] man: xtables-legacy.8: Join two paragraphs
Date: Wed,  9 Oct 2024 12:50:34 +0200
Message-ID: <20241009105037.30114-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009105037.30114-1-phil@nwl.cc>
References: <20241009105037.30114-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The second one referring to xtables-monitor seems out of context without
the first one, join them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-legacy.8 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/iptables/xtables-legacy.8 b/iptables/xtables-legacy.8
index 6db7d2cb4357a..fa26a555c5e90 100644
--- a/iptables/xtables-legacy.8
+++ b/iptables/xtables-legacy.8
@@ -63,7 +63,6 @@ updates might be lost.  This can be worked around partially with the \-\-wait op
 
 There is also no method to monitor changes to the ruleset, except periodically calling
 iptables-legacy-save and checking for any differences in output.
-
 .B xtables\-monitor(8)
 will need the
 .B xtables\-nft(8)
-- 
2.43.0

