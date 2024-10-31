Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1C618593C
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 08:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730365095; cv=none; b=DwbJRn4Iytw/lYSd+Bileu0JQXjBfvmmMoqyHkfD8Bi1D+ldBfbTNoRPOyAok0uZ269MzVW9Fah7Z3igmXDy7m1O3UiCNNVRSLto2zpGFniyx2Me7jEQjeXYKBzkggtQYTAfMBHVk62WB2qxLFA24adxGV6PfhuBzkZUPPl1A9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730365095; c=relaxed/simple;
	bh=3d00BHGGzqyTk39YdMr747AMn4UUM8u38dOovj46ErI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E73tI5XbFI5anvvW0ixiyutmizRgH2u1/PyyFetkCDEBxUTbUUSBcEsSOrlXT0TXtIn0A4riWM2mHahWwewDIhJigE0ZnuceGMxYqVYv8emtdY1kfqINjwmIk2heOuI/5Bk344hm0Hg7HY6/PZJ5NSPQZ/DmwkikCdIduaVvnW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35614 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6R0H-00EmnH-CZ; Thu, 31 Oct 2024 09:58:07 +0100
Date: Thu, 31 Oct 2024 09:58:04 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <ej@inai.de>
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Subject: Re: cttimeout: link to own gitweb instance broken
Message-ID: <ZyNGnO-LutE4S_98@calendula>
References: <39onss6p-rso6-9qs1-6383-8669r37qpnqs@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <39onss6p-rso6-9qs1-6383-8669r37qpnqs@vanv.qr>
X-Spam-Score: -1.9 (-)

On Thu, Oct 31, 2024 at 09:46:26AM +0100, Jan Engelhardt wrote:
> 
> >commit 49417b53c3c9f2217f95918ce44f670222bd69bd (HEAD -> master, origin/master, origin/HEAD)
> >Author: Pablo Neira Ayuso <pablo@netfilter.org>
> >Date:   Wed Sep 25 11:56:00 2024 +0200
> >
> >    update link to git repository
> >@@ -162,7 +162,7 @@ struct nfct_timeout {
> >  *
> >  * \section Git Tree
> >  * The current development version of libnetfilter_cttimeout can be accessed at
> >- * https://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_cttimeout.git
> >+ * https://git.netfilter.org/cgi-bin/libnetfilter_cttimeout
> 
> Something isn't quite working.
> 
> Opening https://git.netfilter.org/cgi-bin/libnetfilter_cttimeout with a browser
> is showing "No repositories found".

Fixed.

> On the other hand, the URL https://git.netfilter.org/libnetfilter_cttimeout/
> that I had recorded in our distro-level packages works, but is missing the
> 1.0.1 git tag (if there ever was one?!)

Pushed out.

Thanks.
