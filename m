From: "Ronny Freigang" <freigang@novedia.de>
Subject: suggestion to add comments
Date: Wed, 29 Sep 2004 16:02:46 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <007801c4a62c$ff3016d0$2e2aa8c0@boar>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

i want to make a little suggestion for future versions of iptables.

I would like to add a comment to every rule and chain to document the rules
directly on the system. I think that would reduce the complexity, if you
look at many rules after a while to change something and asking yourself
what rule x or y is doing and why you have inserted it.

Something like that:

iptables -N project_abc --comment "customer access chain for project_abc"

iptables -I FORWARD -s 230.24.1.199 -d 192.168.30.5 --dport 80 -m
state --state NEW -j ACCEPT --comment "external webserver access for
customer xy"

I hope you have time to add my little suggestion in future versions of
iptables :)

best regards
Ronny Freigang
