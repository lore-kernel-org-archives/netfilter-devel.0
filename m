From: Denilson Guedes Duarte <denilson@bnet.com.br>
Subject: Help ip-limit
Date: Mon, 14 Mar 2005 09:25:28 +0000
Message-ID: <200503140925.28555.denilson@bnet.com.br>
Reply-To: denilson@bnet.com.br
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
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

sorry by my english,

I reading for a iptables because I need to make a solution to my case: 
I have a sever that I use only to redirect packets to another sever, I control by IP source like example:

iptables -A INPUT -s 200.sss.sss.sss -j ACCEPT -p tcp --dport 23
/usr/sbin/iptables -t nat -A PREROUTING -s 200.sss.sss.sss -j DNAT -d 200.lll.lll.lll -p tcp --dport 23 --to 172.ddd.ddd.ddd:23

/usr/sbin/iptables -t nat -A POSTROUTING -j SNAT -d 172.ddd.ddd.ddd -p tcp --dport 23 --to-source 172.aaa.aaa.aaa

200.sss.sss.sss = IP source Client
200.lll.lll.lll = IP Server localhost - extern IP
172.ddd.ddd.ddd = IP destination Server
172.aaa.aaa.aaa = IP configured to accept conections on 172.ddd.ddd.ddd

I want to control the limit of conections by IP source simultaneous-use, Ex. IP 200.sss.sss.sss can use 3 conections in the same time.

It's possible?

Thanks.

-- 
Denilson Guedes Duarte
ISPbnet - Provedor de Internet
Uruguaiana - RS
denilson@bnet.com.br
(55) 411 6350
