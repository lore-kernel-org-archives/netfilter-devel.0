From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Unique rule ID?!
Date: Mon, 8 Nov 2004 14:43:28 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411081437490.18476@filer.marasystems.com>
References: <418F52A5.7010700@anduras.de>
	<Pine.LNX.4.61.0411081255090.17672@filer.marasystems.com>
	<418F6375.1030709@anduras.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <418F6375.1030709@anduras.de>
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

On Mon, 8 Nov 2004, Sven Anders wrote:

> Harald Welte and some others are breaking the compatibility every two or
> three ip-tables/netfilter/kernel versions. :-)

Only for patch-o-matic modules and intentionally so as there is good 
reasons why these are not (yet) in mainline. Every breakage of what is in 
mainline is a bug and gets fixed pretty quickly should it occur.

Using stuff from pom is a gamble on versions, much like any other use of 
experimental stuff is. Yes, it occationally happens, but frankly so quite 
rarely.

Lately this has started to becoming quite a bit of hinderance for the 
iptables development as there is many changes everyone agrees needs to be 
done, but can't be done in a clean manner without breaking mainline stuff.

Regards
Henrik
