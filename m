Received: from ellsberg.gnupg.com (ellsberg.gnupg.com [176.9.119.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B531D79F2
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2025 10:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.119.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745835454; cv=none; b=IuwWPzFn1mx6d4q61E8bd+IRJKEOZQtxz1/CdBdRhDWCrvm9JptHAtnBgABMg8djQh+A0ZnGM/BnPHqQogZfZu1mpj8mPxWBBtrdP0K1n+fAxCwkBRpzLZnmpOTnibbLx7uysPsezShwpfhokztLJtA/9YwnB0ngagsS1QLJJPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745835454; c=relaxed/simple;
	bh=XvRhTNzThpsEmwT6MwR9D+uWwykhWeNaIQ+b2YcCYhI=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=Phdv91KIttbvmp4ya39qygupGTsSVk497UgqkBlHmx2WM4FEtBzrJVmBfdiIh5JMuUIIDDWPNggl0+MN54IrAN8n1DHbe5G1HEbsUqIioScBuVy0S9/M3Olvd+Rjam1GqRfi7r8xpnLkR4q7t/Q7rc07mRcK+woAT3R8lIQuvZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gnupg.org; spf=pass smtp.mailfrom=gnupg.org; dkim=pass (1024-bit key) header.d=gnupg.org header.i=@gnupg.org header.b=D9dGqOKG; arc=none smtp.client-ip=176.9.119.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gnupg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnupg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gnupg.org header.i=@gnupg.org header.b="D9dGqOKG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gnupg.org;
	s=20181017; h=Content-Type:MIME-Version:Message-ID:In-Reply-To:Date:
	References:Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fGgotoWYsSPdzRpExurOjjVVXGnKqPQXvcuWJ9gr3ZE=; b=D9dGqOKGJ6YUUVDCIIMprMkcch
	XIadLmpwhwxhBkDPgTDahDJENX/Raqp8KQA2SzpI0ru3mmkUAaGgsBPcJunYboA2SANQvftwlyiY2
	SgeGxfa9G9LuZAISHaZ8xGJLMFwnInRGmDKhLZnqKWxGNb4Tw5TPX0yOnJa4h5XkibHE=;
Received: from uucp by ellsberg.gnupg.com with local-rmail (Exim 4.94.2 (Devuan))
	(envelope-from <wk@gnupg.org>)
	id 1u9KvB-0004Or-Ma
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2025 11:37:05 +0200
Received: from wk by jacob.g10code.de with local (Exim 4.96 (Devuan))
	(envelope-from <wk@gnupg.org>)
	id 1u9Kwt-0008Lc-2l;
	Mon, 28 Apr 2025 11:38:51 +0200
From: Werner Koch <wk@gnupg.org>
To: Jan Engelhardt <ej@inai.de>
Cc: Florian Westphal <fw@strlen.de>,  oss-security@lists.openwall.com,
  Sunny73Cr <Sunny73Cr@protonmail.com>,  "netfilter-devel@vger.kernel.org"
 <netfilter-devel@vger.kernel.org>
Subject: Re: [oss-security] Re: Trailing dot in Cygwin filenames [was:
 failed to clone iptables,ipset,nftables]
References: <1EYtBL_6T4QRNdyaUOoY2OO_FLzCtCfv4Q7gBf28RHR_k_LB-t0IN5R7v12bgaOOSKputo826H9PZ-2EmksldVLnGVoXyMQVemTy3tMra10=@protonmail.com>
	<20250425062231.GA7332@breakpoint.cc>
	<sqo7nqpr-151q-4sr4-1o40-r95r62179s29@vanv.qr>
X-message-flag: Mails containing HTML will not be read!
	 Please send only plain text.
Jabber-ID: wk@jabber.gnupg.org
Date: Mon, 28 Apr 2025 11:38:51 +0200
In-Reply-To: <sqo7nqpr-151q-4sr4-1o40-r95r62179s29@vanv.qr> (Jan Engelhardt's
	message of "Fri, 25 Apr 2025 09:46:15 +0200 (CEST)")
Message-ID: <87sels7hhw.fsf@jacob.g10code.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=Plume_Standoff_Security_Evaluation_H5N1_UT/RUS_computer_terrorism_ID";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=Plume_Standoff_Security_Evaluation_H5N1_UT/RUS_computer_terrorism_ID
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi!

> But Cygwin does something unusual, it *actually* creates a file with
> the 2-char sequence "y.", through whatever means. Explorer *shows* it

  C:\Users\dd9jn\test>echo foo >x.
=20=20
  C:\Users\dd9jn\test>dir
  [...]
  28.04.2025  11:30                 6 x
                 1 Datei(en),              6 Bytes
=20=20
  C:\Users\dd9jn\test>echo foo >\\?\\c:\users\dd9jn\test\x.
=20=20
  C:\Users\dd9jn\test>dir
  [...]
  28.04.2025  11:30                 6 x
  28.04.2025  11:30                 6 x.
                 2 Datei(en),             12 Bytes
=20=20
Thus you can create such a file using the Extended Path Length Prefix
which bypasses the mapping used by CreateFile.  For detailed info see
also

https://googleprojectzero.blogspot.com/2016/02/the-definitive-guide-on-win3=
2-to-nt.html



Salam-Shalom,

   Werner

=2D-=20
The pioneers of a warless world are the youth that
refuse military service.             - A. Einstein

--=Plume_Standoff_Security_Evaluation_H5N1_UT/RUS_computer_terrorism_ID
Content-Type: application/pgp-signature; name="openpgp-digital-signature.asc"

-----BEGIN PGP SIGNATURE-----

iIMEARYKACsWIQSHd0YfKgdOvEgNNZQZzByeCFsQegUCaA9Mqw0cd2tAZ251cGcu
b3JnAAoJEBnMHJ4IWxB6GrMA/1ErZrryPW9I5PzDBEP7qnTm6CmvHb1XTGpPCYY3
GzkiAQCspnhUjJls8OtNEQQGp8EQBS5QK658mrVqCDJk+3XACw==
=L7uo
-----END PGP SIGNATURE-----
--=Plume_Standoff_Security_Evaluation_H5N1_UT/RUS_computer_terrorism_ID--

