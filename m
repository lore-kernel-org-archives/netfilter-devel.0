From: Pablo Neira <pablo@eurodev.net>
Subject: Re: building libctnetlink
Date: Thu, 24 Mar 2005 13:58:31 +0100
Message-ID: <4242B977.1030607@eurodev.net>
References: <423BF227.8030502@outerspace.dyndns.org>	
	<423BF4DC.2070902@outerspace.dyndns.org>	
	<1111335091.2523.46.camel@lap-ufomechanic>	
	<1111335425.2523.49.camel@lap-ufomechanic>
	<423DF940.100@eurodev.net>	
	<1111412190.2716.55.camel@lap-ufomechanic>
	<423F007F.2060102@eurodev.net>
	<1111667756.2526.19.camel@lap-ufomechanic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: oscar@ufomechanic.net
In-Reply-To: <1111667756.2526.19.camel@lap-ufomechanic>
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

Just another UFO mechanic wrote:
> I am still trying to compile libctnetlink and libnfnetlink I cannot find
> a whole lot of info on it. I have 2 questions
> 
> When I try compile
> I get the error
> libctnetlink.c:32:39 linux/nfnetlink_conntrack.h: No such file or
> directory

Have you applied `nfnetlink-ctnetlink-0.13' in pom-ng? Add 
-I/your/kernel/include/path to your compilation script.


> Secondly
> Because this should be in linux/* this tells me that it may belong to an
> older kernel or something that is now deprecated, is that so ? I am
> trying to compile on 2.6.10

Unfortunately that won't work with your current kernel, AFAIK those 
patches work fine for most 2.4.x releases. Anyhow I'm currently working 
on porting them to 2.6.11 so you could wait until I post them in the 
mailing list.

--
Pablo
