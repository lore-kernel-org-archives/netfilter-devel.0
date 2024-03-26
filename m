Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB576535AB
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2024 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711461618; cv=none; b=uPg7o8KZdPeqh++X0ENC887e14RnJN/cszn9u9XjVmkghSl+U0vl3fShCjI0Zj9bvzgSWE10LLu35sDLVh3HCzYNx8Pj514KSX4e1T0IvDZumY83ZSFgV0MeL9vkSscrbpG3SkCUIcqUrjhWrLi2ol9/KBGkMfca0CsnXYNJp5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711461618; c=relaxed/simple;
	bh=MPf2m/ua9MVw5dUPjh/IdiuG7AseH7DawLVw6W2w98s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4BdAd1KCKloTw9stJlvjGp2B0+jvX0Tz7ajwQ9xqzGU0Y5y5qtMxTFvoCWq0eMXYdA+tzw7Iv0Wu6k8QNnnbZhVqwCjdaookLVejx/mliosEYnscypIhlGKTH7BJZAySLgdspTuANUaT1eWrOsxic4ZmJRld+C7ZezMXZ0xH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gnumonks.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gnumonks.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
	(envelope-from <laforge@gnumonks.org>)
	id 1rp7LR-00FYQl-Do; Tue, 26 Mar 2024 15:00:05 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.97)
	(envelope-from <laforge@gnumonks.org>)
	id 1rp7KU-0000000EQIK-31he;
	Tue, 26 Mar 2024 14:59:06 +0100
Date: Tue, 26 Mar 2024 14:59:06 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables documentation improvement?
Message-ID: <ZgLUqtKEm_2YSEkQ@nataraja>
References: <Zf6Y2s6eyrhlWLZz@nataraja>
 <Zf9DskY3QHAIBGLE@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf9DskY3QHAIBGLE@calendula>

Hi Pablo,

On Sat, Mar 23, 2024 at 10:03:46PM +0100, Pablo Neira Ayuso wrote:
> That's fine, I should have written that already myself, your help is
> welcome on this.

I'm not saying anyone should have done XYZ.  Sometimes its useful to have a
[semi-] outside perspective of somebody who was not involved with the development.

> Just sent you credentials in a private email.

Thanks, I'll work on the proposed text shortly.

-- 
- Harald Welte <laforge@gnumonks.org>          https://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
