From: Roberto Nibali <ratz@tac.ch>
Subject: Re: Fixed Re: iptables 1.3.1 crashes on iptables-restore
Date: Mon, 08 Aug 2005 17:56:35 +0200
Message-ID: <42F780B3.3030102@tac.ch>
References: <20050330034616.GA8639@samad.com.au>	<424BB242.6070809@drugphish.ch>	<42F24151.1090702@ufomechanic.net>	<42F33AAD.8060201@ufomechanic.net>	<dcvnn9$vpl$1@sea.gmane.org>
	<42F367FF.7060605@drugphish.ch> <42F77E2E.2090307@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42F77E2E.2090307@ufomechanic.net>
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

> Yes, I need the latest and greatest conntrack stuff, naturally ;-)

So you run a 2.6.14 kernel :)

>>What's the output /lib/libc.so.6? 
>  
> I'm not sure what you mean here, but ls -l shows:
> /lib/libc.so.6 -> libc-2.3.2.so

Invoke /lib/libc.so.6 like a command. It won't destroy your system but
it will display how your libc was crafted.

>>Just out of curiosity. And maybe if you set LD_DEBUG=all and run iptables?
>  
> It doesn't show anything interesting, iptables-restore does when
> restoring L7 rules that use fopen/fclose, they show:
> ...
> ...
>      25033:     binding file /lib/libnss_files.so.2 to
> /lib/tls/libc.so.6: normal symbol `fclose' [GLIBC_2.1]
>      25033:     file=/lib/iptables/libipt_tcp.so;  generating link map
>      25033:       dynamic: 0xb7fd727c  base: 0xb7fd4000   size: 0x0000335c
>      25033:         entry: 0xb7fd4788  phdr: 0xb7fd4034  phnum:          3
> ...
> ...
> 
> I have to say I'm not sure what libnss* is about here, I thought libnss
> stuff was for yp/niss/ldap lookup and the like for getXXXbyYYY libc
> calls, libnss_files.so starts to look like a filesystem redirector for
> user-filesystems which I thought glibc folk were dead against.  Anyway....

libnss is a long and sad story in glibc development, especially when it
comes to linking ...

>>Also the ldd /sbin/iptables 
> 
> ldd iptables shows:
>         libdl.so.2 => /lib/libdl.so.2 (0xb7fe1000)
>         libc.so.6 => /lib/tls/libc.so.6 (0x42000000)
>         /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0xb7feb000)
>  
>>and LD_TRACE_LOADED_OBJECTS=1 setting may give you more input.
> 
> 
> LD_DEBUG=all LD_TRACE_LOADED_OBJECTS=1 iptables-restore < ~/IPTABLES.BAD

I don't see anything obviously strange, so I can't help you here, sorry.

Regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
