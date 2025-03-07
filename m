Received: from smtpdh20-2.aruba.it (smtpdh20-2.aruba.it [62.149.155.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65F821CA1A
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362382; cv=none; b=D2tUEexJ84gAJNyoKvFtMMAKISLyMmfKWLgMxXV5AHRIKWUgj9oi9XEvaGpIKJoXhePM++5lL+WHaRGeBjeP4hcybfXbAjspG9ncMmriHwlM7/ERfOxpPHyALc8Q66/GumtmQpD4mtQmj5rRE0kfzOIgMFg0Xzhed/pYVgWNsOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362382; c=relaxed/simple;
	bh=PEjop6FEYoeXQgYKy0v1FCV6QlpQUQl20FOw+fLij38=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=fnwFqkSL1eh6ZbideOwsrHd3Bmt45KDWDMuQ3hygkyDYtUQyHXNn+pz+P777ONRaYEV8br/1x3I4/hzDHiCNUO8108nmTiT0crCsqdBvJRNEi2vuRRdYCoDCgHkvQdgwOeY+sLV/+Nqn5slP68H4QNQFHZ2LbBYlnoIpX3D0sOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=PPcuMIIe; arc=none smtp.client-ip=62.149.155.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="PPcuMIIe"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qZtwtnJQtqg4pqZtxtLffd; Fri, 07 Mar 2025 16:46:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741362377; bh=PEjop6FEYoeXQgYKy0v1FCV6QlpQUQl20FOw+fLij38=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=PPcuMIIePEvu80evjTxi5Hk2wvFHaaz6QXZep3pk/AeE+L8ZFFc4eqDBaT+ylOvq5
	 c3YjKtzoz+WY1Fzx3ITZUachDFEsC5BQdyqO6ZKx7jcX+VsxfxMgMLvFr+GruSu8S/
	 azC2mvl8+lxnTjqo6/zd7TJj04YG5IstOwWa23cCPZumi2G/QHJognmpe3bVHh3OeJ
	 EyCL5a/YaKR+uqRBg9bspOACprNyc20DRYU8hniWANCgmJnlL16ZHER6Nktt5Yzwgq
	 N3+KBH19lJLNeqW3GRmaA1R3ZfVsviQ3UyLsIYzaW++EGF6IC6bzdKSrFd+aPQo1hz
	 go7SLSBcfiIJQ==
Message-ID: <1741362376.5380.16.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 16:46:16 +0100
In-Reply-To: <1741361076.5380.3.camel@trentalancia.com>
References: <1741354928.22595.4.camel@trentalancia.com>
	 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
	 <1741361076.5380.3.camel@trentalancia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfCIfIXi7aPFb+5smV6gxaglv1tNSfDawKhKqtd2PipGkMaqpH3Kx1lXOaP1wqyDaQCIKuWJH1rUErd+CatwQvEvEMBjmAtIzKm757zNMCP8tPdbq0rAM
 4GMpDVWQIJf1ub4SRxySkPSCkaoYqm2QcJHAo+qw5F9i3xxnMWG+Hp/2eVqVQ/uu0oceM0rvbbSL67QPVGsKr+gVYuszZTjUhmO0kBBQmdhkEAE9MSoc13dD

I can give you quick example of an hostname which is allocated
dynamically in DNS: www.google.com.

If you perform:

  # nslookup www.google.com

then you will obtain a different IP address (or different multiple IP
addresses) each time you run the command.

Given the above, any iptables rule for such kind of host will need to
use its FQDN instead of a statically allocated numeric IP address.

I hope this clarifies the matter.

Regards,

Guido

On Fri, 07/03/2025 at 16.24 +0100, Guido Trentalancia wrote:
> Of course, if the DNS is not available the "evil hacker" rule is
> skipped when this patch is merged.
> 
> However the drawbacks of not applying this patch are far worse,
> because
>  if the DNS is not available and some rules in the table contain
> domain
> names, then all rules are skipped and the operation is aborted even
> for
> numeric IP addresses and resolvable names.
> 
> Finally, consider that nowadays many host names are allocated
> dynamically and therefore for several hosts it is not possible to
> enter
> their numeric IP address.
> 
> I hope this helps...
> 
> Guido
> 
> On Fri, 07/03/2025 at 15.07 +0100, Jan Engelhardt wrote:
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
> > 
> 
> 
