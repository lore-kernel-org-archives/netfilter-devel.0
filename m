From: "Qiang" <qzhang@endeavorsystems.net>
Subject: skb unknown? {Virus Scanned}
Date: Thu, 29 Apr 2004 17:01:35 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404292105.i3TL5ePW014312@localhost.localdomain>
References: <Pine.LNX.4.44.0404292002100.30100-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404292002100.30100-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I am trying to copy packets received in a netfilter module and forward it as
IPIP packet to another destination IP address, am copying the SKB and then
put it into NF_HOOK(local_out, ip_finish_output), although it can be sent
out, but some bug report is coming out from the 2.6.4 kernel and it flooded
the console! Like below

-----------------------------------------------
Ip_finish_output: bad unowned skb= 
Skb pf=2 (unowned) dev=eth0 len=72
PROTO=4 192.168.0.187:0 192.168.0.129:0 L-72 S=0x00 I=1 J=0x4000 T=64
BUG: dst underflow -9388: c04643c
---------------------------------------

How can I solve this problem? Anything special in the skb operations?

Urgent and Thank you very much!
