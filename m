From: J Webb <jon_webb@binary-one.com>
Subject: Re: Can iptables do this?
Date: Wed, 11 Jun 2003 21:05:59 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EE7FC27.4060605@binary-one.com>
References: <see85e4d.066@gwia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <see85e4d.066@gwia>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

That is more of a Mobile-IP type issue. A laptop with any old ip address 
will not be able to talk to the rest of your network (or gateway) 
properly unless it has an IP on that network. ARP, among other things, 
will be completely broken. The laptops with the pre-configured static 
IP's would have to set themselves to use your internal gateway, and 
unless they are in the same network, they will have no route to that, or 
any other, host. I believe IPTables can't help you here.

- Jon

Wei Ming Long wrote:

>Hi Everyone,
>I have posted this question before but got no response, so I'm posting it
>again, please pardon me if you have seen this before.
>I have a wireless network with my linux machine as a gateway between the
>internet & my internal wireless network. I have iptables running on the
>gateway & also a dhcp server to serve out ip addresses to the client laptops.
>I also run the Squid proxy server on the gateway to proxy http requests. I use
>iptables to redirect http traffic to Squid and to do nat for the internal
>network.
>My question is this: what if a laptop with a preconfigured static ip address
>comes into the internal network or worse, 2 client laptops with identical
>preconfigured static ip addresses enter into network, can iptables do nat
>based on mac address <--> public ip address mapping besides the usual private
>ip address <--> public ip address mapping?
>
>Please help. Thanks.
>
>Best regards
>Matthew
>
>  
>
