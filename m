From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 11:05:42 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206071105.42881.hno@marasystems.com>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>,
	netfilter-devel@lists.samba.org
In-Reply-To: <3D006B9E.1040809@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Emmanuel Fleury wrote:
> For example, you can make up the following ruleset:
>
> o DENY SYN from outside -> inside
> o Allow NEW, ESTABLISHED, RELATED
>
>
>                        +-----------+
> +--------+    +--+    | Hidden Net|
>
> |Internet|----|FW|----| w/o NAT   |
>
> +--------+    +--+    +-----------+
>
>
> On this configuration, you allow all the computers of your hidden net
> to have their own IP address and you disallow any sort of scan from
> outside. You can even imagine to have a web server somewhere in your
> hidden network (you just have to add as first rule that you allow
> all the traffic on the port 80 to this precise IP address).
>
>
> This configuration can't be done with Netfilter because you are doing
> what we could call "connection tracking" and not "stateful inspection".

This configuration can be done just fine with iptables as demonstrated in my 
earlier message, but here we go again (but slightly different):

# Allow existing connections
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# Allow hidden net to initiate new connections (including connection pickup)
iptables -A FORWARD -i eth0 -j ACCEPT
# Drop anything else
iptables -A FORWARD -j DROP

And is considerably more secure design than your proposed use of NEW above if 
you include other protocols than TCP into the mix, plus has the added bonus 
that connection pickup will allow some connections from the hidden network to 
be picked up after a reboot.

Note: The external network is NOT allowed to cause connection pickup, only 
packets send by your hidden network will.

Regards
Henrik
