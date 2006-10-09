From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: Compiling 1.3.6
Date: Mon, 09 Oct 2006 17:58:34 +0200
Message-ID: <BAY103-F13D1C1A680193B4FD7C978B2160@phx.gbl>
References: <452A6E75.2030700@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <452A6E75.2030700@netfilter.org>
To: pablo@netfilter.org, kaber@trash.net
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso wrote:

>Pablo Neira Ayuso wrote:
>>Patrick McHardy wrote:
>>
>>>Pablo Neira Ayuso wrote:
>>>
>>>>min_ip and max_ip type has been changed from u_int32_t to __be32 that is
>>>>not defined in userspace, this breaks iptables compilation.

I'm able to compile iptables 1.3.6 with 2.6.18 kernel
headers without any errors.
However iptables 1.3.6 + linux 2.6.19-rc1 kernel
headers give me this error:

cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/ 
-DIPTABLES_VERSION=\"1.3.6\"  -fPIC -o extensions/libipt_iprange_sh.o -c 
exte
nsions/libipt_iprange.c
In file included from extensions/libipt_iprange.c:9:
/usr/src/linux/include/linux/netfilter_ipv4/ipt_iprange.h:11: error: syntax 
error before "__be32"
/usr/src/linux/include/linux/netfilter_ipv4/ipt_iprange.h:11: warning: no 
semicolon at end of struct or union
/usr/src/linux/include/linux/netfilter_ipv4/ipt_iprange.h:16: error: field 
`src' has incomplete type
/usr/src/linux/include/linux/netfilter_ipv4/ipt_iprange.h:17: error: field 
`dst' has incomplete type
extensions/libipt_iprange.c: In function `parse_iprange':
extensions/libipt_iprange.c:43: error: dereferencing pointer to incomplete 
type
extensions/libipt_iprange.c:50: error: dereferencing pointer to incomplete 
type
extensions/libipt_iprange.c:52: error: dereferencing pointer to incomplete 
type
extensions/libipt_iprange.c:52: error: dereferencing pointer to incomplete 
type
extensions/libipt_iprange.c: In function `print_iprange':
extensions/libipt_iprange.c:116: error: dereferencing pointer to incomplete 
type
extensions/libipt_iprange.c:117: error: dereferencing pointer to incomplete 
type
make: *** [extensions/libipt_iprange_sh.o] Error 1

My env: Slackware Linux 11.0

Linux Calimero 2.6.19-rc1 #1 PREEMPT Thu Oct 5 15:26:06 CEST 2006 i686 
pentium3 i386 GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.15.92.0.2
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Linux C++ Library      6.0.3
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.97
