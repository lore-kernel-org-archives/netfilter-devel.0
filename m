From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: patch-o-matic and CVS proposal
Date: Thu, 4 Mar 2004 11:31:14 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0403021402360.1136-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hi,

I have got the following proposal to complete the services offered by
pom-ng:

Let us introduce a new tree say updates (feel free to suggest better
name) in CVS besides iptables and pom-ng:

iptables/		iptables source tree
patch-o-matic-ng/	patch-o-matic-ng
updates/		bugfixes, kernel updates

Example updates/ content:

01_linux-2.4.24.patch
02_linux-2.4.25.patch
03_linux-2.4.25-foo-bugfix.patch

01_linux-2.6.3.patch
02_linux-2.6.3-bar-bugfix.patch

01_iptables-1.2.9.patch
02_iptables-1.3.0.patch
03_iptables-1.3.0-foe-bugfix.patch

runme in pom-ng should stop when there were no kernel source, iptables
source or updates directory specified or the dirs couldn't be figured out,
or kernel/iptables version fails to match the following conditions
(potential chicken'n'egg problem for new kernel patchlevel versions)

	kernel-version   == 01_linux-x.y
	kernel-version   >= 01_linux-x.y.z

	iptables-version == 01_iptables-x.y
	iptables-version >= 01_iptables-x.y.z

Help files in updates can easily be supported and users should be warned
by runme to apply all patches from updates. (The whole updates repository
was always implicitly selected by runme.)

Maintenance were easy, almost mechanical:

- When new bug discovered and fixed, the patch is added to updates
  and a new updates version released.

- When a new extension/feature is submitted and accepted, then it is
  added to pom-ng and a new pom-ng version is released.

- When a new kernel is released with new features from pom-ng applied,
  then the updates repository is updated with the new kernel patch and
  the outdated fix patches are removed. We should release a new iptables
  version as well and then the patchlets added both to the new kernel
  and iptables releases could completely be removed from pom-ng.

runme (i.e. Netfilter_POM.ng) should independently check wether either
the kernel or iptables part of an extension are missing from the specified
source trees and if that's so, then it should offer the patch as not
applied. (As I suggested earlier, pom-ng would contain both the kernel and
userspace part of the extensions.)

If someone were interested in just the updates/bugfixes, then downloading
bugfixes/ and 'patch' would be enough to apply them.

Comments are welcomed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
