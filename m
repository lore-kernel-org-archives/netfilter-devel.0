From: Balazs Scheidler <bazsi@balabit.hu>
Subject: ICMP match bug
Date: Mon, 27 Jan 2003 15:01:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030127140143.GA29965@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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

Hi,

We have found a problem with ICMP match. I'm afraid it is not easy to fix
due to compatibility problems but here it goes:

if I add a rule with a command line like this:

iptables -A INPUT -p icmp -j ACCEPT

then no extra match is added to the rule:

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0          

if I add a rule with a command line like this:

iptables -A INPUT -p icmp -m icmp -j ACCEPT

(note that no --icmp-type was specified), it results in:

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0          icmp type 0 

Thus, --icmp-type was assumed, and its value is 0

A similar thing happens with TCP/UDP but match assumes a wildcard default:

iptables -A INPUT -p udp -m udp -j ACCEPT

ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0          udp 

thus matches all UDP packets.

We encountered this problem because we generate iptables-restore compatible
output. iptables-restore does not demand load protocol matchers (thus we
needed explicit match specifications to be able to use --dport & friends).
We rewrite rules by sed -e 's/-p \(.*\)/-p \1 -m \1/', thus iptables -p icmp
becomes iptables -p icmp -m icmp unconditionally.

The solution would be either to create a 'wildcard' match for -m icmp which
would match all packets (I'm afraid this would create incompatibilities)
_or_ to fix iptables-restore to load matches the same way as iptables itself
does.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
