From: "Wei Ming Long" <WEI_Ming_Long@dsi.a-star.edu.sg>
Subject: Can iptables do this?
Date: Thu, 12 Jun 2003 11:04:33 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <see85e4d.066@gwia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>,
	<Harald Welte<laforge@netfilter.org>>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Everyone,
I have posted this question before but got no response, so I'm posting it
again, please pardon me if you have seen this before.
I have a wireless network with my linux machine as a gateway between the
internet & my internal wireless network. I have iptables running on the
gateway & also a dhcp server to serve out ip addresses to the client laptops.
I also run the Squid proxy server on the gateway to proxy http requests. I use
iptables to redirect http traffic to Squid and to do nat for the internal
network.
My question is this: what if a laptop with a preconfigured static ip address
comes into the internal network or worse, 2 client laptops with identical
preconfigured static ip addresses enter into network, can iptables do nat
based on mac address <--> public ip address mapping besides the usual private
ip address <--> public ip address mapping?

Please help. Thanks.

Best regards
Matthew
