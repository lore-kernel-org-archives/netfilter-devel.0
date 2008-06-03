From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Number of concurrent connections?
Date: Tue, 3 Jun 2008 15:35:29 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A350@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:48279 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752108AbYFCUfa convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:35:30 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks - it evidently took almost a week for this to post on the list -
and I never did get an email back that said my subscription started.
Holy moley!  

Anyway, we ended up declining the project.  It turned out, of the
requirements was EAL5 certification and I wasn't able to find any Linux
distro that's gone to the trouble.

- Greg


-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net] 
Sent: Sunday, June 01, 2008 4:16 PM
To: Greg Scott
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Number of concurrent connections?

Greg Scott wrote:
> Hello -
>  
> How fast has anyone pushed netfilter?  Assuming I can put together a 
> beefy enough hardware platform, what are the possibilities of 
> supporting
> 1 million concurrent connections with at least 2gb per second stateful

> packet filtering throughput?

I've heard of a lot bigger setups with multiple (IIRC 10) million
concurrent connection.

> Let's say I can get my hands on 10gb NICs - how fast can netfilter 
> push them?

I don't know, but I'd be interested in that too :)
