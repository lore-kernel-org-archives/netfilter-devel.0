From: Paul Kosinski <prk@iment.com>
Subject: Throttling by 'limit' in one chain fails whenever a
 *different* chain is modified
Date: Tue, 28 Dec 2004 12:44:34 -0500
Message-ID: <041228124435.278000@ime1.iment.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

[Posting this to the general list got no response since Dec 15, so I'll try the developer list.]

Hi,

I have set up a moderately complicated firewall which has (among other things) two dynamic chains whose rules are changed several times per hour. The rule changing is done by first flushing the chain and then adding the new rules. Let's call these two chains DYNAMIC1 and DYNAMIC2, so the script reads thus (details of rules omitted):

  iptables -F DYNAMIC1
  iptables -F DYNAMIC2

  if [proper time of hour]; then
    iptables -A DYNAMIC1 [allow some packets]
    iptables -A DYNAMIC2 [allow other packets]
  fi

In another section of the firewall, I have the following chain whose purpose is to log very occasionally some continually arriving tunnel packets (just to see when the tunnel is active).

  iptables -A TUNLOG                                 \
           -m state --state ESTABLISHED              \
           -m limit --limit 1/hour --limit-burst 1   \
           -j LOG --log-prefix "iptables: Tun ...  "

  iptables -A TUNLOG                                 \
           -m state --state NEW                      \
           -m limit --limit 1/minute --limit-burst 1 \
           -j LOG --log-prefix "iptables: Tun-New  "
  
  iptables -A TUNLOG                                 \
           -m state --state RELATED                  \
           -m limit --limit 1/minute --limit-burst 1 \
           -j LOG --log-prefix "iptables: Tun-Rel  "
  
  iptables -A TUNLOG                                 \
           -m state --state INVALID                  \
           -m limit --limit 1/minute --limit-burst 1 \
           -j LOG --log-prefix "iptables: Tun-Bad  "
  
  iptables -A TUNLOG                                 \
           -j ACCEPT

The problem I experience is that whenever the dynamic-rule script fires, I get a log entry for an established-tunnel packet. Since the first script fires N times per hour, I get N times as many log entries for the tunnel as I want. This makes my examination of the firewall log more tedious and error prone than it should be.

This seems to me to be a bug in iptables/netfilter. I am using iptables 1.2.11 and kernel 2.4.28 with the ebtables patch 'ebtables-brnf-8_vs_2_4_28_diff'.

Paul Kosinski
