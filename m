From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Linux 2.6.12/iptables 1.3.1+CLUSTERIP issues
Date: Mon, 20 Jun 2005 22:04:15 -0400
Message-ID: <876ef97a0506201904a05582a@mail.gmail.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org, nf-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

Harald et al,

Tonight I installed 2.6.12 and iptables 1.3.1 on my Gentoo box, both
from pristine sources. Two problems:

1. I had to copy in the ipt_CLUSTERIP.h kernel header from 2.6.12 into
iptables-1.3.1/include/linux/netfilter_ipv4 for the
libipt_CLUSTERIP.so library to have to same targinfosize as the kernel
module. Before that, I was getting the following error:

CLUSTERIP: targinfosize 64 !=3D 72

2. I installed this rule just to test things out:

iptables -A INPUT -d 192.168.1.3 -i eth0 -p tcp --dport 3000 -j
CLUSTERIP --new --hashmode sourceip-sourceport --clustermac
01:23:45:67:89:AB --total-nodes 2 --local-node 1

I then tried to remove it (I didn't update iptables rules again since
then) by switching the -A to a -D and that failed. I tried all sorts
of combinations of the arguments to -j CLUSTERIP but they all failed.
Eventually, I was forced to remove the rule by using the iptables rule
# (e.g. iptables -D INPUT 10). I feel that this is in error, but I've
seen at least two patches to CLUSTERIP that claim to fix rule
deletion. Am I doing something wrong?

Anyway, I'm glad that you can now update the node lists dynamically
now. This makes it usable. I'm planning on writing a userspace driver
for this module to make at least the Win2K3 NLB functionality
available to Linux users.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
