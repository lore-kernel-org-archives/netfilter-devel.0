From: "Wei Ming Long" <WEI_Ming_Long@dsi.a-star.edu.sg>
Subject: iptables help
Date: Thu, 04 Nov 2004 10:40:51 +0800
Message-ID: <s18a0743.032@dsi.a-star.edu.sg>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>,
	<Netfiltermailinglistnetfilter@lists.netfilter.org>
Content-Disposition: inline
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


Hi everone,

I have a setup as shown below:

                   VNC Server 192.168.1.4
                          |
                          | --------> ssh tunnel on port 5800
                          |
                eth1= 192.168.1.2
                          |
                Linux Gateway
                          |
                 eth0=192.168.33.167
                          |
                          |
                 WindowsXP 192.168.33.164 
          

Requirement: To be able to access the VNC Server behind the Linux gateway
using the web browser on port 5800 tunneled through ssh.

I created a ssh tunnel between the VNC Server(192.168.1.4) & the Linux
Gateway(192.168.1.2) for port 5800 and the following iptables command in
Gateway:

iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to
192.168.1.2:5800 

When I type in http://192.168.33.167 in the browser on the WindowsXP machine,
Iwas expecting that the http request on port 80 would be redirected to port
5800 & go through the tunnel & reach the VNC Server.

But it doesn't work, what is wrong? can someone please help me with this?


Best regards
Matthew


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
This email is confidential and may be privileged. If you are not the intended recipient, please delete it and notify us immediately. Please do not copy or use it for any purpose, or disclose its contents to any other person. Thank You.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
