From: Max Kellermann <max@duempel.org>
Subject: nfsim problem with NAT
Date: Wed, 19 Jan 2005 00:17:29 +0100
Message-ID: <20050118231729.GA11445@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,

I'm trying to write a nfsim test for the H.323 conntrack module. The
NAT part fails, because I cannot set up the NAT rule:

 > 14:iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 1720 -j SNAT --to-source 192.168.0.100
 iptables: Invalid argument
 iptables: command failed
 Script failed at line 14: 
 iptables failed

I get the same message with the NAT tests from nfsim-testsuite
(e.g. 03NAT/62ftpdata-port.sim). My iptables version is v1.2.11, Linux
kernel 2.6.11-rc1 (nfsim fails to compile 2.6.11-rc1-mm1, anyone
interested in a detailed report or patch?).

Max
