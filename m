From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: netfilter & ipv6
Date: Thu, 10 Feb 2005 19:20:34 +0200
Message-ID: <420B97E2.3090003@niksula.hut.fi>
References: <42086F50.9090504@niksula.hut.fi> <420B6A93.3080005@niksula.hut.fi>
	<60195.142.169.215.10.1108046474.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Samuel Jean <sj-netfilter@cookinglinux.org>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <60195.142.169.215.10.1108046474.squirrel@142.169.215.10>
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

Samuel Jean wrote:

>On Thu, February 10, 2005 9:07 am, Jonas Berlin said:
>
>Hi Jonas!
>  
>
Hello Samuel!

>>  ip6tables ... -j CLASSIFY_v6 --set-class 1:20
>>
>>Although this works fine, having some modules with suffix _v6 and some
>>not is just plain confusing. Is there any way to reuse the CLASSIFY for
>>ipv6 name without conflicting with the CLASSIFY module already in pom?
>>Maybe I missed something?
>>    
>>
>
>You have to create an ipv6 directory into the CLASSIFY in pom.
>
>CLASSIFY/linux/net/ipv6/netfilter/ip6t_CLASSIFY.c
>  
>
Yeah that would be nice, but I think there is a problem: the newest 
kernels already have the ipv4 version included, and so patch-o-matic 
would either consider CLASSIFY already installed and skip it or then it 
would probably complain while installing that it there were some 
conflicts with the files. I haven't tested though, but I wouldn't assume 
it has the logic to pick out the ipv6-specific parts from the directory..

>Also, just register your target against ip6_tables with the same name
>as CLASSIFY would do with ip_tables. There's no conflict in that way.
>  
>
Yeah, it does work fine as CLASSIFY_v6..

>All of this is a AFAIK.
>  
>
Same here :D

>Thanks for your effort,
>Samuel
>  
>
Thanks for the reply.. I haven't got any others yet.

-- 
- xkr47
