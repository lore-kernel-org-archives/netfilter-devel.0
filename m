From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC][0/2] New netfilter match module
Date: Fri, 02 Jun 2006 13:46:27 +0100
Message-ID: <44803323.5000706@ufomechanic.net>
References: <20060531011443.95001.qmail@web50208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20060531011443.95001.qmail@web50208.mail.yahoo.com>
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

Alex Davis wrote:
> The scenario:
> 
> A box is functioning as a NATting firewall with a public and a private network interface,
> hereafter referred to as pub0 and priv0. Connected to priv0 are several boxes, one of
> which is a web server. The public IP address is dynamic. Running an internal DNS server
> is not an option. A dynamic DNS provider is used to keep the public host name of the firewall 
> sync'ed with its public IP address, which is assigned to pub0.
> 
> 
> 
> The problem:
> 
> There is no reliable way to direct network traffic from the private network hosts for the public
> IP address of the firewall to the web server, and still have traffic not destined for the public
> address go to the correct destination. For example, one could create the following rule:
> 
>     iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination <webserver address>
> 
> but this directs _all_ port 80 traffic to the web server. The rule
> 
>     iptables -t nat -A PREROUTING -p tcp -d <public address> --dport 80 \
>                  -j DNAT --to-destination <webserver address>
> 
> works fine, until the public address changes.


I think a general solution like this is good.
Specially, however, could you not solve it using ! with a rule like:

iptables -t nat -A PREROUTING -p tcp -s ! 10.18.0.0/24 --dport 80 \
         -j DNAT --to-destination <webserver address>

i.e. for non locally originating traffic to port 80, use the webserver
Of course if you had multiple local subnets you might need

iptables -t nat -A PREROUTING -j try_80
iptables -t nat -A try_80 -p tcp -s 10.18.0.0/24 -j RETURN
iptables -t nat -A try_80 -p tcp -s 10.18.20.0/24 -j RETURN
iptables -t nat -A try_80 -p tcp --dport 80 -j DNAT --to-destination
<webserver address>

Sam
