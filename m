Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDFA227E86
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 05:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.77.79.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745559037; cv=none; b=VNfcAZTJr7MgofNu7PxRRHIGACZLaMANca9oijh6kVRgBaiMxBPnHC5qBidV8Z6BSZ4wMevw3mw2i8taxUPax5H9+v5tDRz8/upqGYDMajClPlJvMSyONk4639c0jHTE0hYfFedFh0bRIioL7ERIwi22DRAj5i5BmAsl+5yY5tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745559037; c=relaxed/simple;
	bh=MidxOS2dqR+ACIlsAA4NtieIXNBA6XUeuKJx8wP2RKc=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=gAfIUV35ReT6v9tuCkkJ6i5lgR+1io+r0+Y1AbqJObgnUQPDGD3jlgPzlnoshA4HUO1KW+TY6lUNkoxd+d6yeY3fVsoW0G1xU97a1y1mupOFNIGrUQ8zYbbA5lAUwLGqmjbcAnhafqkc4muDukeldLlqDiGHuNxW70+xz1yM5t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=LbEXT5Py; arc=none smtp.client-ip=51.77.79.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="LbEXT5Py"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1745559025; x=1745818225;
	bh=MidxOS2dqR+ACIlsAA4NtieIXNBA6XUeuKJx8wP2RKc=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=LbEXT5PylRRQfCyfCRR80YhAriwyQoY32nOrefOBf6mq2Zr0DaFIBsvu90nTp5dVh
	 BCcMm8Cj90A6ZZ17cDM9W4jyIRP1pc+g72UCHqQKLhJF2I3r41Qwyxecpqjri/4BKn
	 YojBluCBTRgicEFHUuN2qHJxmNMAwLanwZoy8BTSwKe4i6jYIM/v90ttrwPJz3YQ4x
	 Wdci5ZaAr2OmAtLXf1a4pv9h8zw0iqKEiaRN0QfPT/+j3ZenwfOK+hJGwyXn/9TD8C
	 RBcH/bTFoMPTqlHmTTJleL/QxDvpMzJ1Rf1m01qw1EdlUvK6UZ4tOAd5jSeYrYScc0
	 rdHEekcOImTlQ==
Date: Fri, 25 Apr 2025 05:30:22 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Subject: Fail to clone iptables,ipset,nftables
Message-ID: <1EYtBL_6T4QRNdyaUOoY2OO_FLzCtCfv4Q7gBf28RHR_k_LB-t0IN5R7v12bgaOOSKputo826H9PZ-2EmksldVLnGVoXyMQVemTy3tMra10=@protonmail.com>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 751e01918df5a965b14058ae2158c7c292a43b3c
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I have run the following command in 'Git Bash' under MINGW64 Windows 11:
`git clone git://git.netfilter.org/nftables 'C:/local/path'`

Output is:
Cloning into 'C:/local/path'...
remote: Enumerating objects: 32813, done.
remote: Counting objects: 100% (32813/32813), done.
remote: Compressing objects: 100% (8468/8468), done.
remote: Total 32813 (delta 26246), reused 30199 (delta 24215), pack-reused =
0
Receiving objects: 100% (32813/32813), 5.34 MiB | 2.08 MiB/s, done.
Resolving deltas: 100% (26246/26246), done.
error: invalid path 'src/json.'
fatal: unable to checkout working tree
warning: Clone succeeded, but checkout failed.
You can inspect what was checked out with 'git status'
and retry with 'git restore --source=3DHEAD :/'

I then tried:
`cd 'C:/local/path'`
`git restore --source=3DHEAD :/`

Output is:
error: invalid path 'src/json.'

I can see '/src/json.' in https://git.netfilter.org/nftables/tree/src?h=3Dm=
aster

Is there a way to force this clone in this Windows/MINGW64/Git Bash environ=
ment; or should I retry on a *NIX system?

sunny
