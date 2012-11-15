From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: fedora plans to replace iptables with firewalld
Date: Thu, 15 Nov 2012 15:39:38 -0500
Message-ID: <50A5530A.9000509@earthlink.net>
References: <50A542CD.7030604@earthlink.net> <20121115.143737.1667162595710068997.davem@davemloft.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:58760 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab2KOVCd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:02:33 -0500
In-Reply-To: <20121115.143737.1667162595710068997.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/15/2012 02:37 PM, David Miller wrote:
> From: Stephen Clark<sclark46@earthlink.net>
> Date: Thu, 15 Nov 2012 14:30:21 -0500
>
>> Is anyone here aware that fedora is planning on replacing iptables
>> with something called firewalld?
> It's an abstraction layer built on top of iptables and ebtables,
> not a replacement.
>
> A simple read of the project web site would have told you this,
> and I encourage you to do some research in the future instead
> of spreading misinformation.
>
> Thanks.
>
This is not what it says in the feature page at
https://fedoraproject.org/wiki/Features/firewalld-default#Detailed_Description

That says:

   The services iptables, iptables-ipv6 and ebtables will be replaced by
   firewalld. system-config-firewall in it's [sic] current form will also be
   replaced.


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



