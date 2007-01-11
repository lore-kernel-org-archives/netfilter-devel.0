From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Match & target structure history in 2.4.28 and 2.6.x series
Date: Thu, 11 Jan 2007 18:34:23 +0000
Message-ID: <45A6832F.2070703@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
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

In the hope that it will help people write matches & targets that are compatible with not only the newest version of linux, I wrote a page showing the changes to the match & target structs used in kernel code in the 2.6 series since 2.4.28:

http://xkr47.outerspace.dyndns.org/netfilter/match_and_target_structure_history.html

There has been quite a lot of changes in fact, and often ipv6 changes have appeared later than ipv4 changes.

I also included the transition from ipt_* and ip6t_* structs to xt_* structs in 2.6.16.

I'll try to write some skeleton examples later on how to do the basic backwards compatibility.. if I have time.. meanwhile, you get some idea by looking at this example.. check the #if statements:

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_set.c?view=markup

- xkr47

-- 
 "if I'd make up my own definitions, unrational would be the the end
  result after someone unrationalized something i.e. actively worked
  to cut down on rationality, whereas irrational would be more a
  result of laziness or lack of skill"
                - me, 23.11.2006
