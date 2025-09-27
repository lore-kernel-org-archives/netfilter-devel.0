Received: from truschnigg.info (truschnigg.info [78.41.115.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D8B1A3166
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Sep 2025 13:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.41.115.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758979282; cv=none; b=RzLWh+fFpV7Gw5pqUvcQP2fAzfaGEfJxBjdYXlIaPOzRsEB7Ip97C8YNm9ltu5pm7FbEh1X2KS+c6oiUQCFCI9DTurshr0Gd1IVFBGR8eBt1woxR379M9CZnAGGnwscnplAcX58PtYY1VznRuJvVTGCOIFvuCSOJonGak0YTgsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758979282; c=relaxed/simple;
	bh=IPH0SUop20bPv118CFwiInwZv5t69ES1+g0bIAwXAko=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VnDUsqlN15K4mE84nkgQdusLn/4ojEL5tAWK/aCq6fk6HCk5WYtw/m7WfaAwN2L4eDvvXnRGVARF+GcaoKQ1xRnNu0iWWHirNf3TkFQkHYoKNaHn6666mNriUdBluNFbhZ+dp+NDgRi4VXEmUS6XWTVBMkbGbCWQRNcixMpy6bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=truschnigg.info; spf=pass smtp.mailfrom=truschnigg.info; dkim=pass (2048-bit key) header.d=truschnigg.info header.i=@truschnigg.info header.b=RP75R9/d; arc=none smtp.client-ip=78.41.115.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=truschnigg.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=truschnigg.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=truschnigg.info header.i=@truschnigg.info header.b="RP75R9/d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=truschnigg.info;
	s=m22; t=1758978912;
	bh=IPH0SUop20bPv118CFwiInwZv5t69ES1+g0bIAwXAko=;
	h=From:To:Subject:Date:Reply-To:From;
	b=RP75R9/dKrYGHu4QkIosQxMx7yCEEK6AO4QCa175eDKiZzXRW6MPz4/6CipKHSCEb
	 qi27fr1eszFtqvAXIj8/tpK2KjSOII28gt4Q02+NYngUs9YWSqNTxx8PI3ldXLMd0v
	 wjqvfsWkxKMXAOw5w3+urH2PFrVJ+E9+/qj2YD5G2XH5uZjf5kLZ3rdBZpWrgxkoR7
	 sAXbKBczIIoV9azxEzEvF9YY+zKZg8sfOnK+od+5ODZSCJSCqmtX86avGW9vPTP0x6
	 ktve01ptqQI9E+8qfBpnrGkIhnvzx2/ou/4nGl4WoHhpyETLAGgZ/fUaoBE6RwATdC
	 xGTzdBF8NUL5A==
Received: from ryzealot.forensik.justiz.gv.at (unknown [IPv6:2a02:1748:fafe:cf3f:aea0:d9c0:c637:21a1])
	by truschnigg.info (Postfix) with ESMTPSA id 56E313F2B6
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Sep 2025 13:15:12 +0000 (UTC)
From: Johannes Truschnigg <johannes@truschnigg.info>
To: netfilter-devel@vger.kernel.org
Subject: ebtables-save: Do string processing in perl instead of shell
Date: Sat, 27 Sep 2025 15:00:38 +0200
Message-ID: <20250927131421.24756-2-johannes@truschnigg.info>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Reply-To: Johannes Truschnigg <johannes@truschnigg.info>
Content-Transfer-Encoding: 8bit


I realize ebtables is kind of in a deep slumber, but maybe you still
want to consider merging this small improvement.

The other day I spent some time debugging a system that relies on
ebtables and will probably keep doing so for the forseeable future
(Proxmox PVE).

Its cluster config sync mechanism spawns ebtables-save in a loop each
few seconds, and the existing code (that superfluously forks to execute
sh, grep, cut, and sed...) annoyingly garbled execsnoop output for me,
so I decided to scratch that particular itch.

Thanks for your your consideration, and for all the good stuff in the
netfilter ecosystem! :)

- Johannes
