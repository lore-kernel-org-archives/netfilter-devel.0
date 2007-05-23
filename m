From: Andrea <andang76@gmail.com>
Subject: Re: problems applying ipset patch
Date: Wed, 23 May 2007 11:10:54 +0200
Message-ID: <4654051E.8060508@gmail.com>
References: <4653F176.4040604@gmail.com>	
	<1179908784.18674.39.camel@henriknordstrom.net>	
	<4654006D.9050704@gmail.com>
	<1179910939.18674.46.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1179910939.18674.46.camel@henriknordstrom.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom ha scritto:
> ons 2007-05-23 klockan 10:50 +0200 skrev Andrea:
>> Henrik Nordstrom ha scritto:
>>
>>> Which kernel version?
>>
>> In the second try used linux-2.6.16.51.tar from www.kernel.org and 
>> patch-o-matic-ng-20070521
> 
> Try with a newer kernel. There is more than a year difference between
> your kernel and your pom-ng release.

????

2.6.16.51 has been released in 09 May 2007, as stated in 
http://www.kernel.org/pub/linux/kernel/v2.6/?C=M;O=A

> 
> Also make sure CONFIG_NETFILTER_XTABLES is enabled in your kernel
> config.

it seems it's not set. Maybe the problem is here. I'll try again.

Thanks
