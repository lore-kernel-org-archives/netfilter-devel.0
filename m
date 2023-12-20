Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2449A481C3
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 21:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mXQ8uFp1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=D9p5apOIIHDBSq8y4sCHMz/E+iS8qIDOZqmHikWHcAQ=; b=mXQ8uFp1RapybEMmqk5/3MI6K+
	1XnHzU3D5SdFP421xz6L6zSVkdjxDGGKbVN5HpkAdRFLM9YZ0jUv9csIVfQ/3+ugF5xD15IG8qmnF
	/3wW8MA3K4Mg0OTKTdm+0Ks6QiSEy4CsH7HI6Y6jP1WYBChmPqiqf0hYYTpUUbewAl1e5thi4YkXw
	8hWF1T1IhmRt6udSZlDvMCc9wAvG0XYante/eSQbg9BgI6ue6JG/MyYHhVlgFH/EQndXi2Ilf61rG
	0q4pduWJ9bX1Vf3MV5EPEcc52ngut8iYt6UjVQwGG5eaa0kYBaN9v9pkoSAyFEET6GffWjxLjTHLz
	6tDbOo8w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rG4Pd-0008W3-9d; Wed, 20 Dec 2023 22:47:33 +0100
Date: Wed, 20 Dec 2023 22:47:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 07/23] extensions: libebt_stp: Use guided option
 parser
Message-ID: <ZYNg9Z2GV7MFKsBT@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20231220160636.11778-1-phil@nwl.cc>
 <20231220160636.11778-8-phil@nwl.cc>
 <167pn5s8-4p1o-2088-3465-n47978645q04@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167pn5s8-4p1o-2088-3465-n47978645q04@vanv.qr>

On Wed, Dec 20, 2023 at 08:29:25PM +0100, Jan Engelhardt wrote:
> On Wednesday 2023-12-20 17:06, Phil Sutter wrote:
> 
> >index 17d6c1c0978e3..b3c7e5f3aa8f3 100644
> >--- a/extensions/libebt_stp.t
> >+++ b/extensions/libebt_stp.t
> >@@ -1,13 +1,29 @@
> > :INPUT,FORWARD,OUTPUT
> > --stp-type 1;=;OK
> >+--stp-type ! 1;=;OK
> 
> Is this the normal syntax for .t files, or should this be
> `! --stp-stype 1` to avoid the infamous "Using intrapositional negation" warning?

With ebtables, intrapositioned negations are still the default although
extrapositioned ones are accepted. For the tests, I chose to use the
former just so I could use '=' in place of expected output.

Since ebtables-nft now uses the xshared commandline parser, it will
indeed complain about these intrapositioned negations. Guess the time
has come to change how ebtables prints rules and to adjust the test
cases accordingly. Thanks for the reminder!

Cheers, Phil
