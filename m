Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3023514A60C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732055980; cv=none; b=A0Mg6Hrf5GpC/P9qOFwFUTXEt1zxVHK2t9KXfKOyzbBq+n/j6oNG1OnRPa8vvqszvaoxcLPuciEPgmpSVmsvHBwTYJkHQvr9MiECN6LiRVhUg000cyHkeGsBEEM3UxacwPd46+pSRVnJG4gSuoxbwK6tjJe028lk3tr8QaZehqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732055980; c=relaxed/simple;
	bh=bqMK/1ZqbTr7Go9GEM3ZtOlO8JaWnZq18RMkmpv1iZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKniRqgygKzb0glJz+c7MLlmZ9YOS3/vQE21MFs4dsW4Ejm0dmsV6iWRjxN0UmhDlOr6v6Q96XlbBwRG9VlaYS/N7E19wrM4myC9ap9KOYej9mfVl0BX4G11qHd/Wu5XDoTLR3gDIzA/qxvlvUwtwkBBsoJMlaSMTy7BERBp9Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=38346 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tDWsX-00HPTn-FD; Tue, 19 Nov 2024 23:39:27 +0100
Date: Tue, 19 Nov 2024 23:39:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jim Morrison <evyatark2@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: DSA and netfilter interaction.
Message-ID: <Zz0TnJtCnKnEreKR@calendula>
References: <CACSr4mSaw+M65HpZE+_Rotp=YuWugU9h0vokGyb-14pvoc+-Xw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACSr4mSaw+M65HpZE+_Rotp=YuWugU9h0vokGyb-14pvoc+-Xw@mail.gmail.com>
X-Spam-Score: -1.9 (-)

Hi,

On Sat, Nov 16, 2024 at 11:11:22PM +0200, Jim Morrison wrote:
> In net/dsa/user.c in the function dsa_user_setup_tc() when TC_SETUP_FT
> command arrives, dsa_user_setup_ft_block() will be called which calls
> ndo_setup_tc() for the conduit device.
> 
> What is the rationale behind this design? Why isn't the corresponding
> dsa_switch_ops::port_setup_tc() called?
> 
> More specifically, what is the conduit driver expected to do when it
> receives the TC_SETUP_FT from the DSA subsystem?
> 
> It seems to me that the conduit's driver can't do much as it doesn't
> even know for which switch port this ndo_setup_tc() was called.

Did you have a look at the existing client code that is using this
infrastructure from Netfilter?
