From: luoqiang <luoqiang@ict.ac.cn>
Subject: how to set up conntrck for DNAT
Date: Sat, 8 Jun 2002 11:27:38 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <02060811273800.01420@luoqiang>
Reply-To: luoqiang@ict.ac.cn
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,all

I have write a module for DNAT to achieve the purpose as follows:
iptables -A PREROUTING -t nat -p udp -d 159.226.1.1 --dport 5001 -j DNAT --to 
 192.168.1.2:8888
my code is in 
http://lists.samba.org/pipermail/netfilter-devel/2002-June/004621.html
The expected conntrack in "/proc/net/ip_conntrack" I set up is "EXPECTING: 
proto=17 src=0.0.0.0 dst=159.226.1.1 
sport=0 dport=5001" 
I don't know if my conntrack is correct here?
Then in nat module, fill the ip_nat_multi_range struct with 
192.168.1.2:8888,but no DNAT happened:-(
I am too worried now,somebody can help me ?

Thanks!
luoqiang
