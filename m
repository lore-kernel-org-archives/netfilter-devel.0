Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFA86A03F
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 18:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710958169; cv=none; b=iyBzOjCqAlmE1FHNpPW7iHknIfjSpil053jfOEZCi+Pvh6l3B4CEZszJEtrg4uN0veeYxy3NGMnsuylfD1JFsdU+eCA4D+2CkQvdlruoa+3+th5gf84PAc0Zs3N4i0/NPl/iu/a+SwVonSfTU/nEGvW0aq0MWT3Tq1uysvIu4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710958169; c=relaxed/simple;
	bh=pWiPe36DFJfbepcMP/TFAivIaEz32mETUBUMoPOBaq0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoRtb+lQH/icdNTI53AgZfjugtkDRUATIVcmqBl9UvG8bvqU2csahW8uCRe/poF655DD8+219RSda0FOxv1Bdb3z7/eRGLfIuvM7iPsi9TRpxeS5ei1y0z8af8G24c0/VWKs4k9d43WyiMJ8YZDLDdrncYdjO09c380jqdf1zXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 19:09:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: display "Range negative size" error
Message-ID: <ZfsmUykiWOGPARHN@calendula>
References: <20240319192519.206632-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240319192519.206632-1-pablo@netfilter.org>

On Tue, Mar 19, 2024 at 08:25:19PM +0100, Pablo Neira Ayuso wrote:
> zero length ranges now allowed, therefore, update error message to refer
> to negative ranges which are not possible.

I have pushed it out this patch
