Received: from smtpdh20-2.aruba.it (smtpdh20-2.aruba.it [62.149.155.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5772223F40D
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365609; cv=none; b=D8PNuedP0qYfWe/dqB4sC1EU7fsxtKLsFRxHf/GR08k31VdjdeoffnkS25wXGnWsKNjOUuYu5B4paNoU9qR4zhWMid5PpHEKSxN6nNckD2uMouN/o554UOE722wEm7U1TCED8p1ozlcqBGnnEq3gr8KIXn/Pm+hQ41AencfWDJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365609; c=relaxed/simple;
	bh=fs9J5RxC60LTsgGuc4cKLp0EqH10cwNpdC9q1N655TY=;
	h=Message-ID:Subject:From:To:Date:Content-Type:Mime-Version; b=tUTHYCRTRDwmAg4Q9oxB3z32xD3QZrnlIqyZyXkth0kQlbIm0aOiS+BXVgYNELzO5tVkmYbyRJEMtJqJs9GtUnuAQiY/zxPizmpWmc167OzysrGKZo8iDN8VPigYXVDgfnB9SCVraxaMGyohozORqXyjtHi2YArLDH76IyOjZdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=U84cIpd4; arc=none smtp.client-ip=62.149.155.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="U84cIpd4"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qajyto8Ppqg4pqajytM4W3; Fri, 07 Mar 2025 17:40:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741365602; bh=fs9J5RxC60LTsgGuc4cKLp0EqH10cwNpdC9q1N655TY=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=U84cIpd4jG3b4gpWDDQbRdv01pyG3brg28VdHqnTsa5XenG9Fvt2QZxpCg2NXDXcw
	 YttV3h/HFRPfBax4kVCd6bk9/7m6ew/+xRsKhx78oyivcIrEQCoduClFaPF35gEo8Y
	 A1faE1ukaoO7x8mWO5cykShIC18vt7x3JGB15EwYv4t38WLa76eiwEZo7Wj/IEvbNf
	 APe9SF+zM+E2soBlEtaiUvRO53oR5R9Rg5BxkZL+DZMSOv1UO9qQ0fo6kgcRVqNc9M
	 BNvLuCbUzRqNzkkfHenTecfZK2SAtcGpvV0ad+Kb7aJ9CUFt9Pw3LqqLr2GNr/pk3r
	 3VMSSvzlWHNqw==
Message-ID: <1741365601.5380.19.camel@trentalancia.com>
Subject: Signature for newly released iptables-1.8.11 package
From: Guido Trentalancia <guido@trentalancia.com>
To: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 17:40:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfEawtGGCT2VMLnTN4fBROl7POaZ6zX4LNLPnznJ+xskeytbBCG34esRfMEUcIBBjrFVAj4o+3xw8J+6SHQOsRqr+cLka1UUeRNw+1PHoWpCClJqKXYMF
 SYWqFNDMuhQAkR0qbkuwdPDhKyroUmx2J1IcRnczvR8Dmsvi8A3Hr30ccBv5lE++tw2BXybfghSZz8i/a6BMGw0YaUnBw6C/Zr4=

The newly released iptables version 1.8.11 source package has been
signed using a new gpg key 8C5F7146A1757A65E2422A94D70D1A666ACF2B21.

Unfortunately it seems that such key has not been published yet on
public keyservers.

Can someone please publish the new gpg key used to sign newer iptables
releases ?

Thanks,

Guido
