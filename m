From: John McLean <jmclean@parasun.com>
Subject: Which hooks can you call ip_route_me_harder in?
Date: Mon, 13 Jun 2005 15:06:09 -0700
Message-ID: <1118700369.29605.28.camel@ws1.parasun.net>
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

Is it okay to call ip_route_me_harder() when my filter function is
attached to NF_IP_LOCAL_IN ?

In ip_nat_standalone.c and iptable_mangle.c nf_hook_ops.hooknum =
NF_IP_LOCAL_OUT. 

Am I reading to much in to this, or am I missing the boat on how
ip_route_me_harder() works?

Thanks in advance for any light on this subject.

J.
