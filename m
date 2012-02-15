From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: conntrack
Date: Wed, 15 Feb 2012 14:27:37 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1202151426470.32480@lap-x201>
References: <4F3A580A.2070105@earthlink.net> <20120214195429.GD29165@1984> <4F3BBA86.2010208@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:58113 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2BOOtj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:49:39 -0500
In-Reply-To: <4F3BBA86.2010208@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Stephen,

On Wed, 15 Feb 2012, Stephen Clark wrote:

> I have been working with FreeBSD for about 10 years and using ipfilter. It 
> has a neat tool ipfstat -t which show the state table
> sort of like top. It is very useful if someone is hogging the network because 
> it is sorted by the highest user first. We are switching
> our systems to Linux and would like to know fs there anything like this for 
> conntrack?
>
> Src: 0.0.0.0, Dest: 0.0.0.0, Proto: any, Sorted by: # bytes
>
> Source IP             Destination IP         ST   PR   #pkts    #bytes 
> ttl
> 192.168.198.105,5353  224.0.0.251,5353      0/0  udp   22598   3736235 
> 1:57

iftop does something like this, not looking at the conntrack table but it 
may help.

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 760887
The Humanitarian Centre, Fenner's, Gresham Road, Cambridge CB1 2ES

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

