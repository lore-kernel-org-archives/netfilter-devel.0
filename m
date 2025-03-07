Received: from smtpdh20-1.aruba.it (smtpdh20-1.aruba.it [62.149.155.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80E2187346
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 17:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741367735; cv=none; b=eezzCvyg2E/1VkrFwO4RXA+QACuhjT7Iox7iO/G1sDQ/hMwNQqu26Ud6SQO4VjjJmKymLJhHeLOopCOB7JEfEWSFgXmy4eQmL5oZJ2BKF9+g8xgZwzu8Ck91kU6blGQTgr+xDf0ZtPaE2vp71FNmoIS4yneed2Lwv0ZpZTyI9xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741367735; c=relaxed/simple;
	bh=7yckfhhJkhVB1LrKALb38MN2Xj5zoW9tpe+n1WS9cow=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=d29QiY5HzPtq2J50Z1Zb795ejOTTuzJolJqa6sOWgVwkH3qg8EueNIavsrhmTlXhEh79Ktzrz2jO1x+8ZZkdyvmqjtOi7kPHNanIDsI+q0qFbj15EheTVd7GO82TqFMqH3iNJyMeImIBzXaejnFExuRUMHd1ettqJ3+v20GbaUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=dFF8qV4n; arc=none smtp.client-ip=62.149.155.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="dFF8qV4n"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qbIHtofu4qg4pqbIHtMInP; Fri, 07 Mar 2025 18:15:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741367729; bh=7yckfhhJkhVB1LrKALb38MN2Xj5zoW9tpe+n1WS9cow=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=dFF8qV4ncrkFBQ1rfSFlx2H2qvJLiF92kBM80+4cZu5BMoI0SN1AuA6twZTYzsD4J
	 o2UsmPVtQ0UwINHQ5OJlzYY4+BCOX2IAjE0jn8PKlIj3bXCtM0ocSxvwzcXXLil7Ov
	 fNH6WshTcl7PeuA1rO9u8a7N/g2QRL31dX3mLCd0GskQLSjiqkNBMADcyUfaCNEtVB
	 cNWixOvVpUsiwK5DCOeL7vzf27XyxzeBH0FSRA2F9O15MZX/ARBp9vqAxed9Poy9eS
	 TE2oElX1PRx38OXoNieajz/Da9nD/4uWitkqB74HvkRANX5KlsTTCK/QQ4Qg8BUlZ2
	 ohLMGcb2Dd8vQ==
Message-ID: <1741367728.5380.32.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 18:15:28 +0100
In-Reply-To: <9rp402o4-92ss-non1-o0rq-467r79spnn42@vanv.qr>
References: <1741354928.22595.4.camel@trentalancia.com>
	  <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
	  <1741361076.5380.3.camel@trentalancia.com>
	 <1741362376.5380.16.camel@trentalancia.com>
	 <9rp402o4-92ss-non1-o0rq-467r79spnn42@vanv.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfCt/pCzMCq/fzOhO+Bo/KzNl9ubYkmv+kJ4spFrShTrUuzMvwl+A7FHrRpgFkJ64kh9el5mSOUNbcoxWYzHJ8miR+caggR9wU4wlCW0fssoy5yE2jE0u
 x0dL53e14jMR5rOUBxKP+6oU0Dx7AvTOwpv0rWP16/eO/GZ43JjACnHyh6kyJpgAbblLTN9N/TivTWeZIHaPmNn+coyM2SRRUqnqp5rPwFt4lJNzYcO0fn4W

No, I don't get that behaviour, at least with iptables 1.8.9 to 1.8.11.

I have just checked with "iptables -L".

Allowing or rejecting a given FQDN results in iptables generating as
many allow or reject rules as the number of results returned by the DNS
lookup for that FQDN.

Guido

On Fri, 07/03/2025 at 18.02 +0100, Jan Engelhardt wrote:
> On Friday 2025-03-07 16:46, Guido Trentalancia wrote:
> 
> > I can give you quick example of an hostname which is allocated
> > dynamically in DNS: www.google.com.
> > 
> > If you perform:
> > 
> >  # nslookup www.google.com
> > 
> > then you will obtain a different IP address (or different multiple
> > IP
> > addresses) each time you run the command.
> > 
> > Given the above, any iptables rule for such kind of host will need
> > to
> > use its FQDN instead of a statically allocated numeric IP address.
> 
> In that case of multiple queries returning multiple results (DNS
> roundrobing), using hostnames in firewall rules (with or without
> ignoring lookup errors) is even more wrong than before!
> 
> Because
> 
> 	-s google.com -j ACCEPT/REJECT
> 
> only performs one lookup, it leads to
> 
> * accepting _too few_ hosts, meaning you erroneously reject some
>   google.com connections in subsequent rules,
> * or rejecting *too few* hosts, meaning you erroneously let some
>   connections through in subsequent rules.
> 
> So now we've gone from 100% of the time google.com is not reachable
> to randomly failing half the time attempting to load a search page.
> 
