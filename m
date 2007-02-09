From: Max Kellermann <max@duempel.org>
Subject: Bug: "You must specify `--icmpv6-type'"
Date: Fri, 9 Feb 2007 11:28:29 +0100
Message-ID: <20070209102829.GA31011@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

users of my "ferm" iptables frontend
(http://max.kellermann.name/projects/ferm/) reported a problem with
ip6tables.

 rabbit:~# ip6tables -A INPUT -p icmpv6 -j ACCEPT
 rabbit:~# ip6tables -A INPUT -p icmpv6 -m icmpv6 -j ACCEPT
 ip6tables v1.3.6: icmpv6 match: You must specify `--icmpv6-type'
 Try `ip6tables -h' or 'ip6tables --help' for more information.

According to the ip6tables manpage, the "icmpv6" module is implicitly
loaded whenever you specify "-p icmpv6".  It is however only loaded
when you also specify "--icmpv6-type".  So either the documentation is
wrong, or ip6tables' behaviour is.

Max
