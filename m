From: "Wei Ming Long" <WEI_Ming_Long@dsi.a-star.edu.sg>
Subject: Re: Can iptables do this?
Date: Thu, 12 Jun 2003 15:33:45 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <see89d65.074@gwia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <jon_webb@binary-one.com>,<netfilter-devel@lists.netfilter.org>
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

Correct me if I'm wrong, when the laptop with the preconfigured static ip
comes into the network, it will do a arp broadcast to find the mac address of
it's gateway, so can iptables capture this arp packet (at the same time reply
to this arp request), extract the mac address and keep this in a table so that
the next time this same laptop sends a http request packet out onto the
network, the mac address in the packet header is extracted & mapped to the
private ip address before resending this same http request packet out into the
internet cloud. When the http reply packet comes back, iptables will look up
the mac address <--> private ip table and then send this reply packet back to
the laptop. 

Is this all possible? or is it possible to add code to netfilter to achieve
this? I'm prepared to write code to netfilter to do this if not already
possible but just want to make sure that this feature or functionality is not
already present so that I don't have to do redundant job.

Thanks
Matthew


>>> J Webb <jon_webb@binary-one.com> 06/12/03 12:05PM >>>
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
>gateway & also a dhcp server to serve out ip addresses to the client
laptops.
>I also run the Squid proxy server on the gateway to proxy http requests. I
use
>iptables to redirect http traffic to Squid and to do nat for the internal
>network.
>My question is this: what if a laptop with a preconfigured static ip
address
>comes into the internal network or worse, 2 client laptops with identical
>preconfigured static ip addresses enter into network, can iptables do nat
>based on mac address <--> public ip address mapping besides the usual
private
>ip address <--> public ip address mapping?
>
>Please help. Thanks.
>
>Best regards
>Matthew
>
>  
>
