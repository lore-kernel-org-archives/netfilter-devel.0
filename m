Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F982F43
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 08:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741769401; cv=none; b=Nd5KMxO5DWdvyHjiBdNjIKCeaAqDLm6B5oGHvV6RTO+9baxe9Ful8XuhaMJL7KkOKWBVV1+yxkd4s/PosYANZA1hXP50aoSgLivnAoMuUvLDYvYuSwSUmz2Tn/MKz1nj547bJ4n3eF5+OvfJb782gcPyrmtAJnzDf2+HA9sjaa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741769401; c=relaxed/simple;
	bh=+mCLel4Zc2NQ+O0w8LfR9LpaWYzkc8LQc+lge3I6k+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFIWGFFKmG/RoOoYa1FgeNGpjB2R/I16UgXpW7hx7DNjGHHklobNrX018J3v/rwXuDphVHtNOxoJaLAiHl61obJ0Ix6HqQCRG3Bwu5m4163RUQ8FM2JdlS/pKReUl2HXSdzhOVxlE25CV1dETaZnxG2ifLm2Kil4PJI809o9s1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsHmn-0003sC-4j; Wed, 12 Mar 2025 09:49:57 +0100
Date: Wed, 12 Mar 2025 09:49:56 +0100
From: Florian Westphal <fw@strlen.de>
To: =?iso-8859-1?Q?G=E9rald?= Colangelo <gerald.colangelo@weblib.eu>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Bug in ulogd2 when destroying a stack that failed to start (with
 fix attached)
Message-ID: <Z9FKtEEoHCsCJ5wl@strlen.de>
References: <CAEqktHuJ7T8R6CmYd-R7tufUPdLBT22S6G3_-_PG9s9c_4t5EA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEqktHuJ7T8R6CmYd-R7tufUPdLBT22S6G3_-_PG9s9c_4t5EA@mail.gmail.com>

Gérald Colangelo <gerald.colangelo@weblib.eu> wrote:
> +cleanup_fail:
> +	stop = pi;
> +	llist_for_each_entry(pi, &stack->list, list) {
> +		if (pi == stop)
> +			/* the one that failed, stops the cleanup here */
> +			break;
> +		if (!pi->plugin->stop) 
> +			continue;
> +		ret = pi->plugin->stop(pi);
> +		if (ret < 0) {
> +			ulogd_log(ULOGD_ERROR,
> +			"error stopping `%s'\n",
> +			pi->id);
> +		}
> +	}
> +	return -1;

Looks good, but I think you also need to add a second loop to free()
the stack elements, as done in stop_pluginstances().

