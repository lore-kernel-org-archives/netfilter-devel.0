From: pawlakus@oswiecim.eu.org
Subject: new chain after egress for statistical purpose
Date: Wed, 2 Mar 2005 23:35:08 +0100
Message-ID: <200503022335.09403.pawlakus@oswiecim.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I'm just curious why there is no chain after egress? we have lots of 
chain before ingress, but we can't do accurate statistics of shaped 
trafic without using some external software. and even then, supose we 
have such a scenario:

LAN (192.168.0.0) => LINUX BOX => internet

we have a C-class LAN so we have to SNAT packet before they get out on 
the wire. We do shaping. But without some chain after egress we 
cannot measure how much traffic was uploaded by our particular LAN 
user. in this scenario, any pcap-based statistic monitor will not see 
'MARK', and that's why it is difficult to count. and other situation:
one ouf our LAN users is very annoying, and supose he/she flood our 
router with some traffic that exceed our global class for external 
device. in this scenario - our iptables counters will count traffic 
that is 'suposed to be sent' and not 'what was actually sent'. if we 
shape our external device to 2Mbit but our user will flood us with 
50Mbit, our counters on latest avaible chain (postrouting) will show 
us that he really send 50Mbit :/ pretty useless, of course we can 
assume he/she was shaped at given rate, but what if we are not sure? 
or, if we want to make really cool statistics, with all powerfull 
matches that iptables offers? 

that is why there should be some chain, called FINAL/WIRE/WHATEVER 
after egress, with only ACCEPT TARGET and default policy ACCEPT. it's 
the only way to make some really accurate statistics. or i am mising 
something?

someone will say: tc -s, but iptables is more powerfull and anyone 
will agree that with iptables we don't have to make shape class to 
count some packets. for example, all udp traffic with particular 
MARK, or all icmp traffic from one of our network. sky is the limit.
