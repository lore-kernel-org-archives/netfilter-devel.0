From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: pom-ng updates renamings
Date: Fri, 25 Jun 2004 14:08:09 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406251343310.11001-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <coreteam@netfilter.org>, <netfilter-devel@lists.netfilter.org>
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

I'm going to rename files in the special updates directory in pom-ng (and
change Netfilter_POM.ng). The reason for this is that following the name
convention used in the patchlet parts of pom-ng is quite misleading and
non-intuitive in updates.

In pom-ng (if other constraints are not defined) linux-2.6.6 patch
can be applied for kernel versions equal or above 2.6.6.

Currently the same convention is used in updates, in contrary to the
natural naming: linux-2.6.6 patch is against kernel release 2.6.5, i.e it
brings the kernel up to 2.6.6. However because in updates linux-2.6.5
patch brings the kernel to 2.6.6, a bugfix patch against 2.6.6 should be
named as linux-2.6.5-foo-bugfix patch, which is simply horrid.

I'll update pom-ng on the weekend.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
