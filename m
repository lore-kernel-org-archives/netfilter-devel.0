From: "Laurence J. Lane" <ljlane@nontoxic.org>
Subject: #263154: iptables: segfault with multiple ip hostnames
Date: Tue, 3 Aug 2004 18:03:50 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040803220350.GA5223@ljlane.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

http://bugs.debian.org/263154

iptables 1.2.11 segfaults when given a domain name that resolves 
to multiple ip addresses. The situation is the same for kernel 
versions 2.4.26 and 2.6.7.

As an example:

  # iptables -I INPUT -s google.com -j DROP
  free(): invalid pointer 0x8055a4c!
  Segmentation fault
