From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string
 matching	infrastrure for netfilter]
Date: Fri, 14 Jan 2005 18:52:18 +0100
Message-ID: <41E806D2.6040108@trash.net>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>	
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>	
	<41E2E631.3060102@trash.net>	
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>	
	<41E73258.7030002@trash.net>
	<1105686102.7311.101.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1105686102.7311.101.camel@localhost.localdomain>
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

Rusty Russell wrote:

>It was IRC, and for IPv6 I agree with Harald that it's probably not the
>right mechanism.  I prefer a simple discriminated union and two slab
>caches (IPv4 and IPv6), which is hardcoded, but still fairly easy to
>read.
>  
>
Sounds good.

>Does that mean I should *not* send the expectation and NAT patches to
>DaveM now?  (Posted before the ct_extend patches):
>
No, I just meant we need to stop at some point some so nf_conntrack has a
chance of beeing resynced.

Regards
Patrick
