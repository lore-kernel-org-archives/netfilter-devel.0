Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31C6202976
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 23:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758929599; cv=none; b=CZjA4CuZCQNb4dx6cMG19eBuyUjAp3Q4q/cdZnx/ya6Hz29FdSolmYWHwRT+NuXNcUON+WKm6J7TP9rmI2CZ+S+buWoBbdNC26NpiOlOYaXGsqrAfmXFAek1+8io7oXUO7FfkGdVJaNEw9D2aWyjKg4Sh93WbA7rgm5UkefQinM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758929599; c=relaxed/simple;
	bh=yF+G9WZWPmmVdggXiKgN8tVNVV3lb3b9jAm7OxNiZQs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=jMTswNRhx+UMUAU7PrQ7Aj8cusFyrJBFSOXdykb63Bq/pAuq0W43RpfQEEzzk2ycLVEsAc5K/q0JaZk9P0gj/qVw4F58fNcDqIbEmSIQNUF3bAldrRXVCFk2OxAoVC52OpFPYTBLBGJq2QGnFxiH7cDq5ACvoGVrr0ngUcTrn8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9UT4uMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9UT4uMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1284AC4CEF4;
	Fri, 26 Sep 2025 23:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758929599;
	bh=yF+G9WZWPmmVdggXiKgN8tVNVV3lb3b9jAm7OxNiZQs=;
	h=Date:From:To:Cc:Subject:From;
	b=j9UT4uMgF4rj7hqkjUznq3StTuQoIDRah9UdBh+XNUWRqmVqW7Fk+VDWKhsH1Jfc8
	 sH10zmxCMVsNZUM0cLJrwGex65jp8AgvuY8pmCo+HBE/wMbeLsQTLD/pFX7EuFlxVF
	 Ap/iuWKPKDrg3BJJPfk9rQcIbfLPefSkZxsf0xjPaNy7O9cXeC4X693IXKuMQRy0i1
	 56i0jXvXw5VZgdsJDadJvJehLbTcGoUgqN3jwW//ir3zlqWid4+kRoaP/MmkaDBSmJ
	 GBsJ5TBHGnFZwACz6ZVGi1BuM6NDGh8lng+jLHJq/kNSn0y1aahRw3GunmzqrUmS90
	 6iBP6tXoRcLWA==
Date: Fri, 26 Sep 2025 16:33:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: [TEST] nf_nat_edemux.sh flakes
Message-ID: <20250926163318.40d1a502@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi!

nf_nat_edemux.sh started flaking in NIPA quite a bit more around a week ago.

https://netdev.bots.linux.dev/contest.html?pass=0&test=nf-nat-edemux-sh&ld_cnt=400

All the failures look like this:
TAP version 13
1..1
# overriding timeout to 3600
# selftests: net/netfilter: nf_nat_edemux.sh
# PASS: socat can connect via NAT'd address
# FAIL: socat cannot connect to service via redirect (3 seconds elapsed, returned 0)
not ok 1 selftests: net/netfilter: nf_nat_edemux.sh # exit=1

(with the number of seconds being 2 or 4 occasionally)

This is on the debug kernel specifically.
