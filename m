From: Sam Liddicott <sliddicott@dbamsystems.com>
Subject: no ctstat? Re: building libctnetlink
Date: Mon, 04 Apr 2005 17:25:33 +0100
Message-ID: <d2rpmi$3n8$1@sea.gmane.org>
References: <423BF227.8030502@outerspace.dyndns.org>		<423BF4DC.2070902@outerspace.dyndns.org>		<1111335091.2523.46.camel@lap-ufomechanic>		<1111335425.2523.49.camel@lap-ufomechanic>	<423DF940.100@eurodev.net>		<1111412190.2716.55.camel@lap-ufomechanic>	<423F007F.2060102@eurodev.net>	<1111667756.2526.19.camel@lap-ufomechanic>
	<4242B977.1030607@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4242B977.1030607@eurodev.net>
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

Pablo Neira wrote:
> Just another UFO mechanic wrote:
> 
>> I am still trying to compile libctnetlink and libnfnetlink I cannot find
>> a whole lot of info on it. I have 2 questions
>>
>> When I try compile
>> I get the error
>> libctnetlink.c:32:39 linux/nfnetlink_conntrack.h: No such file or
>> directory
> 
> 
> Have you applied `nfnetlink-ctnetlink-0.13' in pom-ng? Add 
> -I/your/kernel/include/path to your compilation script.

Thanks for the tip Pablo; probably a case of user error; but:

When I try to apply nfnetlink-ctnetlink-0.13 from the latest pom-ng 
(20050403), I am told:

nfnetlink-ctnetlink-0.13 has dependency on ctstat, but ctstat is not known
cannot apply (9 rejects out of 42 hunks)

As far as I can tell ctstats was added to pom-ng in around September 
2004 time. There is a ctstat folder in my un-tar'd pom-ng, but it is empty.

I'm running patch-o-matic against iptables 1.2.11 and kernel 2.6.10
source.

Sam
