From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] ebtables: Possible problems found by static analysis
 of code
Date: Wed, 15 Jun 2011 22:37:09 +0200
Message-ID: <4DF917F5.9000605@pandora.be>
References: <4DF738AE.3060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:45553 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1FOUhO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:37:14 -0400
In-Reply-To: <4DF738AE.3060306@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 14/06/2011 12:32, Jiri Popelka schreef:
> Hello,
>
> we had analyzed the ebtables-v2.0.9-2 code with Coverity.
> Coverity is commercial enterprise level tool for
> static analysis (analysis based only on compiling of sources,
> not based on running of binary) of the code.
>
> As a result I have the following patches that should fix some possible 
> problems.
> There's a respective part(s) of the Coverity error log in each patch.
>

Thanks,

I'll have a closer look at them later this week.

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

