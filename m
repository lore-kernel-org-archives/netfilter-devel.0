From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: ipt_account / iptables 1.3.8
Date: Wed, 27 Jun 2007 21:03:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706272059590.11120@fbirervta.pbzchgretzou.qr>
References: <1182962627.16585.6.camel@localhost>
	<4682A981.3090608@plouf.fr.eu.org> <4682ACE2.8020606@blue-labs.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: David Ford <david@blue-labs.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4682ACE2.8020606@blue-labs.org>
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


On Jun 27 2007 14:30, David Ford wrote:
>Pascal Hambourg wrote:
>> <quote>
>> - Remove extensions for unmaintained/obsolete patchlets
>> </quote>
>>
>> AFAIK, the concerned extensions are : fuzzy, nth, random (both
>> superseded by statistic), ROUTE, account, BALANCE, childlevel,
>> connlimit, dstlimit, FTOS, IPMARK, ipv4options, IPV4OPTSSTRIP, mport,
>> NETLINK, osf, psd, record_rpc, rpc, TARPIT, TCPLAG, time, TRACE, u32,
>> XOR.
>
>Is there something that functionally replaces TARPIT?
>
Uhm, please add a reference next time; only by chance I found the thread origin
at the netfilter@ list.

No idea why TARPIT got removed. Maybe it's "unmaintained", but it did not need
a lot of maintenance either. Though, people had to patch their kernel.

There is no replacement for TARPIT - it's solid. (And xt_DELUDE does not
replace it; it is something inbetween REJECT and TARPIT.)


	Jan
-- 
