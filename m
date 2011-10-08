From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: SNAT before IPSEC - why?
Date: Sat, 08 Oct 2011 17:15:27 -0400
Message-ID: <4E90BD6F.40101@earthlink.net>
References: <4E8FB084.6030807@earthlink.net> <alpine.DEB.2.00.1110080902550.3657@lap-x201>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:33387 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891Ab1JHVP3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Oct 2011 17:15:29 -0400
In-Reply-To: <alpine.DEB.2.00.1110080902550.3657@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/08/2011 04:06 AM, Chris Wilson wrote:
> Hi Stephen,
>
> On Fri, 7 Oct 2011, Stephen Clark wrote:
>
>> What is the reasoning for having SNAT happen before ipsec encryption?
>
> You might well want to SNAT or MASQUERADE packets going through the 
> tunnel, to have them fit within the tunnel's subnet, for example if 
> you add a new local subnet and you don't want to reconfigure thousands 
> of clients.
>
>> It forces one to add special rules in the NAT table to keep this from 
>> happening
>
> You mean "iptables -t nat -A POSTROUTING -m policy --pol ipsec -j 
> ACCEPT"? Doesn't seem very onerous to me.
>
No, but that is different than what I had been using which is:
-A POSTROUTING -o eth1 -s 10.152.35.0/24 -d 10.159.95.0/24 -j ACCEPT

How does -m policy --pol ipsec figure in? I am somewhat new to iptables 
having
been working with ipfilter/ipnat on FreeBSD for the last 10 years, so 
pardon my
ignorance.

> Cheers, Chris.


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



