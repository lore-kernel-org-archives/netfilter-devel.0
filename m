From: wanghtb@legend.com.cn
Subject: Re: How does iptables redirect a packet that is not addressed to its local
 machine
Date: Thu, 8 Apr 2004 09:47:15 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OF05773CF7.D82960E2-ON48256E70.00096C5F@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: zheyinli@hotmail.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, I wonder if the Client and the Server are in the same network,
under which the Gateway will send a ICMP Redirect message to
make the Client access Server directly.

Please check netmask of the Machines and use tcpdump packet in the 
Gateway to see what happens:-)

>Hi,
>
>I am just wondering if anybody could explain what happened in the =
>following experiments:

>Client (192.168.1.134) tries to connect to port 1888 of Server
>(192.168.1.115) through Gateway (192.168.1.1).  In the Gateway, the =
>iptables
>has been instructed to redirect traffic on port 1888 to 2000 (iptables =
>-t
>nat -A PREROUTING -i eth0 -p tcp --dport 1888 -j REDIRECT -to-port 2000 =
>).
>
>The results of my experiments is that the application on Gateway who =
>listens
>to port 2000 could not get anything, while Server receives everything
>expected on its port 1888. So my question is that did iptables do =
>anything
>here?
>
>Many thanks,
>
>Grace
