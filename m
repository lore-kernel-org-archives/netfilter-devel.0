From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH */3] several messages
Date: Fri, 26 Jan 2007 17:05:27 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701261701520.22295@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701252210090.15753@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701252314580.17844@yvahk01.tjqt.qr>
	<45BA0E79.3070307@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45BA0E79.3070307@trash.net>
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


On Jan 26 2007 15:03, Patrick McHardy wrote:
>
>ret = ...
>if (ret < 0)
>	...
>
>since this is the prefered style. Thanks Jan.


It's possibly useless to argue ;-)


>> --- linux-2.6.20-rc6.orig/include/linux/netfilter_ipv4/ip_tables.h
>> +++ linux-2.6.20-rc6/include/linux/netfilter_ipv4/ip_tables.h
>> @@ -29,8 +29,6 @@
>>  
>>  #define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
>>  #define IPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
>> -#define ipt_match xt_match
>> -#define ipt_target xt_target
>>  #define ipt_table xt_table
>>  #define ipt_get_revision xt_get_revision
>
>Applied, but I removed this part since its needed for userspace compilation.
>

Ok, did not know that offhand. Thanks for applying.

Did you pick up this question:

BTW, ip_nat_rule.c <-> nf_nat_rule.c seems to be an almost identical
copy. Schedule one for removal?


There is yet more to xt-ify, like (just look at all the #defines ip xt 
in linux/netfilter_ipv4/ip_tables.h and ip6_tables.h). However, I was 
not sure if some of the macros actually do get used by userspace code. 
Mind filling me in?


Thanks,
Jan
-- 
