From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2 0/3] Removing the use of VLAIS from USB Gadget and netfilter
Date: Tue, 30 Oct 2012 17:18:54 -0400
Message-ID: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Behan Webster <behanw@converseincode.com>
To: balbi@ti.com, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a V2 version of the patch set I previously sent out. Since the =
use of a
new valign.h file spans both the USB and netfilter subsystems, I should=
 have
sent out all 3 patches to both trees at once. Assuming all is well, hop=
efully
both subsystems can cooperate to get these patches in without causing
conflicts.

The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
precludes the use of compilers which don't implement VLAIS (for instanc=
e the
Clang compiler). The LLVMLinux Project is working towards the ability o=
f
providing the Linux kernel developer the choice of using the Clang comp=
iler
toolchain. This is a part of a series of patches which remove the use o=
f VLAIS
from crypto code, dm-crypt, jbd2, libcrc32c, netfilter, and usb gadget.=
 Other
patches to allow Clang to be used to compile the Linux kernel will foll=
ow.

Behan Webster (2):
  Helper macros used for replacing the use of VLAIS
  Remove VLAIS usage from gadget code

Jan-Simon M=C3=B6ller (1):
  Remove VLAIS usage from netfilter

 drivers/usb/gadget/f_fs.c   |  106 +++++++++++++++++++++++++----------=
--------
 include/linux/valign.h      |   87 +++++++++++++++++++++++++++++++++++
 net/netfilter/xt_repldata.h |   40 +++++++++-------
 3 files changed, 172 insertions(+), 61 deletions(-)
 create mode 100644 include/linux/valign.h

--=20
1.7.9.5
