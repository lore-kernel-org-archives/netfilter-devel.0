Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEF021506E
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 11:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738842925; cv=none; b=qNwhJCsKDYDLlKDFdVooB2O2HBy+G4fwjEEkgzQILYfAEusH2qBQkavOisPUInTmtJg6ozjOMxAZc/lHQ8Ov/Fd2N57qFOeEkNnRN49HZea2ejKcOY1IPv+QrDaWM9DeATsPIQI0wqBigs9XQEyg4IpFoTiyCnGcOqVBkI9W3do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738842925; c=relaxed/simple;
	bh=ui3lBP1N07GVITAe5HQ0VCfa8wl5/IBNkN2kSAcA0ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cn8UmJxvL98jp/cFHLnYtoey1Dcy/HMG/bttCiH0ByzzLHkv3tdzXtroq+UGceZYt2S3ISWXPn9m1SVq/xEA7VyjnlbHX/LQxhs/jLVcT1sjb3HX9dTlUll6SDW4xXXd3gkNVzBxoDr2mlO/1b4WtI3Jxi20tY8cHyVZX6bsdbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DV5+adnY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DV5+adnY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DV5+adnY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DV5+adnY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D2F7F6058D; Thu,  6 Feb 2025 12:55:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738842915;
	bh=fTiD4+QkpctvT0bx5WnkBDmayvik9uZDAYCNRgfDcxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DV5+adnYyg7Aui35J9nCRj36Zb9IKHgGSuVd/+ECO/f/9BDxEo7tKvbscvYIe9a/c
	 Cgz6AZ4RQnTgfO6Hfc0ZOs7+7xAjQJzJI3bTMktO2ftbN9cxcOPMU3u6vmQ49HqYoe
	 XqgHlXKvw8FYjyKEs8aJQW8OCs+fmBcT9yS6EtKPdQjZHP/K+LedQs1yhhgcXydT4D
	 Hxu6G4JyOdpke/5LP8f0BqUAwWZ+BzDRRV+x3u0a2l2hVE38rkrFKXKC5JnQEKDQcj
	 6ekXJRyPZE+xo9KONY0nFNILVxKsSoqCqKwcPNMtKITe2T0tUD5HMMdaPdkt/pC8tD
	 DBkHhagU/VBMQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 453CB6058D;
	Thu,  6 Feb 2025 12:55:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738842915;
	bh=fTiD4+QkpctvT0bx5WnkBDmayvik9uZDAYCNRgfDcxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DV5+adnYyg7Aui35J9nCRj36Zb9IKHgGSuVd/+ECO/f/9BDxEo7tKvbscvYIe9a/c
	 Cgz6AZ4RQnTgfO6Hfc0ZOs7+7xAjQJzJI3bTMktO2ftbN9cxcOPMU3u6vmQ49HqYoe
	 XqgHlXKvw8FYjyKEs8aJQW8OCs+fmBcT9yS6EtKPdQjZHP/K+LedQs1yhhgcXydT4D
	 Hxu6G4JyOdpke/5LP8f0BqUAwWZ+BzDRRV+x3u0a2l2hVE38rkrFKXKC5JnQEKDQcj
	 6ekXJRyPZE+xo9KONY0nFNILVxKsSoqCqKwcPNMtKITe2T0tUD5HMMdaPdkt/pC8tD
	 DBkHhagU/VBMQ==
Date: Thu, 6 Feb 2025 12:55:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexey Kashavkin <akashavkin@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] parser_bison: turn redudant ip option type field
 match into boolean
Message-ID: <Z6SjIEKagIkqvo57@calendula>
References: <20250131104716.492246-1-pablo@netfilter.org>
 <20250131104716.492246-2-pablo@netfilter.org>
 <D068290E-A9A3-4CD3-9C75-413626D540D6@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D068290E-A9A3-4CD3-9C75-413626D540D6@gmail.com>

Hi,

On Wed, Feb 05, 2025 at 03:29:10PM +0300, Alexey Kashavkin wrote:
> I suggest adding the following note about the addr field.
> 
> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
> index 7bc24a8a..9a7ac396 100644
> --- a/doc/payload-expression.txt
> +++ b/doc/payload-expression.txt
> @@ -820,6 +820,8 @@ Strict Source Route |
>  type, length, ptr, addr
>  |============================
>  
> +Note: Only the first IP address is specified in the addr field.

It should be not too complicated to extend this to match on any
address.

> +
>  .finding TCP options
>  --------------------
>  filter input tcp option sack-perm exists counter
> 
> 
