From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: [PATCH] RSH Conntrack+NAT
Date: Tue, 24 Dec 2002 13:04:26 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212240304.gBO34RH11180@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
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

Hi All,

  After being chased down for a hand in setting up some dude's
rsh conntracking in 2.4.19, I thought I'd revisit the old code, clean
it up a bit, and write the NAT module that I should have done the
first time.

  For the 2.4.19 kernel, the following patches should be applied
from the patch-o-matic before applying the RSH patch;
  - conntrack+nat-helper-unregister.patch
  - helper.patch
  - nat-memoryleak-fix.patch
  - z-newnat16.patch   (this is the only one *required*)

I have ftp'd the patch-o-matic bundle to the ftp.netfilter.org site;
  ftp.netfilter.org/incoming/pom-rsh-021224-02.tgz
  Md5sum: 56b5ae9bdc842a856d6c6dc647c3fb62  pom-rsh-021224-02.tgz
  Size: 7421 pom-rsh-021224-01.tgz


  This patch-o-matic patch cleanly applies and provides rsh connection
tracking and connection NATing.   If anyone else uses the modules, let
me know how they go.  I've found them quite stable and reliable (the
old ip_conntrack_rsh has been running in production here for 6months).

Note that the incoming/rsh-pom.tgz and incoming/pom-rsh-021224-01.tgz
files can be removed.

Regards,



--
Ian Latter
Internet and Networking Security Officer
Macquarie University
