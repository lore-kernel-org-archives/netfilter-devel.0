From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: Kernel build suspicious warnings 2.6.14-5, iptables 1.3.4,
	POM-20051227
Date: Thu, 29 Dec 2005 00:44:02 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26D41@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

These are only warnings but they make me suspicious.  Should I be
worried?  Could the warnings below be because something in the kernel
calls the modules in question but the modules haven't been built yet?
But why would anything in the inline kernel call an optional module
loaded from POM?  I've run into several errors getting this far.  I'll
try a "make mrproper" and then "make all" to build it all from scratch
now and see what happens. =20

Thanks

- Greg Scott


Output extract below. =20


[root@dsi-fw linux]# make all
  CHK     include/linux/version.h
  SPLIT   include/linux/autoconf.h -> include/config/*
date
  CHK     include/linux/compile.h
  CHK     usr/initramfs_list
  CC [M]  net/ipv4/netfilter/ipt_CONNMARK.o
.
.
.
  OBJCOPY arch/i386/boot/vmlinux.bin
  HOSTCC  arch/i386/boot/tools/build
  BUILD   arch/i386/boot/bzImage
Root device is (3, 3)
Boot sector 512 bytes.
Setup is 7272 bytes.
System is 1605 kB
Kernel: arch/i386/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST
*** Warning: "sysctl_ip_default_ttl" [net/ipv4/netfilter/ipt_TARPIT.ko]
undefined!
*** Warning: "ip_conntrack_expect_free"
[net/ipv4/netfilter/ip_nat_h323.ko] undefined!
*** Warning: "ip_conntrack_expect_free"
[net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
  CC      arch/i386/crypto/aes-i586.mod.o
  LD [M]  arch/i386/crypto/aes-i586.ko
  CC      arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.mod.o
.
.
.
  CC      sound/usb/usx2y/snd-usb-usx2y.mod.o
  LD [M]  sound/usb/usx2y/snd-usb-usx2y.ko
[root@dsi-fw linux]# date
Thu Dec 29 00:14:00 CST 2005
[root@dsi-fw linux]#
