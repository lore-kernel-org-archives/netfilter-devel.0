From: "Hung Lin" <hlin@nextone.com>
Subject: Kernel oops when putting the console option in /boot/grub/menu.lst
Date: Thu, 10 May 2007 11:41:04 -0400
Message-ID: <D0B3C45E7FCE4C488BEF410B2EF666A17F8D04@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

Hi,

I'm using ipset-2.2.9 with kernel 2.6.11.4-21.13 (SuSE 9.3 kernel) and
iptables-1.3.1-3 (SuSE 9.3 iptables) and everything is fine.  But after
I added a console option to /boot/grub/menu.lst, the kenrel will hang
sometimes and show kernel oops message on the monitor.  After research,
I found it is `iptables -m hashlimit` command to cause this problem.
Therefore, I did some tests:

I used a loop to insert and delete hashlimit rules to iptables, here's
the result:

1. with ipset patch and without console option in grub menu, no problem

2. withotu ipset patch and with console option in grub menu, no problem

3. with ipset patch and with console option in grub menu, kernel crashs
after hundreds of iterations.


It looks like console option in the grub menu has something conflict
with ipset kernel patch.  But I don't understand.

Please give me your advices.  Thanks in advance.


P.S.=20

Here's the grub menu:

ORIGINAL ONE (without console option):

color white/blue black/light-gray
default 0
timeout 8

title NexTone Linux
    kernel (hd0,1)/boot/vmlinuz root=3D/dev/sda2 vga=3Dnormal =
splash=3Dsilent
desktop showopts vmalloc=3D256M
    initrd (hd0,1)/boot/initrd

title Rescue Floppy
    root (fd0)
    chainloader +1

title Failsafe
    kernel (hd0,1)/boot/vmlinuz root=3D/dev/sda2 vga=3Dnormal =
splash=3Dsilent
desktop showopts single
    initrd (hd0,1)/boot/initrd


NEW ONE (with console option):

color white/blue black/light-gray
default 0
timeout 8

title NexTone Linux
    kernel (hd0,1)/boot/vmlinuz root=3D/dev/sda2 vga=3Dnormal =
splash=3Dsilent
desktop showopts console=3Dtty0 console=3DttyS0,9600n8 vmalloc=3D256M
    initrd (hd0,1)/boot/initrd

title Rescue Floppy
    root (fd0)
    chainloader +1

title Failsafe
    kernel (hd0,1)/boot/vmlinuz root=3D/dev/sda2 vga=3Dnormal =
splash=3Dsilent
desktop showopts console=3DttyS0,9600n8 console=3Dtty0 single
    initrd (hd0,1)/boot/initrd






Hung Lin
Software Engineer
NexTone Communications, Inc.

-- Network Without Limits --
