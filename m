From: "Sumit Pandya" <sumit@elitecore.com>
Subject: Logging conntrack with ip_conntrack_destroyed
Date: Wed, 4 Jun 2003 13:27:11 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000901c32a6e$e7683040$010f430a@elitecore7>
References: <20020813042705.13302.51547.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0006_01C32A9D.010B0F80"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0006_01C32A9D.010B0F80
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi All,
    I written a kernel module which registers hook for
ip_conntrack_destroyed. Purpose of this module is to log finish connection
as opposed to logging every packet of a connection provided by presently
netfilter targets (U)LOG. The module causes kernel __OOPS__ while it issues
fileP->f_op->write. I'm using kernel 2.4.20 from kernel.org.
--------------------------------------------------------------------------
Please find output of ksymoops in attachment.
--------------------------------------------------------------------------
[root@manage root]# uname -a
Linux manage 2.4.20 #3 Wed Jun 4 11:52:06 EDT 2003 i686 i686 i386 GNU/Linux
[root@manage root]# gcc -v
Reading specs from /usr/lib/gcc-lib/i386-redhat-linux/3.2/specs
Configured with:
../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info
 --enable-shared --enable-threads=posix --disable-checking --host=i386-redha
t-linux --with-system-zlib --enable-__cxa_atexit
Thread model: posix
gcc version 3.2 20020903 (Red Hat Linux 8.0 3.2-7)
[root@manage root]# lsmod
Module                  Size  Used by    Not tainted
ipt_CONNLOG 2840 0
ip_conntrack  25632 0 [ipt_CONNLOG]
iptable_mangle          2776   0  (autoclean) (unused)
bridge                 24748   1  (autoclean)
iptable_filter          2412   0  (autoclean) (unused)
ip_tables              14360   2  [iptable_mangle iptable_filter]
--------------------------------------------------------------------------
    Do I need to enable ASYNC_IO flag for file operation? Do I need to lock
some semaphore variable?
    Thankx for any indication.
-- Sumit


------=_NextPart_000_0006_01C32A9D.010B0F80
Content-Type: application/octet-stream;
	name="oops.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="oops.log"

ksymoops 2.4.5 on i686 2.4.20.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.20/ (default)
     -m /usr/src/linux/System.map (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

kernel BUG at sched.c:564!
invalid operand: 0000
CPU:    0
EIP:    0010:[<c0111371>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010282
eax: 00000018   ebx: c76b3500   ecx: c7da8000   edx: c7da9f7c
esi: c0236000   edi: c76b3548   ebp: c0237d88   esp: c0237d60
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=3Dc0237000)
Stack: c020652a c02988c4 c0237d78 c0237d88 c0236000 00000000 c029891c =
c76b3500
       c0236000 c76b3548 c0237db0 c013512d c022ffa0 00000000 c0236000 =
c76b3548
       c76b3548 00001000 00001000 c0237dfc c0237e0c c0136ad8 c76b3500 =
00000001
Call Trace:    [<c013512d>] [<c0136ad8>] [<c0137383>] [<c015b3f0>] =
[<c0128928>]
  [<c015b3f0>] [<c8845ac0>] [<c88450f9>] [<c8845ac0>] [<c88452f9>] =
[<c8845ac0>]
  [<c88455c0>] [<c8845ab4>] [<c8836c85>] [<c01b0a59>] [<c01b1d08>] =
[<c018c3eb>]
  [<c01b6073>] [<c0118a46>] [<c0108b1d>] [<c0105380>] [<c010b1c8>] =
[<c0105380>]
  [<c01053a6>] [<c0105442>] [<c0105000>]
Code: 0f 0b 34 02 22 65 20 c0 e9 00 fd ff ff 0f 0b 2d 02 22 65 20


>>EIP; c0111371 <schedule+341/360>   <=3D=3D=3D=3D=3D

>>ebx; c76b3500 <_end+7416088/8587be8>
>>ecx; c7da8000 <_end+7b0ab88/8587be8>
>>edx; c7da9f7c <_end+7b0cb04/8587be8>
>>esi; c0236000 <init_task_union+0/2000>
>>edi; c76b3548 <_end+74160d0/8587be8>
>>ebp; c0237d88 <init_task_union+1d88/2000>
>>esp; c0237d60 <init_task_union+1d60/2000>

Trace; c013512d <__wait_on_buffer+5d/90>
Trace; c0136ad8 <__block_prepare_write+128/2f0>
Trace; c0137383 <block_prepare_write+33/50>
Trace; c015b3f0 <ext2_get_block+0/280>
Trace; c0128928 <generic_file_write+408/700>
Trace; c015b3f0 <ext2_get_block+0/280>
Trace; c8845ac0 <[ipt_CONNLOG]conninfo.1+0/0>
Trace; c88450f9 <[ipt_CONNLOG]write_log+59/d0>
Trace; c8845ac0 <[ipt_CONNLOG]conninfo.1+0/0>
Trace; c88452f9 <[ipt_CONNLOG]ip_conntrack_log+c9/e0>
Trace; c8845ac0 <[ipt_CONNLOG]conninfo.1+0/0>
Trace; c88455c0 <[ipt_CONNLOG].text.end+24b/73b>
Trace; c8845ab4 <[ipt_CONNLOG]appname.0+0/9>
Trace; c8836c85 <[iptable_mangle].data.end+1ae/3589>
Trace; c01b0a59 <sock_wfree+49/50>
Trace; c01b1d08 <__kfree_skb+108/160>
Trace; c018c3eb <speedo_interrupt+13b/200>
Trace; c01b6073 <net_tx_action+43/c0>
Trace; c0118a46 <do_softirq+a6/b0>
Trace; c0108b1d <do_IRQ+bd/f0>
Trace; c0105380 <default_idle+0/40>
Trace; c010b1c8 <call_do_IRQ+5/d>
Trace; c0105380 <default_idle+0/40>
Trace; c01053a6 <default_idle+26/40>
Trace; c0105442 <cpu_idle+52/70>
Trace; c0105000 <_stext+0/0>

Code;  c0111371 <schedule+341/360>
00000000 <_EIP>:
Code;  c0111371 <schedule+341/360>   <=3D=3D=3D=3D=3D
   0:   0f 0b                     ud2a      <=3D=3D=3D=3D=3D
Code;  c0111373 <schedule+343/360>
   2:   34 02                     xor    $0x2,%al
Code;  c0111375 <schedule+345/360>
   4:   22 65 20                  and    0x20(%ebp),%ah
Code;  c0111378 <schedule+348/360>
   7:   c0 e9 00                  shr    $0x0,%cl
Code;  c011137b <schedule+34b/360>
   a:   fd                        std   =20
Code;  c011137c <schedule+34c/360>
   b:   ff                        (bad) =20
Code;  c011137d <schedule+34d/360>
   c:   ff 0f                     decl   (%edi)
Code;  c011137f <schedule+34f/360>
   e:   0b 2d 02 22 65 20         or     0x20652202,%ebp

 <0>Kernel panic: Aiee, killing interrupt handler!

1 warning issued.  Results may not be reliable.

------=_NextPart_000_0006_01C32A9D.010B0F80--
