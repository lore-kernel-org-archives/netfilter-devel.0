From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: IPSET patches from pom-ng don't apply to 2.6.16-rc5
Date: Tue, 28 Feb 2006 13:17:13 +0100
Message-ID: <44043F49.7050304@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

applying the ipset patch from patch-o-matic-ng doesn't work anymore:

Welcome to Patch-o-matic ($Revision: 4088 $)!

Kernel:   2.6.16, /storage/linux-2.6.16-rc5
Iptables: 1.3.5, /storage/iptables-1.3.5
Each patch is a new feature: many have minimal impact, some do not.
Almost every one has bugs, so don't apply what you don't need!
-------------------------------------------------------
Already applied:

Testing set... not applied
The set patch:
   Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
   Status: Beta
[...]
-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] t
unable to find ladd slot in src /tmp/pom-26985/net/ipv4/netfilter/Makefile (./patchlets/set/linux-2.6/./net/ipv4/netfilter/Makefile.ladd)


Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
