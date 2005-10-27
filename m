From: "Oscar A. Valdez" <oscar.valdez@duraflex-politex.com>
Subject: IPSEC using Linux Kernel 2.6
Date: Thu, 27 Oct 2005 14:34:13 -0600
Message-ID: <1130445253.3908.45.camel@wzowski.plastipak.com.sv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: shorewall-users@lists.sourceforge.net, netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I've been struggling to get IPSEC working on end-points on the same
systems as Netfilter, and I'm amazed at how difficult it is to gather
relevant information and to make it work on Linux, considering the
growing deployment of IPSEC and the importance of Netfilter for
firewalling. That's why I'm cross-posting to the netfilter users' and
devels' lists.

I believe the most reliable guide is at
http://www.shorewall.net/IPSEC-2.6.html. Briefly, for my setup, the
requirements are:

Kernel 2.6.12 patched with: 

      * The five patches in
        http://shorewall.net/pub/shorewall/contrib/IPSEC/2.6.12 (the
        first four are the same as at
        http://www.saout.de/misc/linux-2.6.12-ipsec-nat/ )

      * The "policy match" extension from a recent Patch-o-matic-ng.

      * iptables 1.3.0 patched with the "policy match" extension from a
        recent Patch-o-matic-ng.

      * ipsec-tools 0.5

I first unpack a vanilla kernel and the iptables tarball into
directories /tmp/linux-2.6.12.orig/ and /tmp/iptables-1.3.0.orig/, and
make copies of both unpacked directories (/tmp/linux-2.6.12/
and /tmp/iptables-1.3.0/)

I then apply the "policy match" extensions to the copies, with the
following patch-o-matic command:

KERNEL_DIR=/tmp/linux-2.6.12/ \
IPTABLES_DIR=/tmp/iptables-1.3.0/ ./runme extra

Then, I generate the patch files by running 

diff -Nurp iptables-1.3.0.orig/ iptables-1.3.0/ \
> ipsec-nf-policy-match.diff

and

diff -Nurp kernel-2.6.12.orig/ linux-2.6.12/ > ipsec-k-policy-match.diff

When I try to compile the patched kernel, I get the following error:

+ make ARCH=i386 nonint_oldconfig
CONFIG_IP_NF_MATCH_POLICY
CONFIG_IP6_NF_MATCH_POLICY
make[1]: *** [nonint_oldconfig] Error 2
make: *** [nonint_oldconfig] Error 2

It seems this is caused by the linux-2.4.0-nonintconfig.patch. I'll
appreciate clues on how to get around this error, and I promise to keep
the lists posted on my progress.
-- 
Oscar A. Valdez
