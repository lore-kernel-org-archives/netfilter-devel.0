From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Fixed Re: iptables 1.3.1 crashes on iptables-restore
Date: Mon, 08 Aug 2005 16:45:50 +0100
Message-ID: <42F77E2E.2090307@ufomechanic.net>
References: <20050330034616.GA8639@samad.com.au>	<424BB242.6070809@drugphish.ch>	<42F24151.1090702@ufomechanic.net>	<42F33AAD.8060201@ufomechanic.net>
	<dcvnn9$vpl$1@sea.gmane.org> <42F367FF.7060605@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
In-Reply-To: <42F367FF.7060605@drugphish.ch>
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

Roberto Nibali wrote:

> Amin Azez wrote:
>
>> The futex hanging was in glibc during fclose() (!!!)
>
>
> Strange. So you run a 2.6.x kernel.
>
Yes, I need the latest and greatest conntrack stuff, naturally ;-)

>> The fix was as simple as:
>>
>> LD_ASSUME_KERNEL=2.2.5
>>
>> environment variable.
>
>
> Which would disable TLS.
>
>> I guess my kernel version is too high for my glibc version or something
>> like that!
>
>
> What's the output /lib/libc.so.6? 

I'm not sure what you mean here, but ls -l shows:
/lib/libc.so.6 -> libc-2.3.2.so

> Just out of curiosity. And maybe if you set LD_DEBUG=all and run iptables?

It doesn't show anything interesting, iptables-restore does when
restoring L7 rules that use fopen/fclose, they show:
...
...
     25033:     binding file /lib/libnss_files.so.2 to
/lib/tls/libc.so.6: normal symbol `fclose' [GLIBC_2.1]
     25033:     file=/lib/iptables/libipt_tcp.so;  generating link map
     25033:       dynamic: 0xb7fd727c  base: 0xb7fd4000   size: 0x0000335c
     25033:         entry: 0xb7fd4788  phdr: 0xb7fd4034  phnum:          3
...
...

I have to say I'm not sure what libnss* is about here, I thought libnss
stuff was for yp/niss/ldap lookup and the like for getXXXbyYYY libc
calls, libnss_files.so starts to look like a filesystem redirector for
user-filesystems which I thought glibc folk were dead against.  Anyway....

> Also the ldd /sbin/iptables 

ldd iptables shows:
        libdl.so.2 => /lib/libdl.so.2 (0xb7fe1000)
        libc.so.6 => /lib/tls/libc.so.6 (0x42000000)
        /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0xb7feb000)


> and LD_TRACE_LOADED_OBJECTS=1 setting may give you more input.

LD_DEBUG=all LD_TRACE_LOADED_OBJECTS=1 iptables-restore < ~/IPTABLES.BAD

     25325:
     25325:     file=libdl.so.2;  needed by iptables-restore
     25325:     find library=libdl.so.2; searching
     25325:      search cache=/etc/ld.so.cache
     25325:       trying file=/lib/libdl.so.2
     25325:
     25325:     file=libdl.so.2;  generating link map
     25325:       dynamic: 0xb7fe3008  base: 0xb7fe1000   size: 0x000021ac
     25325:         entry: 0xb7fe26f0  phdr: 0xb7fe1034  phnum:          6
     25325:
     25325:
     25325:     file=libc.so.6;  needed by iptables-restore
     25325:     find library=libc.so.6; searching
     25325:      search cache=/etc/ld.so.cache
     25325:       trying file=/lib/tls/libc.so.6
     25325:
     25325:     file=libc.so.6;  generating link map
     25325:       dynamic: 0x42130920  base: 0x00000000   size: 0x00132f08
     25325:         entry: 0x42015660  phdr: 0x42000034  phnum:          8
     25325:
     25325:     checking for version `GLIBC_2.1' in file /lib/libdl.so.2
required by file iptables-restore
     25325:     checking for version `GLIBC_2.0' in file /lib/libdl.so.2
required by file iptables-restore
     25325:     checking for version `GLIBC_2.1' in file
/lib/tls/libc.so.6 required by file iptables-restore
     25325:     checking for version `GLIBC_2.3' in file
/lib/tls/libc.so.6 required by file iptables-restore
     25325:     checking for version `GLIBC_2.0' in file
/lib/tls/libc.so.6 required by file iptables-restore
     25325:     checking for version `GLIBC_PRIVATE' in file
/lib/ld-linux.so.2 required by file /lib/libdl.so.2
     25325:     checking for version `GLIBC_2.3' in file
/lib/tls/libc.so.6 required by file /lib/libdl.so.2
     25325:     checking for version `GLIBC_2.1.3' in file
/lib/tls/libc.so.6 required by file /lib/libdl.so.2
     25325:     checking for version `GLIBC_2.1' in file
/lib/tls/libc.so.6 required by file /lib/libdl.so.2
     25325:     checking for version `GLIBC_PRIVATE' in file
/lib/tls/libc.so.6 required by file /lib/libdl.so.2
     25325:     checking for version `GLIBC_2.0' in file
/lib/tls/libc.so.6 required by file /lib/libdl.so.2
     25325:     checking for version `GLIBC_2.3' in file
/lib/ld-linux.so.2 required by file /lib/tls/libc.so.6
     25325:     checking for version `GLIBC_2.1' in file
/lib/ld-linux.so.2 required by file /lib/tls/libc.so.6
     25325:     checking for version `GLIBC_2.0' in file
/lib/ld-linux.so.2 required by file /lib/tls/libc.so.6
     25325:     checking for version `GLIBC_PRIVATE' in file
/lib/ld-linux.so.2 required by file /lib/tls/libc.so.6
        libdl.so.2 => /lib/libdl.so.2 (0xb7fe1000)
        libc.so.6 => /lib/tls/libc.so.6 (0x42000000)
        /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0xb7feb000)



>
>> This also stops various segfaults too.
>
>
> Interesting.

worrying

Sam
