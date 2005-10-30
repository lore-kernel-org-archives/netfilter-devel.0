From: Patrick McHardy <kaber@trash.net>
Subject: Re: mark value as routing key
Date: Sun, 30 Oct 2005 16:23:15 +0100
Message-ID: <4364E563.5090709@trash.net>
References: <BAY103-F12CBD5D305A6953CA1C2EEB2730@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F12CBD5D305A6953CA1C2EEB2730@phx.gbl>
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

Marco Berizzi wrote:
> Hi.
> 
> I have a problem with iptables mark target.
> I'm using iptables to mark packet in this manner:
> 
> iptables -t mangle -I OUTPUT --protocol tcp --dport 80 -j MARK --set-mark 1
> 
> This linux box has two different ip addresses on
> two different subnet on the same ethernet NIC:
> 
> eth0: 1.1.1.254/24
> eth0:adslA: 10.10.10.6/29
> 
> This is my ip rule sh output:
> 
> 0: from all lookup local
> 400: from all fwmark 0x1 lookup adsl
> 450: from all lookup hdsl
> 32766: from all lookup main
> 32767: from all lookup default
> 
> Here is ip route sh table adsl:
> default via 10.10.10.1 dev eth0 metric 1
> and this is ip route sh table hdsl:
> default via 1.1.1.1 dev eth0 metric 1
> 
> main table doesn't have any default route.
> 
> Locally generated packet with destination port 80
> are going through the adsl table but the packet
> source ip is 1.1.1.254. Why source ip packet is
> 1.1.1.254? Should't it be 10.10.10.6?

The mark value can't be used for source address selection
because at the time source address selection is performed
there is no packet yet and thus no mark value.
