Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4923421B9FE
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741357382; cv=none; b=MxikE7HuKmuX46HIwFt25y66/6T92tn6r8iQLmlS7M29X68A7wv91Me7FTGP36bT9rzuxxRGVUTdt8sB6PHXxD7FlTUm6QZIfiS4Gv3U1TdyzqiaasPUKvg1uArOUADVa1nNTdY5X4XRYNqL/7CSZgUs6afY2s4A6HAUK66HAXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741357382; c=relaxed/simple;
	bh=6c9L/62U/3f4DOQBZzOmhXVRXghxhXXkk6M8DvImQKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h72RhffX3gHZr5hDK7PaMnUdroh7V4gpeeauDoZ4U0JFENhsMvzel+qTBTd92xgsPvfn+ugf3xl4voVVJKNOZGXiP439JelluvRGP9o9OS/XPzaZ1Lei21LFtlvKB985qR3SRSWyRP9lGKbKMcV/nL+aX1sryoyfR6Gqjopx2Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QD8/y4gp; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T/f2b6iE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QD8/y4gp";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T/f2b6iE"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 005696026B; Fri,  7 Mar 2025 15:22:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741357377;
	bh=0bqdcwkZxXT/R5E3extoDqTHTyY6b6HCcmG85TIwV5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QD8/y4gp6Gt4yQSWMareEEjtJAXQ+eM7hrFqfgIDvKz9GferQzUuMGtJMG9Xx9PCe
	 nUzmi8b8mq9EXu0OUgunquParHts6VfJlI8pwu2slU+Jf21q9nJadmeBtF+orvHtLP
	 TerBLei2Kk5ab1mjNUN9T3YveHrca14E9FqX2q2yKM0DfmAfxKlzKtl5w07m1UxBU5
	 UgBNEmkEf/ZmI4FUdOyEZSponXON7xKbC641RdIMb18vTeQrnpfaPvYimtKz9AtVD5
	 Z9/yqPXfuEvMpMoKHAf/7C8PW2HbfS4057HIA2+8MNeOZrz9y+zyZdufv+n56NGMTi
	 /87JhqqNs4e+Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 677516026B;
	Fri,  7 Mar 2025 15:22:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741357376;
	bh=0bqdcwkZxXT/R5E3extoDqTHTyY6b6HCcmG85TIwV5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T/f2b6iEZYRzsIcOjKH1gGayn/Bo9SUL9yU9oBzAInHC3/gU9yNsO5J/iLyrHB4M1
	 gK8+l8sFELIBhZjEJUhHau8zy9jRKJfGFfzI8mlPCPbRa7SPyYgMm1LoOEXaFwUjad
	 rdE65Udo756KiLF2hVC9nJthAsgfxP4iQH4vg2wSc/OMddqLeAdg3dI17/N+Ns+zaD
	 nqN5eUe2H+sN+VvV2psJJAnSKlGALyVR94UmOKX1t2bLHyc8+lGm9uJUM620wmv3xZ
	 8emkDQ5chGz8aa8SB17j95hBAMfNEKdm5qH7tKufMUNOTKm60IYkbCX+/pnkagfyWS
	 fEZMAQthvHYLw==
Date: Fri, 7 Mar 2025 15:22:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexey Kashavkin <akashavkin@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Generated value for filtering from two arguments received from
 the command line
Message-ID: <Z8sBPsNtwMvjWQ0w@calendula>
References: <AA705D8C-131B-4305-81A6-840C38AE6E54@gmail.com>
 <2C2AE2EC-8862-4ABB-864C-78467E668575@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2C2AE2EC-8862-4ABB-864C-78467E668575@gmail.com>

On Fri, Mar 07, 2025 at 05:56:29PM +0500, Alexey Kashavkin wrote:
> I have performed the required translation in lex (scanner.l). After receiving arguments from the command line, the required value is generated.
> 
> args_for_gen_value      ({digit}{1,3}{space}{digit}{1,3})
> 
> {args_for_gen_value} 	{
> 	unsigned char paf_field[14] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
> 	yylval->string = xstrdup(build_paf_val(yytext, paf_field));
> 	return STRING;
> 	}
> 
> Hopefully this will be of some use to someone.

For this kind of arbitrary matching, best is to add support for raw
expressions.
