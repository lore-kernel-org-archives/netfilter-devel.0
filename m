Received: from fout6-smtp.messagingengine.com (fout6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB1513635E
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724260725; cv=none; b=GN1w8rPRsH+fvmQ7ELPXvrtEgFFw3qO+OE6KewtayHGQ50C0Kzvbz372VOgW4DNP6flwzaNEUmN51bWGfJd4ntU7cHE43WeBtsga/Vd0DYzjdW+5gR41hroyqelGAgQo3AD93TjW6nrs5NZymogF0eNHM22N7CoFyqfT6YrD4Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724260725; c=relaxed/simple;
	bh=3oNu+sYmmm3lAh7h0m1qV2HmDt77TIFN1rBTi0UoMYk=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=fieWc3jTVWqIZy6C5e3wwh8YO1CofrR3IMDslvBS1S7Bv81kIGn/JcDmuByJZMUS1H9zA7VpVlp+etRlnvdKgedzBT/TU81D4yziXMnRk25Ffz+RxZfBxhDmKPuv6J1MzBr7FTZbU8QQgEfRuDdPuEP+TsiTJ6OH8/0sXwCrZ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fGCpb+2n; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fGCpb+2n"
Received: from phl-compute-04.internal (phl-compute-04.nyi.internal [10.202.2.44])
	by mailfout.nyi.internal (Postfix) with ESMTP id 8F5A5138FEBB
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 13:18:42 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 21 Aug 2024 13:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1724260722; x=1724347122; bh=c88ZLrwjYdeHM
	kVcGRB8NpbhqGbzPXmD36wzj1myVj8=; b=fGCpb+2nTYi/YSg8p0qO86Uhr437E
	AhuZJt4xm3Aeh05P/Lx14Y4yTCWe9QR0Olh/BL1pAfZJeVTveXWHEmQCXkc3DYyX
	VSc4+XW5v66Fj/iMdcBMKuj9IUstHZoBqdEdSOQE70mahiKcRQbCMkhNKBvTecTk
	s5J8kmDAHr6B35JBCFLv/ulPz2vMvQ94JYoCsFzPfs/kZ8hRBC6azRSR6nYENGp0
	tKCvYoKPg0UGHaVkPeKHrswqv9WouWpSdSdHgUalUNt730S72JmohNIlS/k+5dE4
	hd3g7tmYXF8ZFytULQTeNThCf8JmyZEVLs2Uscl5nELsBg9Lmp/NWAgsQ==
X-ME-Sender: <xms:ciHGZgAkmED4BAvFxQUxy95OE96ctJJED7QhKChe6_1lAfEIRe8Ryg>
    <xme:ciHGZihwFakmJfwfU_dKgbIKVwx8I5BTiVZZ-9kq01vwOcQS_dGkN8r_qcuiP_rtT
    4Agdci7128mPARJ>
X-ME-Received: <xmr:ciHGZjkJJU0jYWcvhnyepBnwBMA2_J0_yAH7lW9EuhTdZXjc-iuM0HGjE51tzxcpyOjfrBgsf9Hg9rbXrTugUqOoD6j57YYMDw4rqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddruddukedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhepkfffgg
    gfrhfhvffutgfgsehtkeertddtvdejnecuhfhrohhmpehpghhnugcuoehpghhnugesuggv
    vhdqmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpefhudfhueehtdehkeevvdejud
    fffeeftddutdeugeeuueegffdtffdvueeghffgtdenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehpghhnugesuggvvhdqmhgrihhlrdhnvghtpd
    hnsggprhgtphhtthhopedupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehnvght
    fhhilhhtvghrqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:ciHGZmyPfVIOkmYabsW3rqQuM3pKv1WpsChCUgMzIyJaT5_QS5NB5A>
    <xmx:ciHGZlTdJApUIsAlM6Wl7IOHuaIP1goE670NTgkgAJtYdZKSfQhJ0Q>
    <xmx:ciHGZhZR4tKA_TJYEf4X8IMnluFrR35HLO1b7j9XrrYXdGpU0gBhUA>
    <xmx:ciHGZuTbG2Zg61EPTl7lhj4tI4WC_R73NHSGivccE9qi-dHm9yyuHQ>
    <xmx:ciHGZjODDzCKmgpqMbNYFUWndsfiRZ1hbrkmz0B_6uFJGEjz0EkK_Djm>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <netfilter-devel@vger.kernel.org>; Wed,
 21 Aug 2024 13:18:42 -0400 (EDT)
Message-ID: <d679b375-5540-47b4-9395-eca8666ac2ec@dev-mail.net>
Date: Wed, 21 Aug 2024 13:18:41 -0400
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: pgnd@dev-mail.net
From: pgnd <pgnd@dev-mail.net>
Content-Language: en-US, fr, de-DE, pl, es-ES
To: netfilter-devel@vger.kernel.org
Subject: =?UTF-8?Q?nftables_build_warning=2C_parser=5Fbison=2Ey=3A206=2E1-19?=
 =?UTF-8?Q?=3A_warning=3A_deprecated_directive=3A_=E2=80=98=25name-prefix_?=
 =?UTF-8?B?Im5mdF8i4oCZ?=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

i'm building nftables from source, currently `master` branch on fedora40.

i'm getting functional builds, but did catch this in build log output

...
config.status: executing depfiles commands
config.status: executing libtool commands

nft configuration:
   cli support:                  editline
   enable debugging symbols:     yes
   use mini-gmp:                 no
   enable man page:              yes
   libxtables support:           no
   json output support:          yes
+ make V=0 -j16
   YACC     src/parser_bison.c
/builddir/build/BUILD/nftables/src/parser_bison.y:206.1-19: warning: deprecated directive: ‘%name-prefix "nft_"’, use ‘%define api.prefix {nft_}’ [-Wdeprecated]
   206 | %name-prefix "nft_"
       | ^~~~~~~~~~~~~~~~~~~
       | %define api.prefix {nft_}
/builddir/build/BUILD/nftables/src/parser_bison.y: warning: fix-its can be applied.  Rerun with option '--update'. [-Wother]
updating src/parser_bison.h
...

certainly _not_ fatal.

checking here 1st b4 reporting @ any BZ ... is this a nftables or bison, or build config, or to be ignored?
