Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2282813AA40
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 13:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802509; cv=none; b=ILAFQmmt0UOLnQHvIH5CMzzxXLWk0eJdvEDLhpMq5Tg8xzIv9G1yChUXu65T81PPmLc9B+vHEbKp1WVDfEYaMFpLnkxrv+ru7e4pAC0QeuIA1dKRfhkGZ0Mzin3fjNZ7o2RTvaSYnpD6u/JeDy2kCPjlQl/knAwN8aLABVbi4G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802509; c=relaxed/simple;
	bh=L1uCm0ZogMYR+XPO8uv0F5xocFsZcFMIqpejqf+Rjic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OLxrgJScm8Qv153pQgpp5Pq4bAQVU9KPL0hUK2ROKEV58PXv3RhU5FhTxrvdmpeu70Gjqxa4ICH4cYB4eT6j1uXzHCM0ZzmaF3FwWBHgxJN0m0L9WA9aenQj+Nh9JHjaKM5CAm8ynfHgJGy3uatH1k3hreIulaOwCoSms31s0gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41858 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sJv2z-00F3vs-0C; Wed, 19 Jun 2024 15:08:23 +0200
Date: Wed, 19 Jun 2024 15:08:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: pda Pfeil Daniel <pda@keba.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: AW: [PATCH] conntrackd: helpers/rpc: Don't add expectation table
 entry for portmap port
Message-ID: <ZnLYRJkOuJhBIvrM@calendula>
References: <DUZPR07MB9841A3D8BEF10EB04F33636BCD172@DUZPR07MB9841.eurprd07.prod.outlook.com>
 <ZnK6821kYBYzqRZZ@calendula>
 <ZnK8Fj52_8cIgKp9@calendula>
 <DUZPR07MB9841985506C0E34204093904CDCF2@DUZPR07MB9841.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DUZPR07MB9841985506C0E34204093904CDCF2@DUZPR07MB9841.eurprd07.prod.outlook.com>
X-Spam-Score: -1.9 (-)

Patch is applied, thanks

On Wed, Jun 19, 2024 at 11:29:37AM +0000, pda Pfeil Daniel wrote:
> Hi Pablo,
> 
> the portmap port must be opened via static iptables/nftables rule anyway, so adding an expectation table entry for the portmap port is unnecessary.
> 
> BR Daniel
> 
> -----Ursprüngliche Nachricht-----
> Von: Pablo Neira Ayuso <pablo@netfilter.org> 
> Gesendet: Mittwoch, 19. Juni 2024 13:08
> An: pda Pfeil Daniel <pda@keba.com>
> Cc: netfilter-devel@vger.kernel.org
> Betreff: Re: [PATCH] conntrackd: helpers/rpc: Don't add expectation table entry for portmap port
> 
> ACHTUNG: Das Mail kommt von einer anderen Organisation ! Links nicht anklicken und Anhänge nicht öffnen, außer der Absender ist bekannt und der Inhalt der Anlage ist sicher. Im Zweifelsfall bitte mit der <https://collaboration.keba.com/trustedurls> Liste vertrauenswürdiger Absender<https://collaboration.keba.com/trustedurls> gegenprüfen, oder  den KEBA IT-Servicedesk kontaktieren!
> 
> CAUTION:  This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe. In case of doubt please verify with the <https://collaboration.keba.com/trustedurls> list of trustworthy senders<https://collaboration.keba.com/trustedurls>, or contact the IT-Servicedesk!
> 
> On Wed, Jun 19, 2024 at 01:03:20PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Apr 25, 2024 at 12:13:11PM +0000, pda Pfeil Daniel wrote:
> > > After an RPC call to portmap using the portmap program number 
> > > (100000), subsequent RPC calls are not handled correctly by connection tracking.
> > > This results in client connections to ports specified in RPC replies 
> > > failing to operate.
> >
> > Applied, thanks
> 
> Wait, program 100000 usually runs on the portmapper port (tcp,udp/111), which is the one where you install the helper to add
> expectations:
> 
>    100000    2   tcp    111  portmapper
>    100000    2   udp    111  portmapper
> 
> How is this working?
