From: dmorris <dmorris@neogenen.com>
Subject: Re: Interface matching on bridge interfaces in 2.5
Date: 03 Apr 2003 19:47:43 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049428071.18371.2411.camel@timmy>
References: <1049417824.18371.2399.camel@timmy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dmorris <dmorris@neogenen.com>
In-Reply-To: <1049417824.18371.2399.camel@timmy>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

<sheepish grin>
Sorry, physdev does actually work.
I was just using it incorrectly.

iptables -m physdev -t nat -A PREROUTING -p tcp --physdev-in eth0 -j
REDIRECT --to-port 1234          

On Thu, 2003-04-03 at 16:56, dmorris wrote:
> I'm running a bridge on 2.5.66 (br0 with two interface, eth0 and eth1)
> 
> I'm trying to get the interface matching to work like it used to.
> 
> In 2.4.18 with the bridge-nf patch, I could say 
> iptables -t nat -A PREROUTING -p tcp -i eth0 -j REDIRECT --to-port 1234
> or
> iptables -t nat -A PREROUTING -p tcp -i br0 -j REDIRECT --to-port 1234
> and it would match the correct things.
> 
> In 2.5.66 with ebtables and ebtables-nf, it will only match if I say
> iptables -t nat -A PREROUTING -p tcp -i br0 -j REDIRECT --to-port 1234
> and not
> iptables -t nat -A PREROUTING -p tcp -i eth0 -j REDIRECT --to-port 1234
> even if the packets were coming from eth0
> 
> It used to match on eth0 or br0 if it was coming in on the eth0
> interface.
> not it only matchs on br0 even if its coming in on eth0.
> 
