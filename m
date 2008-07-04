From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Fri, 4 Jul 2008 15:53:41 +0200
Message-ID: <200807041553.41535.ludwig.nussel@suse.de>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu> <200807031044.37410.ludwig.nussel@suse.de> <Pine.LNX.4.64.0807031504180.1816@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYGDNxn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:53:43 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 634C94575B
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2008 15:53:42 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0807031504180.1816@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Thu, 3 Jul 2008, Ludwig Nussel wrote:
> 
> > Jozsef Kadlecsik wrote:
> > > I'm happy to announce ipset-2.3.2. Besides cosmetic changes and cleanups, 
> > 
> > Ah, nice. I'd like to suggest to add the following patch. It
> > separates building the kernel modules and the user space parts. That
> > eases packaging for distributions as the kernel part has to be
> > compiled several times for different kernel flavors so the
> > integrated way is not really useful there :-)
> 
> Please check out ipset-2.3.2a, which has got 'binaries', 
> 'binaries_install' targets for the userspace part and 'modules', 
> 'modules_install' for the kernel modules.

That one works without patching now, thanks!

AFAICS one has to manually add PF_EXT_SLIB+=set SET to
extensions/Makefile to have iptables actually compile with ipset
support. Is that the officially recommended way or did I miss some
option that makes this easier?

Do you have any plans to also support ipv6?

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)


