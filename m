From: mqe@usr.fi
Subject: Re: Kernel 2.6.2 and "string" match patch (pom-ng)
Date: Sat, 14 Feb 2004 23:00:45 +0200 (EET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3923.193.166.136.195.1076792445.squirrel@webmail.usr.fi>
References: <402827FC.2000209@teczowe.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <402827FC.2000209@teczowe.eu.org>
To: "Leszek Zur" <lzur@teczowe.eu.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

To be honest, i have not checked what is going on with that smp_num_cpus.
It has moved / changed name or something like that. Anyhow, i modified
ipt_string.c just to fit my machine. smp_num_cpus is number of processors,
so I just changed it to "1". Though, this is not product environment - i
will look that more as soon as i have time.



> make bzImage
> ...
>    CC      net/ipv4/netfilter/ipt_tos.o
>    CC      net/ipv4/netfilter/ipt_string.o
> net/ipv4/netfilter/ipt_string.c: In function `search_sublinear':
> net/ipv4/netfilter/ipt_string.c:55: warning: subscript has type `char'
> net/ipv4/netfilter/ipt_string.c:80: warning: subscript has type `char'
> net/ipv4/netfilter/ipt_string.c: In function `string_freeup_data':
> net/ipv4/netfilter/ipt_string.c:166: `smp_num_cpus' undeclared (first
> use in this function)
> net/ipv4/netfilter/ipt_string.c:166: (Each undeclared identifier is
> reported only once
> net/ipv4/netfilter/ipt_string.c:166: for each function it appears in.)
> net/ipv4/netfilter/ipt_string.c: At top level:
> net/ipv4/netfilter/ipt_string.c:176: warning: initialization from
> incompatible pointer type
> net/ipv4/netfilter/ipt_string.c: In function `init':
> net/ipv4/netfilter/ipt_string.c:184: `smp_num_cpus' undeclared (first
> use in this function)
> make[3]: *** [net/ipv4/netfilter/ipt_string.o] Error 1
> make[2]: *** [net/ipv4/netfilter] Error 2
> make[1]: *** [net/ipv4] Error 2
> make: *** [net] Error 2
>
>
> has anybody been using the string match from the patch-o-matic-ng
> with kernel 2.6.x yet?
>
> Leszek
