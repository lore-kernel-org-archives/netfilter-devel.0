From: Diego Cabrero <diego.cabrero@e-attico.net>
Subject: Controling Inbound and Outbound traffic simultaneusly.
Date: Mon, 28 Nov 2005 19:12:48 +0100
Message-ID: <438B48A0.8050100@e-attico.net>
References: <4385B2EB.60209@e-attico.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <4385B2EB.60209@e-attico.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm Running two independent traffic applications between two computers 
conected point to point each other, at the same time each of these 
applications are generating trafficin one direction so i have two 
independent traffics traveling througth the same channel.

Figure:
                eth1, PC1 ---------app1-----------> eth1, PC2
                                <--------app2------------

My problem is that i am trying to control the whole inbound and outbound 
traffic through PC1 (by using IMQ for ingress) but it seems like they 
are connected somehow.

This is the script i am using:
---------------------------
Inbound control commands:
            tc qdisc add dev imq0 root handle 1: htb
            tc class add dev imq0 parent 1: classid 1:1 htb rate 
${INBOUND}kbps ceil  ${INBOUND}kbps
            iptables -t mangle -A PREROUTING -i eth1 -j MARK --set-mark 1
            tc filter add dev imq0 protocol ip parent 1:0 handle 1 fw 
flowid 1:1
            iptables -t mangle -A PREROUTING -i eth1 -j IMQ --todev 0

Outbound control commands:
            tc qdisc add dev eth1 root handle 2: htb
            tc class add dev eth1 parent 2: classid 2:1 htb rate 
${OUTBOUND}kbps ceil  ${OUTBOUND}kbps
            tc filter add dev eth1 protocol ip parent 2:0 prio 3 u32 
match ip dst 0.0.0.0/0 flowid 2:1

Any ideas?

Thanks!!
   
