From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Fri, 4 Jul 2008 16:14:35 +0200
Message-ID: <200807041614.35900.ludwig.nussel@suse.de>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu> <200807041553.41535.ludwig.nussel@suse.de> <alpine.LNX.1.10.0807041600150.1890@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYGDOOh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:14:37 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 8A64645A86
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2008 16:14:36 +0200 (CEST)
In-Reply-To: <alpine.LNX.1.10.0807041600150.1890@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-07-04 15:53, Ludwig Nussel wrote:
> >
> >AFAICS one has to manually add PF_EXT_SLIB+=set SET to
> 
> Not in 1.4.1 and up, which is what you should be using.

Ah, the build system was changed. We still have 1.4.0 in the repo.
Needs to be updated.

> Also, since you come from @suse.de, I might infer that ipset
> is a candidate for the distro kernel in which case one would
> rather want it as additional modules.

So far there has been no request to include ipset support in any
SUSE distribution. I've just created ipset add-on packages in the
openSUSE build service for personal interest.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)





