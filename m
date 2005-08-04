From: Amin Azez <azez@ufomechanic.net>
Subject: Re: iptables 1.3.1 crashes on iptables-restore
Date: Thu, 04 Aug 2005 17:24:49 +0100
Message-ID: <42F24151.1090702@ufomechanic.net>
References: <20050330034616.GA8639@samad.com.au>
	<424BB242.6070809@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
In-Reply-To: <424BB242.6070809@drugphish.ch>
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
>> when I try to do a iptables-restore with about 800 lines I get a
>> segmentation fault.
>> What is the most expediant way to track this problem down ?
> 
> 
> o Compile and link iptables with debugging info.
> o Before you run the command make sure you have the core file size
>   settings to unlimited (ulimit -c unlimited).
> o Run your command.
> o You should have a core file in your directory.
> o gdb -q core /path/to/iptables-restore
> o bt
> 
> Send the output to this list. Hope that is expedient enough ;).

I haven't seen any follow-up here but I am also having problems with
hanging and segfaulting with iptables-restore 1.3.1

If I re-order the rules, the problem changes or goes away.

With one combination of rules, I get a sefault with a backtrace as shown
here.

(I am using layer7 in some of my rules)

#0  0x4207418b in _int_malloc () from /lib/tls/libc.so.6
#1  0x42073a5e in calloc () from /lib/tls/libc.so.6
#2  0x0804aa19 in fw_calloc (count=1, size=8484) at iptables.c:514
#3  0x0804d4ce in do_command (argc=13, argv=0x8057660, table=0x8057668,
handle=0xbfffcdec) at iptables.c:2096
#4  0x0804a0fb in main (argc=-1073753484, argv=0xbffffa94) at
iptables-restore.c:401
#5  0x42015574 in __libc_start_main () from /lib/tls/libc.so.6

In this case the segfault occured while processing this rule (mangle table):
-A staticentries -m layer7 --l7proto html -j MARK --set-mark 0x1

but does not occur if I remove this rule which is processed much earlier on:
-A layer7entries -m layer7 --l7proto msnmessenger -j RETURN

To me this indicates memory corruption at some point early on, I would
blame layer7 apart from the report here that I am responding to.


In another case where iptables-restore hangs, strace shows:
...
open("/etc/l7-protocols/protocols/rdp.pat", O_RDONLY) = 5
fstat64(5, {st_mode=S_IFREG|0644, st_size=661, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7ede000
read(5, "# RDP - Remote Desktop Protocol "..., 4096) = 661
futex(0x83e2b98, FUTEX_WAKE, 1, ptrace: umoven: Input/output error
{...})  = 0
futex(0x83e2b98, FUTEX_WAIT, -7, NULL

The interesting point being the blocked futex which to me indicates
(guessing) that the kernel was sent some dodgy iptables soup and is
choking on it.


I'm debugging further to see where this is happening but thought it post
here with what I have.

iptables 1.3.3 doesn't segfault but does hang.

Sam
