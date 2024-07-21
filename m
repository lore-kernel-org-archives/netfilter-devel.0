Received: from mail.redxen.eu (chisa.nurnberg.hetzner.redxen.eu [157.90.22.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE076FD3
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2024 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=157.90.22.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721568855; cv=none; b=VVz5R5i0hLQ/LlKLsphnknINRs1sbn7qKbGNsZggwBXqYV6YXzu0umFX+pTnyZahbtQK1IiH45zPHdb9BZdN7Z8O8jw4YNeYJF5dnQCa33sz4c1M8mD4d40DSkWMEK6Y/hNZEKRlSB6vYVUQ1Icp5p8b8jvtg9xBPEAiMSzIaMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721568855; c=relaxed/simple;
	bh=tKVhLg0NIvWmImqW2U1rfr52pDfGAC/fy0mEzW00kxU=;
	h=Date:To:Subject:From:Message-Id:MIME-Version:Content-Type; b=hXjLrF6hOREKEYDUPe2KTB/43DaVv13cMQP/+Lsijlh2kQp2Lz0MPldkRRStSjnVzi6nsx0KdL5+pnVwERQjFErQf/Df5cKe/ezVqKR3BlBg+wShgako47grQvLzzHY7pTkQBpKWB+yrI4dnAbw8p6HPtpqwIdt1GGp/sa2PZNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redxen.eu; spf=pass smtp.mailfrom=redxen.eu; dkim=pass (2048-bit key) header.d=redxen.eu header.i=@redxen.eu header.b=fHXONmWF; arc=none smtp.client-ip=157.90.22.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redxen.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redxen.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=redxen.eu header.i=@redxen.eu header.b="fHXONmWF"
Received: from localhost (karu.nurnberg.hetzner.redxen.eu [157.90.160.106])
	by mail.redxen.eu (RedXen Mail Postfix) with ESMTPSA id 260005FA8F
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2024 13:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=redxen.eu;
	s=2021.05.31.01-mail; t=1721568406;
	bh=tKVhLg0NIvWmImqW2U1rfr52pDfGAC/fy0mEzW00kxU=;
	h=Date:To:Subject:From;
	b=fHXONmWFiFbJ+5R7Ix1Ll2k6EwCiUAcUHCiLgDqgAYLdQWIi1v/GuhWkfGDznoqL1
	 87F9prR1sKxrbBiLydZPmPzaZMx5SU/d/A8g09+UUnwT/qFXCPx7NV6GIEzTImIF3t
	 eLi5z+s4mrJCJjdzZ26vNd0/yV6wN2jafISc3lFqPXH4VK5FpMg39j2Xu8XxJIy+2h
	 nwqj1Cp5V8KeHdenQyBXc+BaNfjQoqrloSjWUkF1Q3zoABK5XawXpqKVyh9LLSkuJM
	 jwU/RAuGl+9hnGpgoZVeWmg9f8AqASYoIN5xq745/MFfqhp+RXmv/Ll0+d8eu0Op+p
	 Iwa+TeltlYyrQ==
Authentication-Results: mail.redxen.eu;
	auth=pass smtp.auth=caskd smtp.mailfrom=caskd@redxen.eu
Date: Sun, 21 Jul 2024 13:26:44 +0000
To: netfilter-devel@vger.kernel.org
Subject: nf_tables/set: Is dynamic + interval possible?
From: caskd <caskd@redxen.eu>
Message-Id: <21LESCW6FS1QS.25Y6ZY142CF7D@unix.is.love.unix.is.life>
User-Agent: mblaze/1.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="----_=_7d5f40d61807f63c60e7725a_=_"

This is a multipart message in MIME format.

------_=_7d5f40d61807f63c60e7725a_=_
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_2e510a546a4acef255ae7428_=_"

This is a multipart message in MIME format.

------_=_2e510a546a4acef255ae7428_=_
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello members,

i've been trying to set up a more dynamic table which can also merge stuff =
and additionally accept administrator entries to the filtering sets.
However, i've been unable to mix dynamic with interval as the kernel return=
s a 'Not supported'. Is there a configuration option that needs to be enabl=
ed in the kernel for this to work or is the code just not capable of handli=
ng this mix? Thanks.

Example of what doesn't work:
nft add set inet filter blackhole4 { type ipv4_addr; flags dynamic, timeout=
, interval; }

Example of what works:
nft add set inet filter blackhole4 { type ipv4_addr; flags timeout, interva=
l; }
nft add set inet filter blackhole4 { type ipv4_addr; flags dynamic, timeout=
; }

--=20
Alex D.
RedXen System & Infrastructure Administration
https://redxen.eu/

------_=_2e510a546a4acef255ae7428_=_--

------_=_7d5f40d61807f63c60e7725a_=_
Content-Disposition: attachment; filename=signature.asc
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJEBAABCgAuFiEE2k4nnbsAOnatJfEW+SuoX2H0wXMFAmadDJMQHGNhc2tkQHJl
ZHhlbi5ldQAKCRD5K6hfYfTBc3xJD/9XwVP8qD9qwCHP8E9mKEbHwdHofdlycMao
VSvpEgfRX1Wnl1asaNJGYJ+tl0PhiGCk55awa728UH7L8Yd7ea6JzLs5rh5wFYQ0
Fa62HvRzZAgN8r0z8+2ycOHuTvIFuxUl883B+ctH1KuZf8gm0J+6rTzHVonMULOS
F/IEp2hsimt2c+t4QSDW6x0bbhg70PpR8/waxlUTv62jJMThQdwXl/kIeWsaK5+2
9Ih3fcYoZoMaYKrUAjHMBIej0SSvypX36dfSaXOEZTMNyo9hJ/rQpg04ABS2gePI
4Fxwn951T2c/5Uv2prSiItFdGIraPLkJTsyVqug679PfAL6m4mkKPd3YZFbinQaS
/+NxvpERgiXv47RJyGFe4PU2Y+dCsI4B9sUggC8zVOj/ZGZA/6G6r9KMuoJATWUM
bTt83bGMEMiEkSLmuqwZX9B9ZhsahIfROMsff0GBTDWsd4Va6CRShexJhg2y0vXB
5vY1nqxCZh23Jh/ygNl40fkMn1wk3evQMWc4hU/V7O/br3EkxRL1dI15JUpG50UE
+JGW9rh/R9LQ0MbRpvUQ+EAF45XS8BUxbjczG3d3am4KJ1FiCt23z+1v65fXlljM
mMPV48Tz6EJ8dweVF4fKVoB59v96g5GTgVbBavzMxkcISG+Yd4fZSd69rYnNKwvd
QOwKxKuRvA==
=PG5y
-----END PGP SIGNATURE-----

------_=_7d5f40d61807f63c60e7725a_=_--
