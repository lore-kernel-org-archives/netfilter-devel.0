Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AEE8831
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Feb 2025 04:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739076267; cv=none; b=kBnN1zrXzHWT3LRJ3TUEFrW7CG3qZ8IgadRuAKOFV8/vX/xoGSjBRTf5kIlyGeQuL9eVz5O5I08iUfBQaF7nBxrIzZGjVLxP9hBFPrn5U12WMNVKsgjN0GbOC8VfO5q+8rOyCDu+q1dwCtW5DrvNGGmFYxZsEI+1pbiVU8+1y5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739076267; c=relaxed/simple;
	bh=PYP/dtXED682IYx3/W7w0KZ30pkGoGMaHGmFfFMWiy8=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=cRYE0eV5nlmfeXfQtR55yVO8bvBywKyAKtUCdrUFzj/nk1MyStRPgr9N3hRLxSkot9W69lNOi0sW7cCnCbne7bJeRmiaZkN3txNEBTaA2bLHU4RCTcROKtV6cMQ7+cG0ZE/py9RoOhdamLTCRSLSUeCLUhlzcJKNaOlnz5ApSaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=ZrwLP381; arc=none smtp.client-ip=185.70.40.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="ZrwLP381"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1739076263; x=1739335463;
	bh=PYP/dtXED682IYx3/W7w0KZ30pkGoGMaHGmFfFMWiy8=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=ZrwLP381haugK6L0BAOUC2Y9fMNEEbOkw1psACSADHiycctJ02/eUOLBdiXfjIu55
	 SZXh1LXSG5ZMWSN6ChG6n4umdV4iQawAlCZB6oSTAJS3jBmD0JCBSbWOlpzwqczMls
	 vibtnWOHS6YHTDflSmYkiSdVpzxzUEF01JudjXaxvTgmqOIO0rAsok1O/1/jLyIlHG
	 5ROyFB8QdwAdGfij37MiYegzacdcvh7/jdzU9i/VhvH4R0NeUI+uTROJ64PJpqrR36
	 +t4BrhjyvIy4HOni1BUJlpR+bdaKvzWuMVxYRGEslkDmf4uN1tQdWfT6BS0E/dv4hd
	 NFjvi5xxpbwDg==
Date: Sun, 09 Feb 2025 04:44:18 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Subject: Instructions to view source of headers and constants
Message-ID: <_yis8-xe7V5GrGbsqIuJtdZhG7YSivfWfo5JhGfSEL2ZSVZxaEiZLR7MEN_8ItmLH7xMts2PCZI5VT4hMD-dYaKZTWmbPBIDwjklrZlwkfo=@protonmail.com>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 7fa05fa596c48b2234c1d5b686c974f262351fcb
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Where can I view the source of:
config.h
limits.h
arpa/inet.h
net/ethernet.h
sys/socket.h
libnftnl/udata.h

I'm acting under the assumption that they should reside within the include =
folder in the source tree; except for config.h: it seems that is generated.

What is the value of BITS_PER_BYTE within netlink_delinearize.c

sunny
