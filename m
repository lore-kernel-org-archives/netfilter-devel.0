From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Sat, 21 Jan 2012 21:12:39 +1300
Message-ID: <4F1A7377.5050301@treenet.co.nz>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com> <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu> <4F135552.4070804@googlemail.com> <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu> <4F175B94.60001@googlemail.com> <alpine.DEB.2.00.1201191154330.7547@blackhole.kfki.hu> <4F189283.4000401@googlemail.com> <alpine.DEB.2.00.1201201342400.11124@blackhole.kfki.hu> <4F199A38.5070702@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4F199A38.5070702@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 21/01/2012 5:45 a.m., Mr Dash Four wrote:
>
>> Doable, but needs time and would involve adding the logic to 
>> auto-merge smaller subnets into larger ones and to make possible to 
>> delete subnets from larger networks.
> Merging of ip ranges would be very difficult - I am having the same 
> problem here as well. I use PostgreSQL as part of my setup and even 
> though it has some nice capabilities to deal with "common" 
> ip/range/net address operations, it is still very difficult, 
> nigh-impossible to deal with ip range merges, simply because there are 
> so many possible scenarios: any two ranges could be partially 
> overlapping - like [ (] ), one range completely overlapping another - 
> like [ () ], or two ranges "touching" one another - like [ ]( ) - that 
> last one is very difficult to spot for merging and can't see it done 
> very easily.

Jozsef, have you had a look at how rbldnsd handles ranges? It has to 
deal with the same issues as ipset seems to be facing now, also at some 
high speed requirements. Maybe you could pull some inspiration out of that.

AYJ

