Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792577712;
	b=KfweJzG9z9rhvJc7QmkFkkBgoX8c42epalMGtumZ2zg6YGduXKHM2FoUbI0ePW0Rv+T3
	 m2RIb1juupsZFvLZfr0ZTaeXhVhc/q/SOv0dPqhrDD67nI/7GwVYOZuM7Om08K0jgTsgm
	 UQVvRPxofcG7rWRdWzwpFFGspZQmPd0XwKwsby7vNmj2l3Mh8QMaUBJPgO410QL4tfFIs
	 +Uh23iT9SsjDJl2+TWlv8HaeAU/aCRwdPRgzA1ofdR8TVrqgZxBrg7yg9B+z/3zukYhgG
	 qydHNJqy6M2uSFhvEjVnmU4FzRU5TCkGXEhYLA0w+9RI2JN8oR0QJy3KYxyDXIqy/CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792577712;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rBYlWWPrI+kuR0S8mz0hZ8SOx81WDbgGbmlyLnBvqbE=;
	b=y4dMXm1bGVnhbVzWMcqcFkHEbKpvXb6e2X6Y6oeK+cVlUSqThDu0RAftfXqfuZ/OPbyk
	 JqwtAQGQbwH9hDgzVNmQZgLgN7b8Xh+GUgnCoJ/LDYtSrmlALiZYnjgEY2eAW49Nbohwi
	 ihR3ijK3inPdIdApjmH6NELvmR5/i8jYWp8tlFcND1hexTIrw0tM0rILblDgmHHK0hUmA
	 mt5xR9XmOPFNkiXvRqSFfE+s5y1iBge0ynUHyh9TggsG3tOEDDrfJGQo9YLesG3A6tjTP
	 YCwfzQC48KzHos88KGM588THzu7jTGZP0bmzk9lOI2keVpKsZDmPYauz8k2ROUWQqYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b="LIr/YcoW";
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940BB606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 10:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 940BB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=LIr/YcoW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rBYlWWPrI+kuR0S8mz0hZ8SOx81WDbgGbmlyLnBvqbE=; b=LIr/YcoWRGbOeB2iA7YG0jUDLS
	JKg/hA4tI+ZTBJhFax7Gt2kjatjF/+wMR8X+YrtVj1YVpo6u+0MJfuG0FNIOsfUmmhZ18qt//v8Re
	Rji0Bhp0ZDAIKpWDGD5v/aQ9cd2NDbg4vW6PIaiUNvXu01W2i+Swip3RcwYvvkhKe5AJB4ngE45YD
	Oa6Ol+QoBkQfM5/r/6AYM6Ptci7vDn+msPebbp7k0lj2CFjyo1wRSAdjKzGKYI2qAVFTXTLcllLPd
	FrftT29AT+V6cz1wQU+ngpXBqbt1Eb01yB3ld1l99SW24qJzGT7vlXZxKkh7a64JGKQVZMQpdea7w
	PES4gDag==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xJTLf-000000001JO-17oP
	for netfilter-devel@vger.kernel.org;
	Wed, 21 Oct 2026 12:15:07 +0200
Date: Wed, 21 Oct 2026 12:15:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Add missing feature tests to
 packetpath tests
Message-ID: <atiQqz9QALpxa0QW@orbyte.nwl.cc>
References: <20261020140403.75708-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020140403.75708-1-phil@nwl.cc>

On Tue, Oct 20, 2026 at 04:04:03PM +0200, Phil Sutter wrote:
> Test system may lack conntrack-tools, add a feature test covering it.
> Also add missing socat requirement where needed.
> 
> Fixes: e1c4f734eae7c ("tests: shell: add packetpath test for nft ct expectation support")
> Fixes: cbb928d3307c4 ("tests: shell: add packetpath test for timeout policy overrides")
> Fixes: fcef13a358a07 ("tests: shell: add 'nft ct set zone' test case")
> Fixes: 3d4ed753c1231 ("tests: shell: Add a test case for FTP helper combined with NAT.")
> Fixes: 9d8c7bbe82504 ("tests: shell: add packetpath test for nat on loopback")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/shell/features/conntrack.sh                  | 4 ++++
>  tests/shell/testcases/packetpath/ct_expect         | 1 +
>  tests/shell/testcases/packetpath/ct_timeout_policy | 3 +++
>  tests/shell/testcases/packetpath/ct_zone_template  | 2 ++
>  tests/shell/testcases/packetpath/nat_ftp           | 1 +
>  tests/shell/testcases/packetpath/nat_lo            | 2 ++
>  6 files changed, 13 insertions(+)
>  create mode 100644 tests/shell/features/conntrack.sh
> 
> diff --git a/tests/shell/features/conntrack.sh b/tests/shell/features/conntrack.sh
> new file mode 100644

Patch applied after fixing for missing execute permissions in the new
feature test.
