From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 10:50:34 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409291042240.11661@filer.marasystems.com>
References: <415A12AE.1060901@parknet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <415A12AE.1060901@parknet.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004, Simon Lodal wrote:

> I know IP address syntax should not change every day. But this will not break 
> or exclude old syntax. I do not see it clashing with other/future syntax.

There already is an old BSD syntax similar this which many people are used 
to, but with a slightly different meaning

10.1 is the same as 10.0.0.1

10.59470 is the same as 10.0.232.78

2888886350 is the same as 172.48.232.78

not very useful for netfilter thou as here one mostly wants to specify 
networks, not hosts which means that the address must always end in .0

> Only minor problem I know of is when parsing netmask which can be in cidr or 
> dotted quad form: /32 could be interpreted as a partial address, expanded to 
> 32.0.0.0. But it is simple to special case this; make it a cidr mask when 
> there is only one octet and it is <=32, otherwise interpret as dotted quad 
> (partial or not).

This is how most people do this. These numbers does not make sense as 
binary netmasks, and if you need them you can always use the quad dotted 
form.

Regards
Henrik
