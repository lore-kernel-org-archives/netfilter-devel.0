From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: [Fwd: ipt_connlimit.c from pom-ng contains error]
Date: Wed, 16 Feb 2005 20:27:23 -0500
Message-ID: <4213F2FB.5050108@cookinglinux.org>
References: <1108538829.13398.8.camel@localhost.localdomain>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-5; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, warm@stack.ru
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1108538829.13398.8.camel@localhost.localdomain>
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
> -------- Forwarded Message --------
> From: Zharovtsev, Anton <warm@stack.ru>
> To: rusty@rustcorp.com.au
> Subject: ipt_connlimit.c from pom-ng contains error
> Date: Wed, 16 Feb 2005 13:02:25 +0600
> Hello.
> 
> [...]
>   CC [M]  net/ipv4/netfilter/ipt_connlimit.o
> net/ipv4/netfilter/ipt_connlimit.c: In function `count_them':
> net/ipv4/netfilter/ipt_connlimit.c:100: error: structure has no member named `infos'
> net/ipv4/netfilter/ipt_connlimit.c:107: error: structure has no member named `infos'
> make[3]: *** [net/ipv4/netfilter/ipt_connlimit.o] ¾èØÑÚÐ 1
> make[2]: *** [net/ipv4/netfilter] Error 2
> make[1]: *** [net/ipv4] Error 2
> make: *** [net] Error 2
> root@wasp:/usr/src/linux#

Anton, this bug has been fixed according to bugzilla :

https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=268

> 
> I will turn off this module, but I think it is very usefull for many peoples and.
> This letter is my small bug report :-).

Harald applied it against the 2.6 branch. Just check out the module from there and you are done.

svn co http://svn.netfilter.org/netfilter/branches/patch-o-matic-ng/linux-2.6.11/connlimit

> 
> Sorry again.

Best regards,
Samuel
