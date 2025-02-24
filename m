Received: from mail.netsis.lt (mail.netsis.lt [91.211.247.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C8323F43C
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2025 08:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.211.247.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740387373; cv=none; b=T57XlVjmLClCAnWxv8nDEcbwBj23jbWmdmFKgN2tp5dhyc0ZnNRPexf8YXq8YUo6FXcI+nRlMQrq35J6wnqbQ63xq5ASlflXuoaC7qtcE93GSAZnKqtxBD07eetJjaGXXpAiVDMgJKf+SDaYh37aQ+QbqMk6GS5Cv8FXCdeD3yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740387373; c=relaxed/simple;
	bh=6/cFn8kjLlr1V/xCQuG5gy/1DRrg3vw4vcj0uvaNvyc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iWIm8aq7RHiqtXwMQLN4etP8m0Km9CfcMFXenZj/8TEOVdMTHbEvKSPfx0HhrqFe2kSOT9rrX6kSIfV0eojCHd79KTtA4tsoNzcqhBG769zyy+n2/aZMKxQg6cpbdPF4e9J/xvW+mkdhgdMM/PdKgoyQcaFAD2uiPF8GxHiToPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vdx.lt; spf=pass smtp.mailfrom=vdx.lt; dkim=pass (2048-bit key) header.d=vdx.lt header.i=@vdx.lt header.b=rAmvPRH1; arc=none smtp.client-ip=91.211.247.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vdx.lt
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vdx.lt
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vdx.lt header.i=@vdx.lt header.b="rAmvPRH1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=vdx.lt; s=default;
	t=1740387365; bh=6/cFn8kjLlr1V/xCQuG5gy/1DRrg3vw4vcj0uvaNvyc=;
	h=From:To:Subject:Date:From;
	b=rAmvPRH1FIAGaEOh8PahqgnuYq62aq+6+r5yChPvEBri6HZ0bz/8YHj6qGgXcZ9Yu
	 lDOFatb5ZTN10i4q3oJ8e8D+F5Er364gmFHJRXE9Aq3GEKg/Fy5XNt1wP2Fv4VUg0B
	 qyWmGS/1cXUl4QTZYzcFjOohMddLAWeRlYghdhxazIaGpCdtPm63As5T94YnA7NeY7
	 WGBi/PwwJF4xrPiYj0UJ240h0aNiZnflwP8NCwO1586Gi/mW+ZKtCPf2wKAc2+accj
	 YtvzLTjeTfdiVJMOcrDg9ZOjlQ5TDs63Hi+YNCPYCEtfxlrBXXGqT+PNlleoNQaN0t
	 o6aW2Ap8ynCHg==
Received: from DESKTOP7R89AO7 (unknown [88.118.134.203])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.netsis.lt (Postfix) with ESMTPSA id 2582412025A
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2025 10:56:05 +0200 (EET)
From: "Vaidas M" <vm@vdx.lt>
To: <netfilter-devel@vger.kernel.org>
Subject: ip sets add remove
Date: Mon, 24 Feb 2025 10:56:04 +0200
Message-ID: <025001db8699$eff39d40$cfdad7c0$@vdx.lt>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AduGmeGYAS3Dm6lbRcGD+nCdIBAbHg==
Content-Language: lt

I created a set of ips:
#!/bin/bash
NFT=/usr/sbin/nft
$NFT add set inet filter ALLOWIPS { type ipv4_addr \; flags constant,
interval \; }.
$NFT flush set inet filter ALLOWIPS
$NFT add element inet filter ALLOWIPS { 172.17.0.0/24 }
$NFT add element inet filter ALLOWIPS { 192.168.0.0/24 }
$NFT add element inet filter ALLOWIPS { 192.168.1.58 }
$NFT add element inet filter ALLOWIPS { 192.168.1.89 }
$NFT add element inet filter ALLOWIPS { 192.168.1.125 }
$NFT add element inet filter ALLOWIPS { 192.168.1.179 }
$NFT add element inet filter ALLOWIPS { 192.168.1.212 }

Then I use this set
# nft add rule inet filter input iifname int1 ip daddr 8.8.8.8  ip saddr
@ALLOWIPS accept

But when I try to remove / add ips I get:
# nft add element inet filter ALLOWIPS { 192.168.1.58 }
Error: Could not process rule: Device or resource busy
add element inet filter ALLOWIPS { 192.168.1.58 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# nft flush set inet filter ALLOWIPS
Error: Could not process rule: Device or resource busy
flush set inet filter ALLOWIPS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Why?


