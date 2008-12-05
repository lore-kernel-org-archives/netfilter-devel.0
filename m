From: Patrick McHardy <kaber@trash.net>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 19:39:11 +0100
Message-ID: <4939754F.50905@trash.net>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net> <49396E91.1060403@redfish-solutions.com> <49396F30.3@trash.net> <49397007.9030809@redfish-solutions.com> <493970C0.2070003@trash.net> <493973BE.9010001@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62057 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbYLESjO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:39:14 -0500
In-Reply-To: <493973BE.9010001@redfish-solutions.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Prindeville wrote:
> Patrick McHardy wrote:
>> Try sip_direct_media=0
> 
> That's not an option in 2.6.25.19...  when did it get introduced?  Do we 
> need to run a more recent version to pick up useful fixes?
> 
> Also, does 2.6.25.19 include the port-range helpers?
> 
> Unless I'm misunderstanding something....

That version is known not to work very well, 2.6.26 includes
a largely rewritten version.

This is a backport to 2.6.25:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.25-sip.git
