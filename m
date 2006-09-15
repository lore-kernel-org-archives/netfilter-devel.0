From: "Yuriy Popyk" <fennister@gmail.com>
Subject: Problems with SNAT
Date: Fri, 15 Sep 2006 08:55:17 +0300
Message-ID: <8a3f83490609142255r4785dc2fucaa1813179ae67bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello

I have wrote this mail to netfilter@lists.netfilter.org but nobody answered,
so can i ask you ?


 We have a lan with ips in private range
 Problem is described with a following pic

 ----------      ----------
  |  PC2 |-----|  R2   |
  ----------      ----------
                   |
                   |
                 ----------         ----------
                 |   R1  |--------|  PC1 |
                 ----------         ----------
                     |
                 ----------
                  | ISP |
                  ----------

 R1 - router 1, linux
 R2 - router 2, ms windows 2000
 PC1 - pc 1, ms windows XP
 PC1 - pc 1, ms windows 2000

 when I'm trying to set SNAT on R1 for PC1
 # iptables -t nat -A POSTROUTING -s  $pc1 -j SNAT --to-source $ip_to_isp
 it works

 but when I'm trying to set SNAT for PC2
 # iptables -t nat -A POSTROUTING -s  $pc2 -j SNAT --to-source $ip_to_isp
 it fails

 tcpdump -nl -i $ISP_eth
 shows that R1 forwards packets from PC2 to outside world without NATing
 and in the same time packets from PC1 is NATed

 when i made
 # iptables -t filter -A FORWARD -s PC2 -j DROP
 it works, packets from PC2 is not going outside anymore

 i have tried to do SNAT with firewall rules flushed and policies set to ACCEPT
 the problem appeared again

 Thanks in advance
