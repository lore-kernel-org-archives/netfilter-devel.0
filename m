Received: from smtpdh20-1.aruba.it (smtpdh20-1.aruba.it [62.149.155.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5812C217F31
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 15:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741361514; cv=none; b=T2Y9HDashsQoCW6ss37MJ3ZKikwUTOqoqv7gyXNWBsVqEsb+cEUAxpeA1cDOzYbhf4wChlNXV94kVdFcyPZzpB+J6qcip05UO4sW+dyJ81LAHIr3geKA1LrW63ec+roPn7fj1Lrx/195yEnuHY15Kchd7SIffgBhTrhmeW57SqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741361514; c=relaxed/simple;
	bh=QVcK9jSQ7mTy6qLNXTYNHcm0ovO5q99KjSqr/Gh05M0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=AWmqe8PYCxKyQk7rNFOPghn5qJIKg/Ax4Efem9nSuvcfBo2fbC4I6IyNIkch+2WFOwPSBFsVyakwHTL4+LmLaqo0ZnfNk08DAusa4ctxwsFBtJlJe7TcFnw61G4FWnatVd/vTErRiKS7plm2YNnFIq3ldtoOEJY418YUwpLBnuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=Ut7+G2yl; arc=none smtp.client-ip=62.149.155.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="Ut7+G2yl"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qZfvtn5WBqg4pqZfvtLXaI; Fri, 07 Mar 2025 16:31:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741361508; bh=QVcK9jSQ7mTy6qLNXTYNHcm0ovO5q99KjSqr/Gh05M0=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=Ut7+G2ylpgSSu2EbNzvfJlMnyZDZP7XkCuqfrtAsMTJpVS/gAEEflu8FbZMl0+Uwp
	 wOPmLCzM84WxZ9eGEIsc8PM+MHEgiZ4XUg6zwmCOtMKH7aeVAPyx8tOZK6TBDrajQh
	 NkgMwL5Y0I9Tx/XKXexlWs20P66Zk1M1HgESohcXkP4Rnow1cnKcQdeoFEnNFUvO/L
	 5l2ZI5QHxK32CaJnTpcxZ2toAqcElnQ9BUnTi2AnZLFNzrDQT6wi40fL3bk2gLUb4O
	 DYCgBUSQGqrEtHQSsCVoXrDlOQ6TjU1j9+iKJYP+Fo5lqaMHGkD+tCIZA/F+Zqj1AM
	 FP5BUVhY/pJdg==
Message-ID: <1741361507.5380.11.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Reindl Harald <h.reindl@thelounge.net>, Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 16:31:47 +0100
In-Reply-To: <d8ad3f9f-715f-436d-a73b-4b701ae96cc7@thelounge.net>
References: <1741354928.22595.4.camel@trentalancia.com>
	 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
	 <d8ad3f9f-715f-436d-a73b-4b701ae96cc7@thelounge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfO/cfWa3jlPEjef5T2m1Im+1Jxodsyt+8uOSylJwQZjvAA57sa4Sb7JDtCtiEXl5L8W3sLKA0JrLgsC88yxH+Uk36qBY+QcZlf3lMQsHuTK3wi7k/Wbo
 2Ei2UYtYbD6Gzq0UZn4E3Dm8l+9sauOAWrZu0t2ppS+0P4ErAcimJN8FzN6gEoYHw4PbEjknHkdb6IclQ5/lvpgNZp9/NaSNKi33ysZeIM5+HdQHftQyo1Zw
 lBg28MxMDBzmiTqbXhQj/0uqaEi8gBOirALdxOKyVGo=

Nowadays FQDN hostnames are very often unavoidable, because in many
cases their IP addresses are allocated dynamically by the DNS...

The patch is very useful for a desktop computer which, for example,
connects to a wireless network only occasionally and not necessarily at
system bootup and which needs rules for IPs dynamically allocated to
FQDNs.

Guido

On Fri, 07/03/2025 at 15.48 +0100, Reindl Harald wrote:
> 
> Am 07.03.25 um 15:07 schrieb Jan Engelhardt:
> > 
> > On Friday 2025-03-07 14:42, Guido Trentalancia wrote:
> > 
> > > libxtables: tolerate DNS lookup failures
> > > 
> > > Do not abort on DNS lookup failure, just skip the
> > > rule and keep processing the rest of the rules.
> > > 
> > > This is particularly useful, for example, when
> > > iptables-restore is called at system bootup
> > > before the network is up and the DNS can be
> > > reached.
> > 
> > Not a good idea. Given
> > 
> > 	-F INPUT
> > 	-P INPUT ACCEPT
> > 	-A INPUT -s evil.hacker.com -j REJECT
> > 	-A INPUT -j ACCEPT
> > 
> > if you skip the rule, you now have a questionable hole in your
> > security.
> 
> just don't use hostnames in stuff which is required to be upo
> *before* 
> the network to work properly at all
