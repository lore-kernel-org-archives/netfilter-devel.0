Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD92753F1
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2025 03:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739504278; cv=none; b=jJ2Fm9v/PdFFmmxjICXTe3igy0Y/l2toa2SgZbKRfqIu4Whge1EmTcNKBWG8g6tErb6NaHxj3AogHKWrQI7loJc0MoOlDQSq2xa6TLjrieVTJVuePWn108s2KtlN1GsWUhI08HkKF+P74NGqNEq+wPd/GxHy6YITgZ6rRr9D93g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739504278; c=relaxed/simple;
	bh=LK/aJgcMCh+jnJ9p7pji7YK8/3uVGB+UmHhiTt0oQIE=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=MYUxdkpwBT2L74hNhQ9tvJyrn6A9rX0GAIDwSC7xTwezVP8YswYx9U8mMhatBYTRN8sy/vi9/FRJf6BwS8quH9dOLkImb5vpiEZ3Z2gtic2aFtF7jx7VcVwy4y848LI3qC5/jtBPgMWTk0YmbuaiKAt7HVL6zeLVKN3SBH/7ogk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=du1VTL2h; arc=none smtp.client-ip=79.135.106.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="du1VTL2h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1739504269; x=1739763469;
	bh=CFMQGZvS52afBy+GNnAJY612l6VjFGQr/OIMfD9A6Ng=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=du1VTL2h8PW5GpzN7tjdtXuSVNRMPjnyXgY5XcKf7aygiC7QbuB9vXc1oJZ6Lt5ib
	 gzvoLDavHMcZ/klumg6J8qdam7Hfo4QdxgHdl2quCU5HjU/7CRhbg9Pv0qZldn+dbq
	 U1g+gvNkTPA36r0gI4Dvsq7SuzOshvHkoeUwlK1DZj5/oeOlRZEw2cPutZlZj9tOzf
	 W/aCVFCMsl4htn4Cm+68HZhBfPKcMwzYr6voMWV6GJ1VCE+VS7Jb+5oH3YSYmWjMqe
	 A8YgG5x/PebUlnnzq8LMgCMV1He1H3JbTUCS2v5uJQ60LiWZmKh1bi0mdXfR8yRxXK
	 To77iqYxFStzw==
Date: Fri, 14 Feb 2025 03:37:45 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Subject: payload expressions, evaluate.c, expr_evaluate_bits
Message-ID: <pEHO7WvK0prMNgZ-F5ykdLmclh4sY_7_tM7aC-AkyCPTDU6izTFwHj0tJsLHGONPYZKM3zt7B2wVJihfd0Vdxv71PjrpxtuRKY1AlVmcyBc=@protonmail.com>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 6d8282e9ce6471cd39b53e3cd38f02b7d1e88043
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

contents of /etc/nftables.conf (run in dash shell Debian 12.9):
-------------------------------
#!/usr/sbin/nft -f
flush ruleset
table inet filter {
 chain filter {
  type filter hook output priority filter;

  @ih,0,129 =3D=3D 0 \
  accept;
 }
}
-------------------------------

Output:

nft: evaluate.c:510: expr_evaluate_bits: Assertion `masklen <=3D NFT_REG_SI=
ZE * BITS_PER_BYTE' failed.

It appears this error occurs due to the apparent 16-byte 'NFT_REG_SIZE' lim=
it.

contents of /etc/nftables.conf (run in dash shell Debian 12.9):
-------------------------------
#!/usr/sbin/nft -f
flush ruleset
table inet filter {
 chain filter {
  type filter hook output priority filter;

  @ih,0,136 =3D=3D 0 \
  accept;
 }
}
-------------------------------

/etc/nftables.conf:16:13-14: Error: Could not process rule: Value too large=
 for defined data type
 @ih,0,136 =3D=3D 0 \
            ^^
Again, it appears this error should occur due to the 16-byte 'reg-size' lim=
it.
The error is printed differently, or is encountered differently because the=
 mask length was divisble by eight.
I believe that the error messages should be similar;
"Mask Length greater than upper limit of x bits" may be appropriate.

What is the best method to view the values of "NFT_REG_SIZE" and "BITS_PER_=
BYTE"

sunny
