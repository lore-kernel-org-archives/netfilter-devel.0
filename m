Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3C82D4801;
	Mon, 17 Nov 2025 21:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415605; cv=none; b=FfE8JuAkXXyP8iZeI/dF3/qMJX5cw0l70kqTNw10sFUvXQhyQ/7uwg88UvSEen09ZAUxsD0H8C811+6XR0HCu9CbKikd4KZT3KtuZ74uZhyPxnQcn3EkJV5k9JUbHwg6o2XqDCU70eyyw7st46D++ZJfn9mcUG25RIGjbd48X7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415605; c=relaxed/simple;
	bh=+UN5XwSYIm+MQA8Q8JDwpY4HJI7kcSh9fJav2Ff4las=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lhyHxS65Ikh0+HqWEyPjHYDO/j1iboYXpQL2HbOH9CMMhrWuj95MrNHS4neJI2VIkkvkBG9ItLDgV9xraZjQNu21mVnVkuIGSCNE2BZINPGJkuiP8IhTNb0KYYyeCU5riTYkYuMZ236SovJSATSpJ4M/MPRZE6T8NEHootC7mNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e71K62Hp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e71K62Hp"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3E66560265;
	Mon, 17 Nov 2025 22:40:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415602;
	bh=wOGdMWwvZoYk8WXknEPGFHBTHMiHKNJ2wlsRwHXX15w=;
	h=From:To:Cc:Subject:Date:From;
	b=e71K62HpRIRSg4qvVMh+T1ANqo/Nhdyo5mravbFxDHuN/bBNldzWVJQWH2P/qq17x
	 TrKbLj9auvHdbsqJU8HREJM2iTy6qREAzhKGPKATBaPNJnZp2XR82cLiqKNynJNJZl
	 0y1ln/ISS/d6YgrJVldA58V1xtI9S+QwnyXGIbO4ZGSICQvjsiw3ENVE3g4CHiMWIg
	 7VH6Dg1cIj/dqekx8IVd1FUR2TXaQpLCnkf27OuhBFxhu+p/WSoKeFFG6/UPoUxALT
	 XIxCg7VCGzNo+TWQaJWpIeRFvhj72VqwuOKuE5V9MwlFlm1kb/9Z6FfaJ97rSgNt6Y
	 MUwMpEoaUnTSA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1 0/1] Netfilter fixes for -stable
Date: Mon, 17 Nov 2025 21:39:57 +0000
Message-ID: <20251117213958.858900-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,
 
This batch contains backported fixes for 6.1 -stable.
 
The following list shows the backported patch:
 
1) cf5fb87fcdaa ("netfilter: nf_tables: reject duplicate device on updates")
   This only includes the flowtable chunk because chain cannot be updated
   in this kernel version.

Please, apply,
Thanks

Pablo Neira Ayuso (1):
  netfilter: nf_tables: reject duplicate device on updates

 net/netfilter/nf_tables_api.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

-- 
2.47.3

