From: primero <primero@fastwebnet.it>
Subject: Re: libiptc ... and matches , seg fault
Date: Fri, 15 Jul 2005 10:06:28 +0200
Message-ID: <42D76E84.7080906@fastwebnet.it>
References: <42D6AD2C.5070304@fastwebnet.it>
	<Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?windows-1252?Q?Tom=E1=B9_Macek?= <maca02@atlas.cz>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>
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

Tom=E1=9A Macek wrote:

> Where points the me->version just before the step into the strcmp()?
> What this pointer contains?
>

each libipt_MATCH has to call a register_match() in his init function=20
passing an "iptables_match" structure has argument that is referred as=20
"me" inside the register_match function.

in my particular case me->version is equal to IPTABLES_VERSION (check=20
out the libipt_tcp.c).

what could give such seg fault in a strcmp ?

bye
Francesco

> On Thu, 14 Jul 2005, Francesco Ciocchetti wrote:
>
>> Hi all ML.
>>
>> I'm tryng to develop a small apps with libiptc copyng as much as
>> possible from iptables.c
>>
>> i'm getting a segmentation fault when i call find_match with 'tcp' as
>> argument.
>>
>> searching with gdb i found that :
>>
>> my segfault arrives when in register_match
>>
>> if (strcmp(me->version, program_version) !=3D 0) (line 1052 of iptable=
s.c
>> 1.2.11)
>>
>> Program received signal SIGSEGV, Segmentation fault.
>> 0x0ff0b824 in strcmp () from /lib/tls/libc.so.6
>> (gdb) where
>> #0 0x0ff0b824 in strcmp () from /lib/tls/libc.so.6
>> #1 0x100083e8 in register_match ()
>> #2 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #3 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #4 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #5 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #6 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #7 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #8 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #9 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #10 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #11 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #12 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #13 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #14 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #15 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #16 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #17 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #18 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #19 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> #20 0x0fe53584 in _init () from /lib/iptables/libipt_tcp.so
>> Previous frame inner to this frame (corrupt stack?)
>>
>> If i missed some info don't esiatate to ask :)
>>
>> anyone has some hints?
>>
>> thx
>> Francesco
>>
>>
>>
>>
>>
>>
>>
>
