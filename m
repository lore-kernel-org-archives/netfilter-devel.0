From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: I don't understand what goes where, very confused about POM-ng
Date: Wed, 5 May 2004 23:19:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405052142180.31384-100000@blackhole.kfki.hu>
References: <4099406D.4080606@rtij.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <netfilter-devel@rtij.nl>
In-Reply-To: <4099406D.4080606@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 5 May 2004, Martijn Lievaart wrote:

> Well, there are also linux-2.4 trees. So at first sight it would seem
> that linux-<version>/ is specific to that version and plain linux/ is
> for any version. But it seemes the linux/ is a synonym for linux-2.4 right?

No, that's a catch-all for all versions not matched by any linux-x.x
directories (same for linux.patch). But practically, yes. :-)
README.newpatches is a little bit terse, probably...

The logic behind the version matching is as follows:

First, we have got branches (see the config) file. A branch is a
collection of versions where theoretically a single patch is always
applicable for all versions in the branch. For linux kernel trees,
currently we have got two branches: linux-2.4.x and linux-2.6.x
(linux-2.5.x not supported). If we want to patch a kernel by pom, then the
kernel version must be in one of the branches otherwise the kernel is not
supported by pom, and additionally the oldest kernel patch in the updates
directory for the given branch gives us the oldest supported kernel in
that branch.

There might be that even in a branch, there are kernel releases which
requires different patch versions of a patch. So when matching a patch
with the kernel we want to patch, the biggest smaller or equal patch
version than the kernel version wins.

Let's see an example: kernel versions we want to patch are from 2.4.27 to
2.4.31, but patch versions we have got are linux.patch, linux-2.4.28.patch
and linux-2.4.30.patch.  Then the result of the matching is

	kernel version		matched patch version
	linux-2.4.27		linux.patch
	linux-2.4.28		linux-2.4.28.patch
	linux-2.4.29		linux-2.4.28.patch
	linux-2.4.30		linux-2.4.30.patch
	linux-2.4.31		linux-2.4.30.patch

Patches from different branches are of course exluded as candidates from
the matching.

When searching for the best match, the patch candidate must also fulfil
the version requirements specified for it in the info file. Just to cite
the example from README.newpatches: if we have got linux.patch and
linux-2.4.25.patch where the latter is valid for kernel 2.4.25 only, but
linux.patch can be applied for kernels before and after 2.4.25 too, then
one must specify the following in the info file:

Requires: linux-2.4.25.patch == 2.4.25

Otherwise linux-2.4.25.patch would match kernels >= 2.4.25 as well.

The same version matching logic is applied for the directory tree with
the ladds/whole-files.

pom supports multiple projects, like linux kernel tree and iptables source
tree patches stored in the same pom. Of course the version matching logic
is valid for all projects.

The updates directory handled in a special way: patches are implicitly
dependent from all the previous patches in the same branch. All patches
for a branch are applicable for any project version matching the branch
and have got equal or greater version than the oldest patch for the branch
in the updates directory.

> Clear. Someone, please copy
> XOR/linux/include/linux/netfilter_ipv4/ipt_XOR.h to
> XOR/linux-2.6/include/linux/netfilter_ipv4/ipt_XOR.h in CVS.

OK, I'll do that.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
