From: Simon Lodal <simonl@parknet.dk>
Subject: Re: [RFC][0/2] New netfilter match module
Date: Wed, 31 May 2006 05:01:50 +0200
Message-ID: <200605310501.50268.simonl@parknet.dk>
References: <20060531011443.95001.qmail@web50208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alex Davis <alex14641@yahoo.com>
In-Reply-To: <20060531011443.95001.qmail@web50208.mail.yahoo.com>
Content-Disposition: inline
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


This is generally useful for DHCP setups. A distribution can much easier make 
a default firewall setup that simply matches input traffic on "ip of 
interface", so the user does not need to configure it, and it works even with 
dynamically changing DHCP adresses.

The reverse match ("interface of ip") could also be interesting to detect 
martian traffic very easily.

I would rename it, fx to "ipof" or "ipat", like:
iptables -m ipat --dst --iface eth0

Separation of --dst and --iface so it can later be extended to match "ip at 
network" and "ip at vlan".


Simon


On Wednesday 31 May 2006 03:14, Alex Davis wrote:
> The scenario:
>
> A box is functioning as a NATting firewall with a public and a private
> network interface, hereafter referred to as pub0 and priv0. Connected to
> priv0 are several boxes, one of which is a web server. The public IP
> address is dynamic. Running an internal DNS server is not an option. A
> dynamic DNS provider is used to keep the public host name of the firewall
> sync'ed with its public IP address, which is assigned to pub0.
>
>
>
> The problem:
>
> There is no reliable way to direct network traffic from the private network
> hosts for the public IP address of the firewall to the web server, and
> still have traffic not destined for the public address go to the correct
> destination. For example, one could create the following rule:
>
>     iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT
> --to-destination <webserver address>
>
> but this directs _all_ port 80 traffic to the web server. The rule
>
>     iptables -t nat -A PREROUTING -p tcp -d <public address> --dport 80 \
>                  -j DNAT --to-destination <webserver address>
>
> works fine, until the public address changes.
>
>
>
> The solution:
>
> I have created a match called 'ipisforif' (IP address IS FOR network
> InterFace), which checks to see if the destination or source IP address of
> the packet matches the IP address of a network interface.
>
> The syntax is:
>
> ipisforif < --srcip | --dstip > <interface name>
>
> Example:
>
> To always route HTTP traffic from the private network hosts for the public
> IP address (and _only_ the public IP address) to the web server, use the
> following rule:
>
>     iptables -t nat -A PREROUTING -i priv0 -p tcp --dport 80 -m ipisforif \
>                  --dstip pub0 -j DNAT --to-destination <webserver address>
>
> Two emails containing one patch each will follow.
>
> This code is currently being used on a 2.6.16.17 kernel.
>
>
> I code, therefore I am
>
> __________________________________________________
> Do You Yahoo!?
> Tired of spam?  Yahoo! Mail has the best spam protection around
> http://mail.yahoo.com
