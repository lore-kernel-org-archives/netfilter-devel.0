From: dmorris <dmorris@neogenen.com>
Subject: Interface matching on bridge interfaces in 2.5
Date: 03 Apr 2003 16:56:58 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049417824.18371.2399.camel@timmy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

I'm running a bridge on 2.5.66 (br0 with two interface, eth0 and eth1)

I'm trying to get the interface matching to work like it used to.

In 2.4.18 with the bridge-nf patch, I could say 
iptables -t nat -A PREROUTING -p tcp -i eth0 -j REDIRECT --to-port 1234
or
iptables -t nat -A PREROUTING -p tcp -i br0 -j REDIRECT --to-port 1234
and it would match the correct things.

In 2.5.66 with ebtables and ebtables-nf, it will only match if I say
iptables -t nat -A PREROUTING -p tcp -i br0 -j REDIRECT --to-port 1234
and not
iptables -t nat -A PREROUTING -p tcp -i eth0 -j REDIRECT --to-port 1234
even if the packets were coming from eth0

It used to match on eth0 or br0 if it was coming in on the eth0
interface.
not it only matchs on br0 even if its coming in on eth0.

Where would I go about 'fixing' this?
I'm uncertain whether this is from the new bridging code, or from a
change in netfilter.

Thanks,
-dirk


-- 
//* */   dmorris   (* www.neogenen.com *)
main(){int _=0;for(;_!=1687193639&&putchar(" \
dn\nc@oge.m"[abs(_%11)]);_=(_*42913)+115127);}
