From: Internet Protocol version Six <inet6@mail.be>
Subject: Kernel compile error with ROUTE-ipv6 patch
Date: Fri, 24 Oct 2003 23:16:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <6068024.1067030166937.JavaMail.Administrator@pumbaa>
Reply-To: Internet Protocol version Six <inet6@mail.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all, I get an error with ROUTE-ipv6 enabled:

[...]
gcc -D__ASSEMBLY__ -D__KERNEL__ -I/usr/src/linux-2.4.23-pre8/include -DPARANOID -c shr_Xsig.S
gcc -D__ASSEMBLY__ -D__KERNEL__ -I/usr/src/linux-2.4.23-pre8/include -DPARANOID -c mul_Xsig.S
rm -f math.o
ld -m elf_i386  -r -o math.o fpu_entry.o errors.o fpu_arith.o fpu_aux.o fpu_etc.o fpu_tags.o fpu_trig.o load_store.o get_address.o poly_atan.o poly_l2.o poly_2xm1.o poly_sin.o poly_tan.o reg_add_sub.o reg_compare.o reg_constant.o reg_convert.o reg_ld_str.o reg_divide.o reg_mul.o reg_u_add.o reg_u_div.o reg_u_mul.o reg_u_sub.o div_small.o reg_norm.o reg_round.o wm_shrx.o wm_sqrt.o div_Xsig.o polynom_Xsig.o round_Xsig.o shr_Xsig.o mul_Xsig.o
make[2]: Leaving directory `/usr/src/linux-2.4.23-pre8/arch/i386/math-emu'
make[1]: Leaving directory `/usr/src/linux-2.4.23-pre8/arch/i386/math-emu'
ld -m elf_i386 -T /usr/src/linux-2.4.23-pre8/arch/i386/vmlinux.lds -e stext arch/i386/kernel/head.o arch/i386/kernel/init_task.o init/main.o init/version.o init/do_mounts.o \
        --start-group \
        arch/i386/kernel/kernel.o arch/i386/mm/mm.o kernel/kernel.o mm/mm.o fs/fs.o ipc/ipc.o \
         drivers/char/char.o drivers/block/block.o drivers/misc/misc.o drivers/net/net.o drivers/ide/idedriver.o drivers/cdrom/driver.o drivers/pci/driver.o drivers/pnp/pnp.o drivers/video/video.o drivers/media/media.o arch/i386/math-emu/math.o \
        net/network.o \
        /usr/src/linux-2.4.23-pre8/arch/i386/lib/lib.a /usr/src/linux-2.4.23-pre8/lib/lib.a /usr/src/linux-2.4.23-pre8/arch/i386/lib/lib.a \
        --end-group \
        -o vmlinux
net/network.o: In function `init':
net/network.o(.text.init+0x19c0): undefined reference to `ip6t_register_target'
make: *** [vmlinux] Error 1

If I disable this in menuconfig and then recompile, it compiles fine
so it must be ROUTE-ipv6 that's causing this. How can I get this to
compile? What lines or anything do I need to add or change? As I
might need this for ipv6 source-based routing and stuff like that.
The kernel, as you can see, is 2.4.23-pre8.

Thanks in advance.

Wkg, Robby
-----------------------------------------------------
Mail.be, WebMail and Virtual Office
http://www.mail.be
