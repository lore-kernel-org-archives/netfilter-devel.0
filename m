Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCB2183CB0
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 20:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741380052; cv=none; b=MMRCQcLm1FmJeFVLZAGsOUgxi+KF2o7vfHas16ORGU+pyWYtBoeXf7zX0uDITqZT2SAX3NvO1oMbmRD8cCzIzfkrPjlkhwaG8SH6pm3jFVAeCY5Hk/L8eFO6oGQoNNO4muOU1nfr9a2eKYHV0dKagyJLeN8MM9MjG+7DYLgFIC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741380052; c=relaxed/simple;
	bh=bNNGJD2IADGnl3I7wVlneaky0nx1dwLJK//UEdd7K0U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=JcRMmhc22YfzMRMBgtqshInvV7VDM6GaBXUZZmL4gWE//xSv2N5OirO5w6Ucti2PFtw0PyyEkqGc4/gqNefGJqkRoSrx1GPA9QrVEpTA9ZivlPuttdb/Z6p1L4PpcABtglFX34TOUFVrdBg+HzIcT7M2Tv1ehl5GitZ9OA5U/XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=e26q6Ggm; arc=none smtp.client-ip=62.149.156.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="e26q6Ggm"
Received: from [192.168.43.2] ([109.54.115.5])
	by Aruba SMTP with ESMTPSA
	id qeRstetubS934qeRttS4hs; Fri, 07 Mar 2025 21:37:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741379857; bh=bNNGJD2IADGnl3I7wVlneaky0nx1dwLJK//UEdd7K0U=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=e26q6Ggm73AsOGoiVaE54lKD3ObxZd77GivZV6CkcbOjiks334L2QreD1XzGECXpt
	 17hbKZICOrEF9G1QAXV0XyDami/cKuU9/p/rFfHnnkKLSSIs8mOWl3oOjZgpV2XjFM
	 enGh+9zhTqx1EAJHb5saWD9wPzYdJXxW/ezxS5sKnKgJe+Sv64SK7a7enXyzx7gTIr
	 TY7DIA0O9YxiXxrMI131Kel2vO1iyWWCsQH0COUvu5nN5DVEYC+LDw9miMC6OaAooO
	 zbtq397pqtXRXfB/d8WXqss58fzaws3eHQA2b7xTTlro+V35dHINkcaOm6W/7oAl0U
	 2jDwzfGNBo2XA==
Message-ID: <1741379855.5492.10.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Reindl Harald <h.reindl@thelounge.net>, Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 21:37:35 +0100
In-Reply-To: <6290cf9a-faff-4e1a-aac4-f12d4744d8b9@thelounge.net>
References: <1741354928.22595.4.camel@trentalancia.com>
	 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
	 <d8ad3f9f-715f-436d-a73b-4b701ae96cc7@thelounge.net>
	 <1741361507.5380.11.camel@trentalancia.com>
	 <cc4ecd68-6db9-42e6-b0f0-dd3af26712ec@thelounge.net>
	 <76043D4F-8298-4D5C-9E98-4A6A002A9F67@trentalancia.com>
	 <6290cf9a-faff-4e1a-aac4-f12d4744d8b9@thelounge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfEEPV4/7I6AGV+0eiEkLIFezRcPBwJhkSZ9kejiL3hmI7g1fZWyznrdD4umtoqwYw2XNdUuFHKApT/yjwdWY/CpZ58lnj6+b/qLUXNF9njVqSJnDX9Vn
 gujgpLbjdkbd6vcL0eCCMMJ767v7m83n1WbM4spDkqfezzxHktapzB07QA30XxW4EA3cWQpBt2pPNFwAfUEL/w01Ju5Qm4ztNZXs3Kp61QnzJ+WxyfZ+vWH6
 R9OflcbsLRL3KxR7g1NRIhxEHbU9cZbIpC1FIKkeVUE=

Apart from the case of DNS Round-robin, quite often an hostname (for
example, a server hostname) is DNS-mapped to a static IP address, but
over the time (several months or years) that IP address might change,
even though it's still statically mapped.

In that case, if a client behind an iptables packet filter does not use
hostname-based rules, it won't be able to connect to that server
anymore.

So, there are cases where hostname-based rules give an advantage.

Of course, it is out of discussion that rules based on IP addresses are
always preferable when it can certainly be excluded that IP addresses
are going to change over time, for example, if the rules refer to hosts
in the same network or in a network managed by the same entity.

Guido

On Fri, 07/03/2025 at 21.07 +0100, Reindl Harald wrote:
> 
> Am 07.03.25 um 20:32 schrieb Guido Trentalancia:
> > That's the way it is, I am personally against the practice of
> > resolving FQDNs dynamically, but many commercial services do so and
> > the only way of setting up iptables rules in that case is using
> > FQDNs...
> 
> there is nothing qualified in a reverse-lookup
> franklyi can place any reverse-name that i want for any IP i control
> don't care really but using hostnames in a packet filter is dumb
> 
> > Iptables has always supported FQDNs, we are not talking here about
> > removing that support or whether it should be used or not, the
> > point is makjng that feature more robust and fault-tolerant.
> > 
> > I believe the patch improves the current situation for those that
> > wish or simply must use FQDN-based rules.
> > 
> > Regards,
> > 
> > Guido
> > 
> > On the 7th march 2025 20:15:39 CET, Reindl Harald <h.reindl@theloun
> > ge.net> wrote:
> > > 
> > > 
> > > Am 07.03.25 um 16:31 schrieb Guido Trentalancia:
> > > > Nowadays FQDN hostnames are very often unavoidable, because in
> > > > many
> > > > cases their IP addresses are allocated dynamically by the
> > > > DNS...
> > > 
> > > which makes rules with hostnames even more dumb
> > > 
> > > frankly you can't write useful rules for dynamic IPs at all
> > > 
> > > > The patch is very useful for a desktop computer which, for
> > > > example,
> > > > connects to a wireless network only occasionally and not
> > > > necessarily
> > > 
> > > at
> > > > system bootup and which needs rules for IPs dynamically
> > > > allocated to
> > > > FQDNs.
> > > > 
> > > > Guido
> > > > 
> > > > On Fri, 07/03/2025 at 15.48 +0100, Reindl Harald wrote:
> > > > > 
> > > > > Am 07.03.25 um 15:07 schrieb Jan Engelhardt:
> > > > > > 
> > > > > > On Friday 2025-03-07 14:42, Guido Trentalancia wrote:
> > > > > > 
> > > > > > > libxtables: tolerate DNS lookup failures
> > > > > > > 
> > > > > > > Do not abort on DNS lookup failure, just skip the
> > > > > > > rule and keep processing the rest of the rules.
> > > > > > > 
> > > > > > > This is particularly useful, for example, when
> > > > > > > iptables-restore is called at system bootup
> > > > > > > before the network is up and the DNS can be
> > > > > > > reached.
> > > > > > 
> > > > > > Not a good idea. Given
> > > > > > 
> > > > > > 	-F INPUT
> > > > > > 	-P INPUT ACCEPT
> > > > > > 	-A INPUT -s evil.hacker.com -j REJECT
> > > > > > 	-A INPUT -j ACCEPT
> > > > > > 
> > > > > > if you skip the rule, you now have a questionable hole in
> > > > > > your
> > > > > > security.
> > > > > 
> > > > > just don't use hostnames in stuff which is required to be upo
> > > > > *before*
> > > > > the network to work properly at all
