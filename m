From: Markus Saarinen <markus.saarinen@pp3.inet.fi>
Subject: Feature suggestion: internal logdrop table
Date: Wed, 17 Dec 2003 17:04:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FE0706A.9000308@pp3.inet.fi>
Reply-To: markus.saarinen@pp3.inet.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Would it be possible to have a 'logdrop' target coded into iptables?
I know that i can manually create a table with a simple log & drop rules,
but it gets very long ruleset if i want to have different log prefixes 
for different
kind of matches, e.g.:

iptables -A INPUT -s subnet1 -d somewhere -j LOG --log-prefix "fromsubnet1"
iptables -A INPUT -s subnet1 -d somewhere -j DROP
iptables -A INPUT -s subnet2 -d somewhere -j LOG --log-prefix "fromsubnet2"
iptables -A INPUT -s subnet2 -d somewhere -j DROP
...and so on...

Whereas this would seem much more convenient and logical:

iptables -A INPUT -s subnet1 -d somewhere -j LOGDROP --log-prefix 
"fromsubnet1"
iptables -A INPUT -s subnet2 -d somewhere -j LOGDROP --log-prefix 
"fromsubnet2"

 From a bit of Googling, i've seen that quite many people actually 
create these log-drop
chains by hand (myself included), so think it would actually be a quite 
useful feature.
Not to mention the few clockticks my firewall would save when it could 
just drop the
packet from the same rule without traversing back to the original chain 
and parsing
a new rule ;-)

Cheers,
Markus
