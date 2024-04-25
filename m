Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E567884E18
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 11:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714044483; cv=none; b=nUAF/EfbDgqqlYSUptpReeVyVgqaOGi8iUeMRpYNT7WC6djtjm2l9zCgnvhkaxzx7MmFln7Z7mwg/yXV5L49ws5TcOTTtnI4PQFfbqUecn5t+Ya+vmqgbyYQgpWgisoAa1nxZUtXicoWcwfIv56Ub7/4hkKi/vBgKU93i5EYUJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714044483; c=relaxed/simple;
	bh=0L8VZ8TyY+niGFDnB8/hepXM7xo1kelWxhq8WJB9FRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqqBZRpjWNLoitMGYd4MZ7lUP7Of4zjFCm60UFW7YJI5E+/8/pfokfEoCXS2/P9zunmfJPTZw5Oln7SzUqjjpQIbZ98CyoDyeU5kBTBt+KQxRy0b5w63qUqmgk/aw2xqURtjpCpCLiUBqFNF5CEPdppgOcwULHKIFzClFXgNrTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gzW3Rc86; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gzW3Rc86"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g8/5TzcmUFa8BzHkkn933WpI2ovypcZxi+raHwPwp84=; b=gzW3Rc86d4mfeVA+LGrcnpRIF1
	SUpXsOf6Ko7fIMwTTuvHIuwre0R5kY26sNzbTf5yNja3wDC6ZUdLTCLTX/wVAK6DYCjJRzJ6Z+3Zk
	iHzAuXcyDYLpYk/f1AvIUeJH+U8USyiNXP5nEqGcx+tmW9pi/CdJjPwy2a/yFp2wzWj3rdEHTQjmL
	UWHlgliNJ+i5bfFU47W7t38Tc7hTAdpZehfZp2E0h7daXGz2YMrUqCPztqONefe6YvS/mg2ARqzLv
	TV1Qzoo6722kMiS5D/s5hoiF+3SNL48rkoOHLE/5jaH1ovuct+r7rO4JVH+GtXlKURCOUVgFESa3J
	+JmJMBxA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzxGg-000000000AW-3wPn;
	Thu, 25 Apr 2024 13:27:58 +0200
Date: Thu, 25 Apr 2024 13:27:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Alexander Kanavin <alex@linutronix.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables][PATCHv2] configure: Add option to enable/disable
 libnfnetlink
Message-ID: <Zio-PkOVtsbKJ0dH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexander Kanavin <alex@linutronix.de>,
	netfilter-devel@vger.kernel.org
References: <20240425085102.3528036-1-alex@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425085102.3528036-1-alex@linutronix.de>

On Thu, Apr 25, 2024 at 10:51:02AM +0200, Alexander Kanavin wrote:
> From: "Maxin B. John" <maxin.john@intel.com>
> 
> Default behavior (autodetecting) does not change, but specifying
> either option would explicitly disable or enable libnfnetlink support,
> and if the library is not found in the latter case, ./configure will error
> out.

Thanks for following up! I applied the patch after merging the two
AS_IF() calls: AS_IF supports building "else if"-like chains of
conditions.

Cheers, Phil
