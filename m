From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tc filtering vs iptables
Date: Sat, 28 Aug 2004 01:49:48 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408280138290.10193@filer.marasystems.com>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
	<1093632324.14188.2.camel@jzny.localdomain>
	<1093635866.14191.9.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jamal Hadi Salim <hadi@znyx.com>
In-Reply-To: <1093635866.14191.9.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 27 Aug 2004, Jamal Hadi Salim wrote:

> On Fri, 2004-08-27 at 14:45, jamal wrote:
>
>> Any recommendation of how i should arrange the chains?
>
> Ok, how does this sound:
>
> 256 chains:  subnet_0 .. subnet_255
>
> In each chain, there are 256 rules specifying a host in each
> (.0 ....255).
>
> This creates a maximum of 65536 rules with hosts from 10.1.0.0 to
> 10.1.255.255.

If you have the need of individually classifying all IP addresses in a 
whole 'B' network I would probably split it on a more granular level to 
keep the number of rules down to 16 or so per chain, this gives a worst 
case of 16 + 16 + 16 + 16 lookups which is a bit better than 256 + 256, 
and use ranges where possible to further cut down the number of rules.

How would this look like with the u32 thing in tc?

I think I have lost some of the picture of the classification you are 
trying to accomplish. Can you please describe it again?

Regards
Henrik
