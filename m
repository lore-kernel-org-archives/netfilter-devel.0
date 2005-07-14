From: =?ISO-8859-2?Q?Tom=E1=B9_Macek?= <maca02@atlas.cz>
Subject: Re: libiptc ... and matches , seg fault
Date: Thu, 14 Jul 2005 21:18:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>
References: <42D6AD2C.5070304@fastwebnet.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42D6AD2C.5070304@fastwebnet.it>
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

Where points the me->version just before the step into the strcmp()?
What this pointer contains?

On Thu, 14 Jul 2005, Francesco Ciocchetti wrote:

> Hi all ML.
>
> I'm tryng to develop a small apps with libiptc copyng as much as
> possible from iptables.c
>
> i'm getting a segmentation fault when i call find_match with 'tcp' as
> argument.
>
> searching with gdb i found that :
>
> my segfault arrives when in register_match
>
> if (strcmp(me->version, program_version) != 0) (line 1052 of iptables.c
> 1.2.11)
>
> Program received signal SIGSEGV, Segmentation fault.
> 0x0ff0b824 in strcmp () from /lib/tls/libc.so.6
> (gdb) where
> #0  0x0ff0b824 in strcmp () from /lib/tls/libc.so.6
> #1  0x100083e8 in register_match ()
> #2  0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #3  0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #4  0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #5  0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #6  0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #7  0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #8  0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #9  0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #10 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #11 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #12 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #13 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #14 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #15 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #16 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #17 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #18 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #19 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> #20 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
> Previous frame inner to this frame (corrupt stack?)
>
> If i missed some info don't esiatate to ask :)
>
> anyone has some hints?
>
> thx
> Francesco
>
>
>
>
>
>
>
