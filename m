From: "prasanna" <prasanna@bharatplanet.com>
Subject: How to share intrenet connection through NAT
Date: Wed, 17 Dec 2003 18:08:38 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000301c3c49a$b25ad210$05000a0a@bharatplanet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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
      I am using redhat 9. I connected internet to this machine. I like
to share my internet to local machines through NAT. How to configurethe
NAT?

I tried this 

modprobe iptable_nat
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

And put gateway as linux machine in local machine
But unsucessfull 

Please help with script


Thanks & Regards,
Sureshprasanna M.K
BharatPlanet Consulting Ltd.
http://www.bharatplanet.co.in 

An SEI-CMM Level 2 Company
 
