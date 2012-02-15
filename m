From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: conntrack
Date: Wed, 15 Feb 2012 09:00:38 -0500
Message-ID: <4F3BBA86.2010208@earthlink.net>
References: <4F3A580A.2070105@earthlink.net> <20120214195429.GD29165@1984>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:49433 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106Ab2BOOAk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:00:40 -0500
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
Hi Pablo,

I have been working with FreeBSD for about 10 years and using ipfilter. 
It has a neat tool ipfstat -t which show the state table
sort of like top. It is very useful if someone is hogging the network 
because it is sorted by the highest user first. We are switching
our systems to Linux and would like to know fs there anything like this 
for conntrack?

Src: 0.0.0.0, Dest: 0.0.0.0, Proto: any, Sorted by: # bytes

Source IP             Destination IP         ST   PR   #pkts    
#bytes       ttl
192.168.198.105,5353  224.0.0.251,5353      0/0  udp   22598   
3736235      1:57
10.0.254.32,631       10.0.255.255,631      0/0  udp   11872   
2623712      1:29
192.168.198.103,5353  224.0.0.251,5353      0/0  udp   10608   
1720665      1:56
192.168.198.103,5353  224.0.0.251,5353      0/0  udp   10608   
1720665      1:56
10.0.254.32,5353      224.0.0.251,5353      0/0  udp    9807   
1680621      1:56
10.0.254.32,5353      224.0.0.251,5353      0/0  udp    9806   
1680485      1:56
192.168.198.166,50676 192.168.198.75,8181   4/4  tcp    2412   1548504  
81:09:04
192.168.198.148,137   192.168.198.255,137   0/0  udp   18625   
1452750      1:51
10.0.254.32,631       10.0.255.255,631      0/0  udp    6082   
1344122      1:29
192.168.198.148,137   192.168.198.255,137   0/0  udp   14186   
1107048      1:51
10.0.129.11,5353      224.0.0.251,5353      0/0  udp    5841   
1016739      1:56
10.0.129.11,5353      224.0.0.251,5353      0/0  udp    5840   
1016566      1:56
192.168.198.148,137   192.168.198.255,137   0/0  udp   12427    
969306      1:51
10.0.133.2,34114      216.17.35.103,143     4/4  tcp   13118    852888 
119:59:36
192.168.198.105,5353  224.0.0.251,5353      0/0  udp    3790    
828335      1:57
192.168.198.8,5353    224.0.0.251,5353      0/0  udp    5856    
826713      1:57
192.168.198.8,5353    224.0.0.251,5353      0/0  udp    5856    
826713      1:57
192.168.198.108,5353  224.0.0.251,5353      0/0  udp    5850    
813786      1:56
192.168.198.108,5353  224.0.0.251,5353      0/0  udp    5850    
813786      1:56


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



