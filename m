From: kaups <kaups@linux.ee>
Subject: netfilter time patch (feature request)/ optimization against big rulesets.
Date: Wed, 10 Mar 2004 12:41:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403101241.48559.kaups@linux.ee>
Reply-To: kaups@linux.ee
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
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

Hi.

You have a cool netfilter patch in pom, which allows to match packets against 
time based rules.

Right now I'm having a problem with it in big iptables rulesets, for example:

---------------------
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

[ ... about 10000 different rules ... ]

iptables -A INPUT -m time --timestart 8:00 --timestop 18:00 --days Mon -j 
ACCEPT
---------------------

If i use this ruleset allready established connections will continue after 
18:00. If i set the "iptables -A FORWARD -m state --state ESTABLISHED,RELATED 
-j ACCEPT" rule after time conditional matches, then bigger traffic will kill 
slow machines because of many unnecessary checks in a long linear chain.

Right now I can either use recent lists, or CONNAMRK targets:

iptables with recent lists:

---------------------
# packets accepted against time condition are also put into recent list
# and i match only those which are not listed.
iptables -A FORWARD -m recent \! --rcheck -j -m state --state 
ESTABLISHED,RELATED -j ACCEPT

[ ... about 10000 different rules ... ]

iptables -A INPUT -m time --timestart 8:00 --timestop 18:00 --days Mon -m 
recent --set -j ACCEPT
---------------------


iptables with CONNMARK:

---------------------
iptables -N TIMEACCEPT
iptables -A TIMEACCEPT -j MARK --set-mark 5
iptables -t mangle -A TIMEACCEPT -j CONNMARK --save-mark
iptables -A TIMEACCEPT -j ACCEPT

iptables -A PREROUTING -t mangle -j CONNMARK --restore-mark


iptables -A FORWARD -m mark \! --mark 5 -m state --state ESTABLISHED,RELATED 
-j ACCEPT

[ ... about 10000 different rules ... ]

iptables -A INPUT -m time --timestart 8:00 --timestop 18:00 --days Mon -j 
TIMEACCEPT
---------------------

But both of them are rather hacks, than a correct solutions.

Would it be possible to add extention that connections accepted in time 
conditional rules are valid in ip_conntrack table only to the end of 
condition? Hypothetical example:

---------------------
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

[ ... about 10000 different rules ... ]

iptables -A INPUT -m time --timestart 8:00 --timestop 18:00 --days Mon 
--with-validlimit -j ACCEPT
---------------------

For example if the connection arrives/begins at Mon 17:59, that means the 
entry in ip_conntrack will expire automatically at 18:00.


PS Please excuse my bad English.

-- 

Kaupo Arulo
