From: Amin Azez <azez@ufomechanic.net>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Thu, 14 Apr 2005 17:03:33 +0100
Message-ID: <425E9455.20601@ufomechanic.net>
References: <425A5543.9000300@ufomechanic.net>
	<20050414175957.0334.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050414175957.0334.LARK@linux.net.cn>
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

Thanks for your feedback Wang, comments inline

Wang Jian wrote:
> This patch is reversed.

*sign* so it is, how embarrassing, thanks for spotting that.

>>13) build ctnltest.c with
>>15) try out ctnltest:
>>./ctnltest
>>It should print out data on active network connections
>>It doesn't print out data on new connections as they form, I don't know 
>>if it should.
> 
> 
> Looking at the code, it looks like it should
> 
> in __ip_conntrack_confirm()
> 
>                 ip_conntrack_event_cache(master_ct(ct) ?
>                                          IPCT_RELATED : IPCT_NEW, *pskb);
> 
> But no one calls it.

Thanks, I will take a look at this. I realised that something needed to 
be done with ip_conntrack_event_cache, but didn't think it was in there. 
I had seen that the IPCNTL_MSG_UPDCONNTRACK was not implemented and I am 
supposing that is for tracking ther updates, so I'm just working out the 
approach to add that. Its a straightforward job I am sure, but I am 
still getting familiar with the netlink internals.

When I wrote that I was a little unsure at what ctnltest was supposed to 
do, since then I have added upport for the CONFIG_IP_NF_CT_ACCT byte and 
packet counters to the nfnetlink_ctnetlink patches that Pablo put 
together. I sent this to Pablo, but now he has since released his 
changes as a pom-ng so I shall do that for the CONFIG_IP_NF_CT_ACCT 
enhancements I did unless he beats me to it.

Amin
