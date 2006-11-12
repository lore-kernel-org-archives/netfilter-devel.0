From: "Laurence J. Lane" <ljlane@debian.org>
Subject: iptables 1.3.6 not using /etc/networks
Date: Sat, 11 Nov 2006 20:25:25 -0500
Message-ID: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

http://bugs.debian.org/398082

iptables 1.3.5 and 1.3.6 appear to read /etc/networks, but the
information is lost somewhere with 1.3.6.

  # cat /etc/networks
  foonet 10.0.0.0

  # strace -s 255 -o /tmp/foo iptables -v -A INPUT -s foonet/8 -j
ACCEPT #1.3.5 [1]
  ACCEPT  all opt -- in * out *  10.0.0.0/8  -> 0.0.0.0/0

  # strace -s 255 -o /tmp/bar iptables -v -A INPUT -s foonet/8 -j
ACCEPT #1.3.6 [2]
  iptables v1.3.6: host/network `foonet.0.0.0' not found
  Try `iptables -h' or 'iptables --help' for more information.

1. http://people.debian.org/~ljlane/stuff/strace-iptables-1.3.5.txt
2. http://people.debian.org/~ljlane/stuff/strace-iptables-1.3.6.txt
