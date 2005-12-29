From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Kernel build suspicious warnings 2.6.14-5, iptables 1.3.4,
	POM-20051227
Date: Thu, 29 Dec 2005 10:04:04 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26D46@mail733.InfraSupportEtc.com>
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

Yup, the h323 modules are broken.  The h323 modules reference a function
named ip_conntrack_expect_free.  But searching through the entire kernel
and POM source trees, I find no reference to any files named similarly.
And searching through the netfilter-devel archives from Dec. 2005
through June 2005, I find no mention of this string.  Have I hit a brick
wall or can I remove the references to this function in the effected
h323 modules?  If yes, I will even try my hand at making a patch.

Thanks

- Greg Scott


An extract of the relevant output follows:

[root@dsi-fw linux]# make all
.
.
.
  CC [M]  net/ipv4/netfilter/ip_conntrack_h323_core.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_h323_h225.o
net/ipv4/netfilter/ip_conntrack_h323_h225.c: In function
'h225_parse_connect_uuie':
net/ipv4/netfilter/ip_conntrack_h323_h225.c:135: warning: implicit
declaration of function 'ip_conntrack_expect_free'
  CC [M]  net/ipv4/netfilter/ip_conntrack_h323_h245.o
net/ipv4/netfilter/ip_conntrack_h323_h245.c: In function
'h245_parse_h2250_lchannel_params':
net/ipv4/netfilter/ip_conntrack_h323_h245.c:322: warning: implicit
declaration of function 'ip_conntrack_expect_free'
  CC [M]  net/ipv4/netfilter/asn1_per.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_helper_pptp.o
.
.
.
  LD [M]  net/ipv4/netfilter/ip_conntrack_h323.o
  CC [M]  net/ipv4/netfilter/ip_nat_h323.o
net/ipv4/netfilter/ip_nat_h323.c: In function 'ip_nat_h225':
net/ipv4/netfilter/ip_nat_h323.c:111: warning: implicit declaration of
function 'ip_conntrack_expect_free'
  CC [M]  net/ipv4/netfilter/ip_conntrack_sip.o
  CC [M]  net/ipv4/netfilter/ip_nat_sip.o
net/ipv4/netfilter/ip_nat_sip.c: In function 'ip_nat_sip':
net/ipv4/netfilter/ip_nat_sip.c:97: warning: ISO C90 forbids mixed
declarations and code
  LD [M]  net/ipv4/netfilter/ip_nat.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_netlink.o
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
Kernel: arch/i386/boot/bzImage is ready  (#2)
  Building modules, stage 2.
  MODPOST
*** Warning: "ip_conntrack_expect_free"
[net/ipv4/netfilter/ip_nat_h323.ko] undefined!
*** Warning: "ip_conntrack_expect_free"
[net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
  CC      arch/i386/crypto/aes-i586.mod.o
  LD [M]  arch/i386/crypto/aes-i586.ko
.
.
.
[root@dsi-fw linux]# make modules_install
.
.
.
  INSTALL sound/usb/snd-usb-lib.ko
  INSTALL sound/usb/usx2y/snd-usb-usx2y.ko
if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F
System.map  2.6.14.5fw20; fi
/bin/sh: line 1:  4266 Killed                  /sbin/depmod -ae -F
System.map 2.6.14.5fw20
make: *** [_modinst_post] Error 137
[root@dsi-fw linux]# date
Thu Dec 29 09:38:37 CST 2005
[root@dsi-fw linux]#
