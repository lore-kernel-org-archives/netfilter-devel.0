Received: from mail-4325.protonmail.ch (mail-4325.protonmail.ch [185.70.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4246426
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 11:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747220672; cv=none; b=JKREqM7nano9vDp8u2xpcnrvmjc/cDgWHklA/PzSxFfgNPjzij1SDT7HgzVXO7cDyC8sVEDPASjBkHc5n0oy/otHiMivEPb3zqYy3giqaQh+/xxA/4YBddrWNXyj62pSaRldGEyhxEMQm/8IPrm2dmYDA0kmsJhzs8BydRmKw5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747220672; c=relaxed/simple;
	bh=0+YmIpd2usUt9luUDWfthwnxQjbHaxRFrwPXqHxpaRo=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=iDMzNRtR2R2eLu3w0XxFMK7nRHO4fik6jE+RJkqo+wWBBIffGiHnS08QWMHgCKgdUB4BUm1UjVSdbjhAddfs23+N5q0RvTG6ECtprL6Cigg+6AGFlYIBnZ3nN9WXdRLuW3exqXpOh7YYotb79ltLZV89qgXwJ2gL04co8C/vmXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=vXaEea0A; arc=none smtp.client-ip=185.70.43.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="vXaEea0A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1747220661; x=1747479861;
	bh=0+YmIpd2usUt9luUDWfthwnxQjbHaxRFrwPXqHxpaRo=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=vXaEea0A+DRuLVmE5kQGbyfxsT2kYvQgSspDG9X6KqQLvLt5RrQf2Nr9+5ruJ69YH
	 v1FCRYJouqIw/iy2qwfhmSbgXfELqVBcOsSAR9qu2BdBn/Pasu8Ge70FTQrMjLO5Hh
	 q9hfV3FBuaRldT/CQEhcjIaPgkYbl5phX0/Tr5BkboIb/+iSQGnyASje9lpVMHOIAs
	 i/4+EDI1LtCVz8be04+7iboTAkNp28eWEtvZfEKP+2XjNTl+on/Q0aWUK45pKY2Vlb
	 VxwWy263gyDYh8u0spuuy7qEyany1ITlYkHn5w+zI+xPOqDdibnl/sw2vam7U6yp1S
	 8I2wIIOLYSJNQ==
Date: Wed, 14 May 2025 11:04:16 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Subject: libmnl name definition
Message-ID: <IShfT8BT5atzrguXzEkqxTG6-2a6ZsduAwhPXz47h4Rtcp8eaJZhPdg1QZx0mjKWb1UXvGINZSv7wjqoxnb4lDLuH_V4GxXAoGtPAhrEqM8=@protonmail.com>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 8c9b126c7f7a3442c9ca4f9340a961e7349e35a7
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi mailing list,

What is the definition of 'libmnl'?

sunny
