Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A0318C93C
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2024 13:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723123294; cv=none; b=MJMvLwkguxdWlYCptpRP/oJIgEiuSs8M3TH6cu9EbTx2rz/3knMUzN9MXQHlvTs7KrUgLnCOTJn0FwHFBNehS+V1OImrghECAOkEwrSfUc3PfSNUqNsjUKvln+6GwB1OnR90TQTrd5mTkrh1WKkjakC3Mis3V7L72laq87/lb2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723123294; c=relaxed/simple;
	bh=x5zVLAdZvMsXNyyi5jxqtyNoyZiQ5pCnJ+lmRoOo1O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpGRhcTcea9ri7yiKoNcrXkObCSW7i/13u30hDfZNx7Y/7dJ7yPdcqI67uGXfsqwXIeWSIqVbNfinCn5PsLarI/g+5aF4ueFFQIVULzIz2EeurTEfiMarY7lXyuQIuOS4M6trYUzFstATtKAm3dJB6WAU14kayJOKuBnshfRkUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pNXnmfH+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pNXnmfH+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RpoJHrUnVhDSn6A5u4SVagNS20b5cJKS5aeRC6IUPoU=; b=pNXnmfH+wspo6EUQ0EOLunpZcj
	hqQ1bu04VpMXNsypYa27k1PdMYkpJaJOEKf5QUCGeGK1425YMpyOJR4ggVIG7A1ZZeNJiO92XWlSC
	JrK8n1qs0MQ6mMrYioh5u2jpElY7N3ExqhjxeoJ5IKo38dXEUvFGkqyNiEcK0bT1S+h4bbx9PebDF
	gJLsGX3VAL0Kk+M7bc7wVVMkudSYiFGwxQkMRhZ2QylRTuxeF7NlSVJAtMZq4NZMTTyl5WvJK65mn
	PDvJOLu7zy+e2YGuuP5olte2zib55fOHd64azQ34Cxdp3KqlfhdL0dDa5Cyr1P5YXDXscZP6e08Fz
	4LCb7UyA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sc357-0000000021t-3Tyf;
	Thu, 08 Aug 2024 15:21:29 +0200
Date: Thu, 8 Aug 2024 15:21:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Joshua Lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables: compiling with kernel headers
Message-ID: <ZrTGWWMs2TA1j5wa@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Joshua Lant <joshualant@googlemail.com>,
	netfilter-devel@vger.kernel.org
References: <CAMQRqNJe=rT8sJD78TCmBNnE+3KQFzx4mqNNXw4O3vohZo_Ycg@mail.gmail.com>
 <ZrOpqyQZZW1wUTUQ@orbyte.nwl.cc>
 <20240808110809.GB2844568@softwood>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240808110809.GB2844568@softwood>

On Thu, Aug 08, 2024 at 11:08:09AM +0000, Joshua Lant wrote:
> Hi Phil,
> 
> > > When I try to compile iptables using —with-kernel, or —with-ksource, I
> > > get this error:
> > > 
> > > In file included from …/iptables-morello/extensions/libxt_TOS.c:16:
> > > In file included from …/iptables-morello/extensions/tos_values.c:4:
> > > In file included from …/kernel-source/include/uapi/linux/ip.h:22:
> > > In file included from
> > > …/usr/src/linux-headers-morello/include/asm/byteorder.h:23:
> > > In file included from
> > > …/kernel-source/include/uapi/linux/byteorder/little_endian.h:14:
> > > …/kernel-source/include/uapi/linux/swab.h:48:15: error: unknown type
> > > name '__attribute_const__'
> > 
> > I can't reproduce this here.
> >
> > > I see that this error arises because when I set the —with-kernel flag
> > > libxt_TOS.c is being compiled against ./include/uapi/linux/ip.h. But
> > > when I compile without that flag, the -isystem flag value provides the
> > > ./include/linux/ip.h.
> > 
> > What './include/linux/ip.h' is that? It's not in iptables.git. On my
> > system, /usr/include/linux/ip.h is basically identical to
> > include/uapi/linux/ip.h in my clone of linux.git.
> > 
> 
> Both the ip.h are under the linux git clone, one in
> <repo>/include/linux/ip.h and one in <repo>/include/uapi/linux/ip.h. I
> am setting the --with-kernel or --with-ksource to be the root of the
> linux git repo.

Ah! Well, include/linux/ip.h includes uapi/linux/ip.h so they are not
entirely incompatible. User space might choke on the former's extras,
though.

> > Did you retry using gcc? I personally don't use --with-kernel/ksource,
> > so from my very own perspective, this feature is unused and untested. ;)
> > 
> 
> GCC is not an option really. My whole build system is set up around
> clang, and the status of the morello GCC compiler is not as mature I
> don't think, so could cause more issues than it solves...

I assumed you see the problem with --with-kernel with x86_64, too.

> > These are bugs IMO. Kernel headers are supposed to be compatible, so one
> > should not have to adjust user space for newer headers - the problem
> > with xt_connmark.h is an exception to the rule in my perspective.
> > 
> ... 
> > If it helps you, feel free to submit a patch updating the cached
> > xt_connmark.h and dropping said enum from libxt_CONNMARK.c. Same for
> > other issues you noticed. In doubt just send me a report and I'll see
> > how I can resolve things myself.
> > 
> 
> Okay, I'll start trying to update the headers and see how far I get through
> the compilation. Thanks a lot for your input.

YW!

Cheers, Phil
