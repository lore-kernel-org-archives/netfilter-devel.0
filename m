From: Wojciech 'Sas' =?iso-8859-2?Q?Ci=EAciwa?= <cieciwa@dzp.ntt.com.pl>
Subject: pptp-conntrack-nat - problem
Date: Tue, 05 Apr 2005 11:03:32 +0200
Message-ID: <1112691812.22295.4.camel@sas>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
I try apply pptp-conntrack downloaded directly from SVN
and I got error:
===============================
Welcome to Patch-o-matic ($Revision: 3733 $)!

Kernel:   2.6.11, /home/users/cieciwa/rpm/BUILD/linux-2.6.11.6
Iptables: 1.3.1, /home/users/cieciwa/rpm/BUILD/iptables
Each patch is a new feature: many have minimal impact, some do not.
Almost every one has bugs, so don't apply what you don't need!
-------------------------------------------------------
Already applied:
[...]
-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] unable to find
ladd slot in
src /home/users/cieciwa/rpm/BUILD/linux-2.6.11.6/include/linux/netfilter_ipv4/ip_conntrack.h (./pptp-conntrack-nat/linux-2.6/./include/linux/netfilter_ipv4/ip_conntrack.h.ladd_6)

Can anyone look at this?

Thanx.
				Sas.
-- 
{Wojciech 'Sas' Cieciwa - Member of PLD Team                     }
{e-mail: cieciwa@dzp.ntt.com.pl, http://www.republika.pl/cieciwa }
