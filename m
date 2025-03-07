Received: from smtpcmd03117.aruba.it (smtpcmd03117.aruba.it [62.149.158.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C80218AB4
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741361271; cv=none; b=rO+0CdtyqCMIeXp7HZBNin0JR9lfrr5TjQHR4inrgjMaoOBv+Y10lm754av96KR2gx6m6orArb0cfQ3KWfUxXC2sG/oUseMOwzKDiiiFGx1Ih9ujFcbNVCYB8OIXf6gjTH8Kkl/apcRaIVYw3nSox+4Q/e890icgIHyMlhY16mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741361271; c=relaxed/simple;
	bh=m5f8mIDRFdW9OKcfCCmDCjfl9SFua2rPEB/5LNhrqIY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=jraUaQ0/jh1+1icSlGn+DchSKzPNFZOpg/4ZkZug6XMT+zI96OmQIWbcQr25ED1a/VD39j+oBmFZxwE9XZk3dIw5NRYnVHm/svQjzxYjFu42PFjoHuwwDwAqi0CL0foS/TVtw28UfgxfOBexLyflZaW8tqzfrmVmH3GOrxMr2fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=UV3MG8xA; arc=none smtp.client-ip=62.149.158.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="UV3MG8xA"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qZYytN8AcmHkSqZYytVBCk; Fri, 07 Mar 2025 16:24:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741361077; bh=m5f8mIDRFdW9OKcfCCmDCjfl9SFua2rPEB/5LNhrqIY=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=UV3MG8xAY049hwhje9nQs1TWp0OZDj/khgJ7TUumaFmzjYkS0wLYl0OC41pgqP5C1
	 u4Rp47SeciX9/hbvIFAskIm/8ngZknGZFsrSYvi4QtLD3PPi5OWwe/Gj+imvcpqdjC
	 +HUYPANmuGp6LqC8hCMj7Cg5GkQmlTVv9ka4sWab2qpGaMYWGlq07eOMNOvXEFT/+8
	 Vk6lHBmYCPe1KYg7YPqn8PldXhHfgPvUIo3WY/7oe07WNXGZoWC4n9L+1SfpDn1cny
	 c5Y/TwBCabOgAzyT006s3rGO/PpQoS89bFS6kM/Rzlx5FmuuaMdhBSniByvw6U7vPE
	 +Z4HyHCzS8WKw==
Message-ID: <1741361076.5380.3.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 16:24:36 +0100
In-Reply-To: <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
References: <1741354928.22595.4.camel@trentalancia.com>
	 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfPiNyBFn6R5hP2T/IKpkEQxV4NbwVeNmy3C/Z9zTCE9wshoKVdJJsHksGE79nok4JFti9SctUs0HCOmZqQ7Z0QhZ/DxUSIJeqUdiypXZrkmXGfiCAiYl
 WoETE8a5GqFyGw/2T1f9vvCJ77wKlitQv+7G+vdu4yv72dIQlDvq8e8b255GDSv8tUSVjdVTLAlbAfcD3ezh4dsZhex8jRB3Yi1OMwnfNGx2qP45LDkki/Mc

Of course, if the DNS is not available the "evil hacker" rule is
skipped when this patch is merged.

However the drawbacks of not applying this patch are far worse, because
 if the DNS is not available and some rules in the table contain domain
names, then all rules are skipped and the operation is aborted even for
numeric IP addresses and resolvable names.

Finally, consider that nowadays many host names are allocated
dynamically and therefore for several hosts it is not possible to enter
their numeric IP address.

I hope this helps...

Guido

On Fri, 07/03/2025 at 15.07 +0100, Jan Engelhardt wrote:
> On Friday 2025-03-07 14:42, Guido Trentalancia wrote:
> 
> > libxtables: tolerate DNS lookup failures
> > 
> > Do not abort on DNS lookup failure, just skip the
> > rule and keep processing the rest of the rules.
> > 
> > This is particularly useful, for example, when
> > iptables-restore is called at system bootup
> > before the network is up and the DNS can be
> > reached.
> 
> Not a good idea. Given
> 
> 	-F INPUT
> 	-P INPUT ACCEPT
> 	-A INPUT -s evil.hacker.com -j REJECT
> 	-A INPUT -j ACCEPT
> 
> if you skip the rule, you now have a questionable hole in your
> security.
> 
