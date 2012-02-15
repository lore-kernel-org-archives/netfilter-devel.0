From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: conntrack
Date: Tue, 14 Feb 2012 22:41:38 -0500
Message-ID: <4F3B2972.8020704@earthlink.net>
References: <4F3A580A.2070105@earthlink.net> <20120214195429.GD29165@1984>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:40244 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab2BODlk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Feb 2012 22:41:40 -0500
In-Reply-To: <20120214195429.GD29165@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/14/2012 02:54 PM, Pablo Neira Ayuso wrote:
> On Tue, Feb 14, 2012 at 07:48:10AM -0500, Stephen Clark wrote:
>    
>> Hi,
>>
>> Does connection tracking keep any counters on number of packets/and
>> or bytes that are
>> associated with a connection? If so how does one access them?
>>      
> echo 1>  /proc/sys/net/netfilter/nf_conntrack_acct
>
> Then, you can access them via:
>
> conntrack -L
>
>    
Thanks

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



