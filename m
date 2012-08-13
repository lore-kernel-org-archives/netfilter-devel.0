From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: nat not working as expected
Date: Mon, 13 Aug 2012 13:57:09 -0400
Message-ID: <50293FF5.9060209@earthlink.net>
References: <50293E61.8080308@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:33676 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377Ab2HMSHZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:07:25 -0400
In-Reply-To: <50293E61.8080308@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for the noise - I had some routes set in an alternative routeing 
table that was
routing out a gre over a vpn.


On 08/13/2012 01:50 PM, Stephen Clark wrote:
> Hello,
>
> I have a problem I am trying to solve and nat doesn't seem to be 
> working. I have a set of ip addresses I don't
> want to go thru my transparent proxy so I have the following:
>
>  Chain PREROUTING (policy ACCEPT 1413 packets, 206K bytes)
>  pkts bytes target     prot opt in     out     source               
> destination
>     0     0 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
> 10.0.0.0/8          tcp dpt:80
> ...
>     0     0 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
> 8.15.7.123          tcp dpt:80
>     2   120 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
> 216.16.243.121      tcp dpt:80
>     0     0 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
> 216.16.242.222      tcp dpt:80
>  ...
>     0     0 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
> 216.171.106.210     tcp dpt:80
>     0     0 DNAT       tcp  --  eth0   *       10.254.150.0/24      
> 0.0.0.0/0           tcp dpt:80 to:10.254.150.1:8080
>
> Chain POSTROUTING (policy ACCEPT 922 packets, 81534 bytes)
>  pkts bytes target     prot opt in     out     source               
> destination
>     0     0 ACCEPT     all  --  *      eth1    10.254.150.0/24      
> 10.0.0.0/8
>     0     0 ACCEPT     all  --  *      eth1    10.254.150.0/24      
> 172.16.0.0/12
>     0     0 ACCEPT     all  --  *      eth1    10.254.150.0/24      
> 192.168.0.0/16
>     0     0 SNAT       all  --  *      eth1    10.254.150.0/24      
> 0.0.0.0/0           to:xxx.xxx.149.209
>
> My packet hits the pre-routing chain and is accepted but then seems to 
> get lost, it doesn't get
> natted and go out my external interface.
>
> tcpdump on internal interface:
> 13:33:03.157163 IP 10.254.150.91.53169 > 216.16.243.121.http: Flags 
> [S], seq 1127713574, win 5840, options [mss 1460,sackOK,TS val 
> 2344806144 ecr 0,nop,wscale 6], length 0
>
> nothing shows on external interface:
>
> The routing looks correct.
> $ ip r g 216.16.243.121
> 216.16.243.121 via xxx.xxx.149.1 dev eth1  src xxx.xxx.149.209
>
>
> What am I missing?
>
> Thanks for your indulgence,
> Steve
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



