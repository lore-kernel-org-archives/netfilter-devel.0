From: Simon Lodal <simonl@parknet.dk>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 18:37:34 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415AE4CE.3030305@parknet.dk>
References: <415A12AE.1060901@parknet.dk>
	<Pine.LNX.4.61.0409291042240.11661@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ben Efros <ben@xgendev.com>, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.61.0409291042240.11661@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom skrev:
> There already is an old BSD syntax similar this which many people are 
> used to, but with a slightly different meaning
> 
> 10.1 is the same as 10.0.0.1
Interesting, thanks.

When people talk about the 10.44 network, I assume they append .0.0, not 
insert them in the middle. My proposal does that with a double dot, eg. 
10..44 = 10.0.0.44.

The old syntax could actually be supported if we always require 
leading/trailing/double dot. In other words:
1) .b.c.d | .c.d | .d
2) a..d | a..c.d | a.b..d
3) a. | a.b. | a.b.c.

They all require special dotting, so none of them clash with an address 
that just lacks some octets, eg. "10.1". We can then choose to support 
that in it's own way.

Note that "10.1" and "10..1" would both expand to 10.0.0.1 but have 
different defaults netmasks: /32 vs. 255.0.0.255.

> 10.59470 is the same as 10.0.232.78
> 
> 2888886350 is the same as 172.48.232.78
I understand if that is being deprecated.

They could at least have used hex!

> not very useful for netfilter thou as here one mostly wants to specify 
> networks, not hosts which means that the address must always end in .0
I also want compact syntax for groups of similar hosts in different 
nets. I have a bunch of class C nets internally, in each .1 is the 
router, I want to match traffic directly to/from them: 
"10.0.0.1/255.0.0.255". It is possible but looks ugly, so I want 
simplification, in this case "10..1". Parsed result is the same.

What I also want is a way to only specify the least significant bits. If 
I do not care about the first octet (10), the above would just become ".1".


Simon
