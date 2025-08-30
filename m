Received: from outbound.mr.icloud.com (p-west2-cluster1-host7-snip4-10.eps.apple.com [57.103.68.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B387F274B4D
	for <netfilter-devel@vger.kernel.org>; Sat, 30 Aug 2025 03:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.68.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756525701; cv=none; b=k07X8/0bYhSZQ/VPRclvwl0IdM5OVU4aBn4hVCoJRq4ZzaUgH4Apf2YwHqamTPiYs8k3qNoFKbD4J8KraGicMIA//wLJDyNotrDAZN6nttYrVSbfG5/wsLa/srFdkfX88ekqzC2Neoht2x7fLRnFfLDUS52o/eAuttbzvnxE3tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756525701; c=relaxed/simple;
	bh=FOudgFaUN4+RYtclLs66v502bIhTG7ys3GkfBveCWMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/WhNoDPu1QcG4QrkXbeZyG62CjsSzBe6s/tZ/ejqyL6+F2OXRZc4vn8UlewjmpPR06L/SAVH1cdwzh04n2FFgUG1X0tMsbIt8Kb41oolta759upeetoABoIAOXwGMa8Q4/Oy4+XWw01NelclRVtjqig0dQCsXU9KfxQClzeQ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=hnZVNs/k; arc=none smtp.client-ip=57.103.68.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="hnZVNs/k"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-4 (Postfix) with ESMTPS id E95441801934;
	Sat, 30 Aug 2025 03:48:17 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=FOudgFaUN4+RYtclLs66v502bIhTG7ys3GkfBveCWMw=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=hnZVNs/keTMfdxXyeDYxUPCtC7zwFuuW3mcnOuS+MO+xT4E7b1XxR4PzP8QD3z38OFbitweRmGP/gCld0brPvMDJtFROfK1qV3SWWoYYe2xntHmIN9XHhP19QmgcdDBR0a4oqoqUOWg0Ns9D43fJ6tGnIUqMoHRdJz1P8eO3vP2gwryWocqWt36XeBNzRr1dtjZNWzkfChxLgkIEuDtCRTj+dEnxL9dcgAQfB6u3k8G6YRVdt4CxcZxnwnF0wjePe51Kp0XvnyKoSRB74euOseTWRpMNRR6kKft+BmNa+40nmN3QhUbdOFbrgFQQq0BE3fCNuIs5t5TNcS+Yx8Q+8w==
mail-alias-created-date: 1632196724000
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-4 (Postfix) with ESMTPSA id 64B06180093A;
	Sat, 30 Aug 2025 03:48:17 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: dan@danm.net
Cc: fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] v6.16 system hangs (bisected to nf_conntrack fix)
Date: Fri, 29 Aug 2025 21:48:10 -0600
Message-ID: <20250830034810.11329-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250731194901.7156-1-dan@danm.net>
References: <20250731194901.7156-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfXxHv/Q687OtTg
 EBbCaU6PY70Q68Mmgnd/R+c6Dq3DNLbA0bYZnxiw3tWMCvNj+QxZE6QOXX0fVM84FDPB9lOQmuQ
 1vMghOnZ0apuWVIvjmTSwxoeYuQXPxXRl2p5izzShWwRz5ZTY7ysjs+bjRMepbTZRE4wwDEcvvj
 ycaBWvbXbmq7yyXLcsN63hpNRHQDM18dC0TOQVJHXYMGoNgioIrpIsC2oIrGOjbmPwr1NONVWCZ
 hcxUGBW7yUDn6hK3o5fQ1XdPIKTK+EfdGcKN3mqo0R0yRFK3asFmgvJoVnlmN5FEu2fmQRl/Q=
X-Proofpoint-ORIG-GUID: 0Lzy3LkLkYncDHfWmxp0BJigzyMxeq5W
X-Proofpoint-GUID: 0Lzy3LkLkYncDHfWmxp0BJigzyMxeq5W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 clxscore=1030 mlxlogscore=999 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2508300034
X-JNJ: AAAAAAABtn6g/vv7+efLQjznGwtFDG4n5wGJnILq2dDXuxW78iYdMFcGjgGOv4o+qWN3AitbJApOc3YkW+kUQb0XaM3PWjrgYgip6hWtcfbWeJaromxuCd/GgIxdhb8yP9+aeNpvywPxHf4h5ltsx5NJwl4c9ivyCcDFkieYHdTUIWAwrIbl7P6xPAm4172RhWFp7JHFe7FTdCFxp2GvHdckRbtxWO6etetPIVKtPLw0r9WSdyM2PnBBxWAB3jaksyQtPAusOZXbBtFQ+jJRNJC/Xs6sAa/lj193eKuaCihPnELnxy+QkI/Li9DCeXEvGqGIsz6qQBfQxv91TipyCnx9qpxarL/26fwEXWTnQrMbSlzTJkGWwXlPkSZU5zhXFzKnFljo2EPyPYMACC1gYUke9l3ufLLjhvFYMKg1GufKlnTZ0gxwVww/r4VkmzNtHb3xxlN0yGEOUKP3sRgdLykvksDHfMn3ImeNEp5ZkrAyBEDaiX6H7eiW81xFcKdMnwK6WV6eWqVymmQbH4qwRSfiKb4QkHMUvjyJ7A05QPvDtklMWdUCKKjCA6SvkrS7aUGUr2XnkpkIP/qH0oQBP8Bq7v4R82PFCswFnmH3n9sJxpRXkZRaCKGhLQ==

> For some reason, I can no longer reproduce the problem in new kernels
> that I build. I can still reproduce it in the kernels that I built
> last week. But if I build a new one, from the same commit as I was
> able to reproduce it from before, the new kernel build can't reproduce
> it. I didn't change anything (like compiler version) since. So I'm
> stumped.

Well, I finally figured out why I couldn't reproduce the problem in
some builds. It turns out structure layout randomization was affecting
whether there was a bug or not. So every build I did had a chance of
not having the bug. This also led my bisection effort down the wrong
path and wrongly indicated that this nf_conntrack fix was the first
bad commit (and also by pure chance of randstruct made it look like
the problem went away when the change was reverted).

Now that I know that it's a randstruct problem, I was able to use a
"known bad" randstruct.seed to reliably make reproducible builds that
always have the bug, and this time correctly bisected it to a problem
in compression code in the cpypto API[1]. netfilter had nothing to do
with it. nf_conntrack is exonerated :)

So, Florian, sorry for taking up some of your valuable cycles on this
wild goose chase. But thank you for your attention and quick responses.

Cheers,

-- Dan

[1] https://lore.kernel.org/linux-crypto/20250830032839.11005-1-dan@danm.net/T/#t
