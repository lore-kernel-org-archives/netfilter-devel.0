From: zhi wang <pangy2004@yahoo.com>
Subject: Re: How does iptables redirect a packet that is not addressed to its local machine
Date: Wed, 7 Apr 2004 22:44:18 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040408054418.1592.qmail@web41701.mail.yahoo.com>
References: <BAY7-DAV19wEsGmjm0800027007@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grace Li <zheyinli@hotmail.com>
In-Reply-To: <BAY7-DAV19wEsGmjm0800027007@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Client (192.168.1.134) tries to connect to port 1888 of Server
> (192.168.1.115) through Gateway (192.168.1.1).  In the Gateway, the iptables
> has been instructed to redirect traffic on port 1888 to 2000 (iptables -t
> nat -A PREROUTING -i eth0 -p tcp --dport 1888 -j REDIRECT -to-port 2000 ).

At the client execute:
traceroute -n 192.168.1.115
to make sure that the client DID send the packet to the gateway

__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
