From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
 infrastrure for netfilter]
Date: Mon, 10 Jan 2005 21:31:45 +0100
Message-ID: <41E2E631.3060102@trash.net>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:

>On Mon, 10 Jan 2005, Patrick McHardy wrote:
>
>
>>I have actually given up keeping nf_conntrack up to date currently, but
>>I hope we can now really put ip_conntrack in maintenance mode and
>>concentrate
>>on nf_conntrack. Any chance you want to base this on the nf_conntrack
>>patch ?
>>
>
>Actually, what is the opinion that nf_conntrack uses the union of IPv4 and
>IPv6 addresses in the tuples?
>
In my opinion that's something that could also be improved later.

>The infrastructure is there in the patch to support IPv4/IPv6 conntrack
>separatedly in spite of the common code and not to waste so many bytes at
>every IPv4 connections for the sake of supporting IPv6.
>
You mean the get_features stuff and seperate caches ? I'm don't like this
part very much, I thing Rusty's "structure extension stuff" (ct_extend)
is a nicer way to do this, although its probably not useable for the tuples.

> Shouldn't there be
>put more effort into this long standing issue, before swithcing over it?
>  
>
I think we should put ip_conntrack in maintenance mode, than we can
resync nf_conntrack and make changes like this before we submit it.

Regards
Patrick
