Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C81415B996
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713967924; cv=none; b=dfYMH83zlMLUN92yh/1Ep8IEW1+JCYTBszDQYCIHqNZt1tcwCVrHGKGvQkf8P38a3fJokXmoO0kLDd8hbZvI7FxGkUkHbDouDg4fTy/2BJcRyxxNEXJ8m6Ob7OIYinDlfPkJO0cZ1OaBNmTFTvZLCXTl6vt2qQAuYfiHhL+qA8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713967924; c=relaxed/simple;
	bh=mJ+50IOCK7lc7hh9dNJs0BApAI315qQxxfSFh1Gz3Gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ti8mEJAKSdH2LE53rddauPU7RQadTrzYXIlEt1w7WJCGfzNJb+VIxbOCtwwyJc13El1LIpjPG4sb8eV6++las2Ip3oe70OqWdZ6L/a40Jk3T2D2inVpWlqVAvezGTaQ5l9JlD13IqrvZtAsIuobVxfkrSXmOMBqt6tmeo+CDkNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=M+PdjAOz; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CNT0FJlH; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="M+PdjAOz";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CNT0FJlH"
Message-ID: <53acd1f2-92ed-4ea5-b7be-05d3a0f5b276@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1713967920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lpnUUSl6D2aOn8T+bNTnlRkD3auD5H6UCEz0dWS/dWI=;
	b=M+PdjAOzK/r5TzuZHOeG06EO/9qxCvFZVHxGwf2YlRNP9zv9Pm398mrLjSD17TqJiQCltz
	6ZuXlYkqY1skK0lW8L+5cwRAtLYQRFEzRIvoz6dn5LSnkvOmTZSNX0QjlNNRZC44VT3wQf
	wLredDK97g9m0cvUxeU5LwSDfYDzVjXE0MmEMSqIWYOf4/ZLWr/QxajKW830Uzzum/prqq
	psreEsGoouOLVZcfEw3zFSZZJCPfk/jlacmK+CKcMSgVbCeBG/68gw6bW2nVBod7klxcBv
	JTbUNTgpmjFwlG+XGKuTQL1HXMSY+F9/mWsExRnz/jUHaLqs9risB6s5irdJPg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1713967920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lpnUUSl6D2aOn8T+bNTnlRkD3auD5H6UCEz0dWS/dWI=;
	b=CNT0FJlH4DNaTgCFGcMW0+1uS+vGeElUi5rhjtFu4xDahbi+l8QEkGxd6sye0IFiyBRiz8
	6i9bVIjYP1d48aAQ==
Date: Wed, 24 Apr 2024 16:11:59 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [iptables][PATCH] configure: Add option to enable/disable
 libnfnetlink
Content-Language: en-US
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 Khem Raj <raj.khem@gmail.com>
References: <20240424122804.980366-1-alex@linutronix.de>
 <ZikA0v0PrvZBsqq6@orbyte.nwl.cc>
From: Alexander Kanavin <alex@linutronix.de>
Autocrypt: addr=alex@linutronix.de; keydata=
 xsDNBGHm1swBDADo+8UfTmQ2gV6TeJv11EvzlOgInBSbY8MyOgXjiakzu6C8AFE0j9JIbLWV
 uVsxDoFmFUgDHUCItXWibZ4hiHV5tHTWwUICcusgNdAuNUxpMZ/qV5IOEzuVEqcX9qLl13Qd
 SVxgJt+uC05g831Q/fCYTIheX8dsk+K/PkFCE6sYol5Q/KHXWv+M73QEo3pq7xYoZ333TaLO
 eR4mPz1jorqk8flRc7NCJb5Yrmigy0xBpf/CSW5Ux8lrwvOrz3zA8xHbSG4nUwGfzTK9GETH
 UcTsXYy3sq6YL7mDazQ2oLswBt6QD9XGnxTFDYoDU0ZlvLAj2+KjeX2+KbM+QjB6v2POYrJO
 mfQQUJoP7NyL4nEt3npnFVuGIvbsYOZwfsmdcwq8bQBIDJqrmbFA5w0EK3GGkRoLDXLK/+en
 TeCotmW2XShnCI8gWQjTpQv79Di3bV2ucBIvS56wTJqzKoSb/1K/2q+W7P7yLTO8fOYPc97E
 I0yyznjSsxRSjZajqHWG8DUAEQEAAc0mQWxleGFuZGVyIEthbmF2aW4gPGFsZXhAbGludXRy
 b25peC5kZT7CwRQEEwEKAD4WIQS0m1Lg1L9/kNpscyOI0ieG55SfbQUCZap1fQIbAwUJDSt7
 JAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCI0ieG55SfbbFqC/0XNFFfMQaWSvBWDUv5
 XveguKMH7Ac7uOq+kSDI16BBVQtV67VqAO7geifLiXOjejejvvtk/CpEa0SBfxi2FS9qt1GR
 73Pa4cfIRUhnp5lS7oGvkJd22y26r9lATwtEwOXmkTUahePHvzkS2ZvL9K0aWW10VR6ByhfC
 Pq5UkDdkEqwxwNqygv8ajvMvjcSgJNA57QNi1Z+S/kF2MmBLMffS/SFuPazi+++bySRfxUrB
 dZa/e7lt0U2/dMzURZM+HkEyyMKAJUDWuR7UQab6zv/9UmjHhq/h7DTQ4Cj0uWRBQR16M+4V
 QqxW0tzWhWKwFbfTGiWh0FsuBffeQ1SyrjtpovhFlYmNzL5tnlfNm1iE6MPcDDDsgu6D1oVc
 Er6X3JhhHoBxFFWyQZKAxzsDqlcNtDzVimbLxcAAseLMO4u0yjcmU5onIxAjPGJlp8cR2kvD
 xJCqIGs8jOnY2JzeQ49tQZZh5qOAGPRplwt2fESR+kOcS3Mp3NMb6/6yqk6G2TPOwM0EYebW
 zAEMALaOKBsfqdmBHJL7h7Hfe292bmlAGuQ9JL/z+PUGk9FDAl6+buJc/YP4LYDSTsDf61Vq
 fZVrqMVGb46SbLkb/+blhzUVfaNJaViyvhnYC4UyO8pAb19jPsxlD9HN/w0nbZCwcIJYQSh5
 6khm5JXWtrjCtbp5HAQComiiSnZqS7MMB8vScGqKYutumtjpsdn/dWiQ2vwjwR+gDSZWGjUP
 vDCONdOhfDFQo0UvRmRlEk7ZJs/EuPDI17EzBfnZqgudbvI4uPutOxiCM+5IIMgwQUIK3qkU
 E7HwHtdUU/LWYR7LMVh14mr4BZJv6k5JpwrfQ1Sl9SzhfXaelOwso98KpJPah86cDFPbhqO+
 c4Cdktjz0jhrUBprVC3Uo14pxNZo/1MWAhWKGVSaYTa7rVO1EPZYEttOUVcUbF5d1ykd/jps
 md02kLKjC2Wxpr5r2JImkjbMUCyvGScXlAKgZMpaTkCulatk5gHClNT10Gt3CaOVR496OqgL
 RFj0oMDHi/+zRwARAQABwsD8BBgBCgAmFiEEtJtS4NS/f5DabHMjiNInhueUn20FAmWqdX0C
 GwwFCQ0reyQACgkQiNInhueUn238qwwAm6W0Wyqv1FKG42M8L88JIcAkoIzMJk8lEze7kYvu
 86ssIyeyRUMlmhUDPgy4nZ/XI2fCQgPdhebD3183Id1A98hvFPFmj0oGEayCihNI+h+8/dKL
 xZHIhiDoHriaky5D+yPzk4ivSu2DKPA3NbOzuw+HVKM+wC+6yIyXVXdPQ2E5DJ6jpmel00ql
 HuJcxukfCZmtSfw/2JK4Oic1LSuhud4wXKw/EU4lzeYnImvxXmXkJ3rdc6pvx5Qwqd9tKnhg
 R3wNeVoaGDsPSXzMNP8VRiCJdgUVodbU6y1BoLipd6vgAJnMFDPgrO5CkfyJb1yMxQzHXpBi
 +7CvLEfG9J6XkzAnHqOokSr0ClkQxQzfta3rcsud6jz/ODK6/E/hP7OFtCipLZxGKee5WuOn
 K2geqlXklrg4sd4KQnlx2TDWH08efmSbOTKv3Bk91mpWNyXL3lHjobu8m0uFEbyB6YFl+4Aa
 AZORzWv3Jz9i5e+OFrknq8GC4EyTHJ5B8gESI+bl
In-Reply-To: <ZikA0v0PrvZBsqq6@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/24/24 14:53, Phil Sutter wrote:
> Hi,
>
> On Wed, Apr 24, 2024 at 02:28:04PM +0200, Alexander Kanavin wrote:
>> From: "Maxin B. John" <maxin.john@intel.com>
>>
>> This changes the configure behaviour from autodetecting
>> for libnfnetlink to having an option to disable it explicitly.
>>
>> Signed-off-by: Khem Raj <raj.khem@gmail.com>
>> Signed-off-by: Maxin B. John <maxin.john@intel.com>
>> Signed-off-by: Alexander Kanavin <alex@linutronix.de>
> The patch looks fine as-is, I wonder though what's the goal: Does the
> build system have an incompatible libnfnetlink which breaks the build?
> It is used by nfnl_osf only, right? So maybe introduce
> | AC_ARG_ENABLE([nfnl_osf], ...)
> instead?

The patch is very old, and I didn't write it (I'm only cleaning up the 
custom patches that yocto project is currently carrying). It was 
introduced for the purposes of ensuring build determinism and 
reproducibility: so that libnfnetlink support doesn't get quietly 
enabled or disabled depending on what is available in the build system, 
but can be reliably turned off or on.

Note that we also carry a related patch which I didn't look at properly 
yet, but can submit as well:

https://git.yoctoproject.org/poky/tree/meta/recipes-extended/iptables/iptables/0004-configure.ac-only-check-conntrack-when-libnfnetlink-.patch

-- 

Alexander Kanavin
Linutronix GmbH | Bahnhofstrasse 3 | D-88690 Uhldingen-Mühlhofen
Phone: +49 7556 25 999 39; Fax.: +49 7556 25 999 99

Hinweise zum Datenschutz finden Sie hier (Informations on data privacy
can be found here): https://linutronix.de/legal/data-protection.php

Linutronix GmbH | Firmensitz (Registered Office): Uhldingen-Mühlhofen |
Registergericht (Registration Court): Amtsgericht Freiburg i.Br., HRB700
806 | Geschäftsführer (Managing Directors): Heinz Egger, Thomas Gleixner
Tiffany Silva, Sean Fennelly, Jeffrey Schneiderman

