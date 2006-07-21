From: Andrew Beverley <andy@andybev.com>
Subject: Re: Connlimit and linux-2.6.17
Date: Fri, 21 Jul 2006 21:23:43 +0100
Message-ID: <44C137CF.7020408@andybev.com>
References: <44BEA42B.3000304@andybev.com>
	<Pine.LNX.4.64.0607200026310.4015@bizon.gios.gov.pl>
	<44BEB607.3000408@andybev.com>
	<Pine.LNX.4.64.0607212050390.17358@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: martin.bene@icomedias.com, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, adlan.elm@gmail.com, kraxel@bytesex.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0607212050390.17358@bizon.gios.gov.pl>
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

>>>> I (and others, see netfilter list) are having trouble compiling 
>>>> kernel 2.6.17.4 and iptables-1.3.5-20060508 to use connlimit. Once 
>>>> compiled in and I run:
> 
> OK, I fixed the connlimit extension.

Excellent!

> 
>  - download recent version of patch-o-matic-ng
> 
>  - remove "patchlets/connlimit" directory from extracted pom-ng
> 
>  - run "./runme --download"

I've downloaded 20060720 but when I run --download I get:

could not get /index
could not get http://mynodes.net/pub/linux/netfilter/patchlets/index
could not get /index
could not get http://www.nucleus.it/pom-repo/index
could not get /index
could not get http://people.netfilter.org/ole/pom//index

and connlimit does not appear. Am I doing something stupid?

>> Will it still be a patch or is it possible to get it in the stable 
>> kernel?
> 
> Connlimit goes to my external pom-ng repository.
> 

Ok, but I would *really* like to see this in the stable kernel! Who do I contact 
to encourage it to be included? IMHO it's been stable for years!

Many thanks,

Andy
