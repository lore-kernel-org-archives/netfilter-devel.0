From: cranium2003 <cranium2003@yahoo.com>
Subject: how to determine next hop ip at Router?
Date: Sat, 7 May 2005 07:27:43 -0700 (PDT)
Message-ID: <20050507142744.68229.qmail@web41424.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

hello,
I have setup a network with 4pcs as
HostA
eth0=> 192.168.1.100

Router1
eth0=>10.1.1.1
eth1=>192.168.1.1

Router2
eth0=>10.1.1.100
eth1=>172.16.1.1

HostB
eth0=>172.16.1.100

And set Router1 and Router2 as packet
forwarder(Router). Now what i 
want is when i send a packet from HostA to HostB
packet is still sent as src ip=192.168.1.100 and dest
ip=172.16.1.100 its ok but how can i check at Router1
that packet is Direct Delivery or Indirect Delivery?
What i want that i should get information at Router1
that whaterver HostA sends a packet with dest ip
172.16.1.100 i should get that next ip to which packet
is going to be forwarded. In here i want to get
information that though dest ip is 172.16.1.100 the
next ip is 10.1.1.100?
         How to get that info???
regards,
cranium


		
Discover Yahoo! 
Have fun online with music videos, cool games, IM and more. Check it out! 
http://discover.yahoo.com/online.html
