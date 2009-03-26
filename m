From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter spurious ELOOP
Date: Thu, 26 Mar 2009 16:25:16 +0100
Message-ID: <49CB9E5C.50403@trash.net>
References: <200903242302.n2ON25u4024288@givry.fdupont.fr> <49CA7A19.8040805@trash.net> <49CA7AED.3050705@trash.net> <200903261622.58453.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34515 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZCZPZZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:25:25 -0400
In-Reply-To: <200903261622.58453.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch wrote:
> Hi Patrick,
> 
> On Wednesday, 25. March 2009 19:41:49 Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> The same bug was also present in ip6_tables and arp_tables.
>>> This is the patch I've committed:
>> Thomas, I think this is likely to fix the ELOOP problem you reported
>> in 2007 that we've never managed to track down:
> 
> Yes, you are right. It took me some hours to resurrect the original
> setup from 2007 and trigger the problem. The patch fixed the issue :-)
> 
> Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

Thanks for the feedback.
