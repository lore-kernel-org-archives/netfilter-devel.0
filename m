From: hewa0000@student.mh.se
Subject: Rule matching question [iptables code structure]
Date: Tue, 06 May 2003 14:56:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <df0d10589.10589df0d__8860.95471582866$1052559784@student.mh.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Content-language: sv
Content-Disposition: inline
Resent-Message-Id: <E19EQQ0-0006Uo-00@kashyyyk.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

[Please mail us personally (oan@itm.mh.se) as well
as mailing the list since we are not members of this
mail-list]

We have a quite difficult question for all you elite
people.... =)
 
When we add a rule to iptables that filter on
MAC-address (or IP address and port for that
matter). Does iptables ONLY check for the
MAC-address option (alas in that case we filter on
MAC-address)?.

Based on a the report "Performance analysis of the
Linux firewall on a host" by James Harris and
Americo J. Melara. It is stated that for each check
if the MAC-address in the rule match the given
MAC-address, the Iptables-algorithm ALWAYS checks
all possibilities (MAC-address, IP, Port, Protocol,
Interface..). 
Does anyone know this to be the truth?

We are currently working on a big project where we
use big lists of rules that are based on MAC and
IP-addresses. And we are trying to understand why
these lists of rules crave so much computation power
to execute.

If Iptables always run a check for every possible
way to match our packet with a single rule
(ip,mac,protocol,interface...) it consumes alot more
(actually we belive it to be around 6 times as much
according to the nature of the algorithm) as necessary. 

Optimally the algorithm would ONLY check for a
MAC-Address match if that is what we are filtering
on. We truly hope this also is the case. But please,
someone who knows this :-) :
Answer us!

Sincerly,
Open Access Networks Project MidSweden University.
oan@itm.mh.se
