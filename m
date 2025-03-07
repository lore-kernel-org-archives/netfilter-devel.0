Received: from smtpcmd03116.aruba.it (smtpcmd03116.aruba.it [62.149.158.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8FA23E338
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 16:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741366771; cv=none; b=kiAuMqAbRKmcEPD3sv8HtIHG2l4fsAoPHid2C9TLSuh3k/iQ7AjrORwLxTcIxNSzN0/uom445Pg8Qs8HfIVJ+uDmFH7cDVtN0lZWmVGeU+qPkOKPSLs2v2GDLjn9toLaIZsW9HXuEskTeDTjJbk1fkiwJMF3qlY96Fl5qyi9oug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741366771; c=relaxed/simple;
	bh=Lj0s33zchuZjo4LIT2AOCPUcPlsY6eRShwf5LqI3bF0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=qzATjtuhgxaHGOBVs0Fj0fPsQbNtNrXpKbaRhojCEQSLeNFfSkLdxJbsQoiZA1D00+F+M9yOt/Vvj9/QeHCIngSzel3r6umayBpn1mxW7Fw5gkjUvwnYGIs2Qi+L8Ja+z2ynSpwseWvpNvGsklX1R4wtmAwjVzD2D8AlPRyv/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=b27fCrbB; arc=none smtp.client-ip=62.149.158.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="b27fCrbB"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qazhtOirsmHkSqazitVo84; Fri, 07 Mar 2025 17:56:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741366578; bh=Lj0s33zchuZjo4LIT2AOCPUcPlsY6eRShwf5LqI3bF0=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=b27fCrbBj+jdseve1ScPCvjn11eIrj22Ro9t1Uv/7ebJtOe5RmBdBwXv+CS4im/lh
	 O9y8KgKYbDe3q/qJc433Ez0UAy6/L3XHx4WNEMFQoFoPt+hiSGHGnHmZcY2RRalDlK
	 Zz79UvESVQw4yz38mgzt3cDyYG7jyKoMRftpWqfUwbxCBtT1U6uIJ8QU26ERKqyC96
	 U+OeNtXcZ1l9gP5MUL6QK+do6ZF7ZLTol0gXjxKQtlaIRSmIn/dLu1baJMZeNwJ9U5
	 sR+tI+PYzKDmD+Ezch1W6gwirmBp1RM1eAqsFJoutQewHYG/EucQYiQSt8tl0JYYlk
	 DS3HcjQv87VSQ==
Message-ID: <1741366577.5380.21.camel@trentalancia.com>
Subject: Re: Signature for newly released iptables-1.8.11 package
From: Guido Trentalancia <guido@trentalancia.com>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 17:56:17 +0100
In-Reply-To: <20250307164948.GB255870@celephais.dreamlands>
References: <1741365601.5380.19.camel@trentalancia.com>
	 <20250307164948.GB255870@celephais.dreamlands>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfBD2uYBXWRBmEux9QyJkthqaQl5sx4VpGjoMs78uGm2/dGu/wESDR0gJkUj1lnBKYl2CAYSu1MNgBuIedtw//etFnLs2UJVZLs9iG+CSt9iBufHyOBP7
 tIVAGTnBeQ+Ms/TkX7hUFqwlMsyVP+EIYtGn1EUTgqgZr/zJPvcX2tTss6uS2zLnwnnnUaoRCaFwbuHK6hKdr0gLWnq1Aom14F7YvNg4S4hxyDaqBflxCnMa
 /d2LzKjzxXkGjBfocjQXww==

Thanks Jeremy.

Ideally the key should be also published on public keyserver for
maximum efficacy and security.

Regards,

Guido

On Fri, 07/03/2025 at 16.49 +0000, Jeremy Sowden wrote:
> On 2025-03-07, at 17:40:01 +0100, Guido Trentalancia wrote:
> > The newly released iptables version 1.8.11 source package has been
> > signed using a new gpg key
> > 8C5F7146A1757A65E2422A94D70D1A666ACF2B21.
> > 
> > Unfortunately it seems that such key has not been published yet on
> > public keyservers.
> > 
> > Can someone please publish the new gpg key used to sign newer
> > iptables
> > releases ?
> 
> It's here: https://netfilter.org/about.html#gpg.
> 
> J.
