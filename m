From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070707 kernel
Date: Fri, 13 Jul 2007 17:01:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707131658590.25352@fbirervta.pbzchgretzou.qr>
References: <46925543.6060205@trash.net> <46925580.9030608@trash.net>
	<Pine.LNX.4.64.0707091737550.2887@fbirervta.pbzchgretzou.qr>
	<200707131418.l6DEIudN010879@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707131418.l6DEIudN010879@toshiba.co.jp>
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


On Jul 13 2007 23:18, Yasuyuki KOZAKAI wrote:
>
>> +static __attribute__((constructor)) void libipt_connlimit_init(void)
>> +{
>> +	register_match(&connlimit_reg);
>> +}
>
>JFYI: I've fixed compile error in the case of NO_SHARED_LIBS=1. The
>function name for initialization needs to be _init, not
>libipt_connlimit_init.

Uhm, that's why there is __attribute__((constructor)). Because *having* an
_init in a shared library has often failed on me. Example:


$ cat test.c
#include <stdio.h>
void _init(void)
{
        printf("Hello world\n");
}

$ cc test.c -shared -o test.so -Wall
/tmp/ccBDCmOL.o: In function `_init':
test.c:(.text+0x0): multiple definition of `_init'
/usr/lib/gcc/i586-suse-linux/4.1.2/../../../crti.o:/usr/src/packages/BUILD/glibc-2.5/cc-nptl/csu/crti.S:36:
first defined here
collect2: ld returned 1 exit status


And I certainly do not want to build without the GNU runtime,
because that makes things a bit more unportable (trying to
get the right linker switch, for ex.)




	Jan
-- 
