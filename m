Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382CA346E45
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2026 13:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770988170; cv=none; b=pR5Pb8BBTeMe1eplNw4z2Af+qGOWinV6gZm0S2iVWv318WH3yl1+f+QuEGpqsgfrPK3vHSoSAbm2Z+1vFLjr32wAIahQRX8qJtAIbSQ1vg7aaI76UELud1k0pF4BjaE3oNqKpgITO3LjCf6PqeYwPDTxKMwvDK+LnzqCTvthFhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770988170; c=relaxed/simple;
	bh=EA+5pkQ7b1Ud2q2JLYOxw/d9bUAEm7Qh3JLCdq8wqt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UR1WqTQOdc5nLM+sXqpknG3Rr8fAOpJMyZrZ8fW3fkfnVfAVLv3Gh/XV4Ww7fQUtN1HPSimwbO6ZhCGi4feGK5nrWjTjoaIS2Aavv8C3J+68eBn3sD3ecYdlZT1PGKzrUu9wuq5+jAGlCYdDwyw2wV+556IqbWAXewhwKx9tUtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qTXpki0i; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qTXpki0i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y76jjHJuuAqOO2KrXxsFGDS0ls6p9xQGkl7kAiB+UnA=; b=qTXpki0i4AI7lYxi095QZcIrMS
	GvmQNHWOt+UUdoylVmhrX5ammX8gmnI6wdF9zjPsD7faNKxxIrHUwLFAvfKmChYwZqpE3XPm9GAHa
	aiHYoO28WfL6DoWXbWCiCEt6YMIsqs4DPO66ZCf1tprNpQPXRXlGWyznBq7OJhZHO4Qm8Vhl/6qC2
	hkuIVfUxggAkMcR1yh5+1c8teZrL1AdVNE1gLrMsYBOON3FzVpZMfFi/lO1xdFZQoxE0D7S/biraC
	I0H2lGjBRC0BGtNm5UyoPIZaZn2/tQ5t2DokhlmNC21MLxOYSWzmiIgZ7l5tKLmw6HCyhhf6yv378
	7WnLvs7Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqsvH-000000007Kk-32mK;
	Fri, 13 Feb 2026 14:09:27 +0100
Date: Fri, 13 Feb 2026 14:09:27 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4] configure: Implement --enable-profiling option
Message-ID: <aY8ih5bMqveTrF7Q@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260212205023.32010-1-phil@nwl.cc>
 <aY8Mk5eCymlbN8UA@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY8Mk5eCymlbN8UA@strlen.de>

On Fri, Feb 13, 2026 at 12:35:47PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This will set compiler flag --coverage so code coverage may be inspected
> > using gcov.
> > 
> > In order to successfully profile processes which are killed or
> > interrupted as well, add a signal handler for those cases which calls
> > exit(). This is relevant for test cases invoking nft monitor.
> 
> LGTM, thanks Phil.  Feel free to push this out.

Thanks for your thorough review, patch applied.
