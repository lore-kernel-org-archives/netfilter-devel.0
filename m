From: "Darius Tribandis" <sirijus@kobra.ktu.lt>
Subject: -m limit problem
Date: Tue, 21 Sep 2004 00:12:12 +0300
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1e0e01c49f56$7f61b490$523e000a@sirijus>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1257"
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

i try explain it with examples...

/usr/sbin/iptables -t nat -N httpinfo
/usr/sbin/iptables -t nat -A PREROUTING -p tcp -s USERIP -m mac --mac-source
AA:AA:BB:BB:CC:CC -m multiport --destination-port 80,8080,3128 -j httpinfo
/usr/sbin/iptables -t nat -A httpinfo -p tcp -s 10.5.4.14 -m limit --limit
1/day --limit-burst 1 -j DNAT --to LOCALIP:5454

after that it acts ok. 1 time per day i will get redirected.

sometimes i nead some times per day do like this:

/usr/sbin/iptables -t nat -F PREROUTING
/usr/sbin/iptables -t nat -A PREROUTING -p tcp -s USERIP -m mac --mac-source
AA:AA:BB:BB:CC:CC -m multiport --destination-port 80,8080,3128 -j httpinfo

here problem begins.
i am not modifaing httpinfo table but i geting redirect after every reload
like this.

Can anyone help with this

Thanks
---
D. Tribandis
Kaunas University of Technology
Institute of Information Technology Development
