From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: forwarding one port to a port range with REDIRECT target
Date: Sat, 05 Mar 2005 17:53:55 +0200
Message-ID: <4229D613.1060300@outerspace.dyndns.org>
References: <013c01c520d3$8d037710$1416a8c0@lannion.citypassenger.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: olivier <odanes@free.fr>
In-Reply-To: <013c01c520d3$8d037710$1416a8c0@lannion.citypassenger.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

olivier wrote:

| Hi all,

Hello!

| I would like to use the REDIRECT target to load balance incoming HTTP
connections to a few couple of processes (not webservers).
| for example incoming connections are received on port 8000 and
forwarded to port 8080 and 8081 (or more).
| I try the following rule:
|
| iptables -t nat -A  PREROUTING -p tcp --dport 8000 -j REDIRECT
- --to-ports 8080-8081
|
| the rule seems to be good according to the man page, but all the
connections are forwarded to the same port (8080 in this example). I've
tried different clients with odd and even IPs but nothing change.

I don't remember how REDIRECT works exactly, but if you say it seems to
be fixed, let's assume it is.

In patch-o-matic-ng there's a nth patch that you could use to implement
round-robin. Let's say you had 3 ports 8080-8082:

iptables -t nat -A  PREROUTING -p tcp --dport 8000 -m nth --counter 0
- --every 3 --packet 0 -j REDIRECT --to-ports 8080
iptables -t nat -A  PREROUTING -p tcp --dport 8000 -m nth --counter 0
- --every 3 --packet 1 -j REDIRECT --to-ports 8081
iptables -t nat -A  PREROUTING -p tcp --dport 8000 -m nth --counter 0
- --every 3 --packet 2 -j REDIRECT --to-ports 8082

The "nth" patch is described here:

http://www.no.netfilter.org/patch-o-matic/pom-base.html#pom-base-nth

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCKdYRxyF48ZTvn+4RAijCAJwIOY7kWLFzfEdLKsw8qVr1mE4NVACg1A1Z
sSS08dtLY3qcgDx8KtL3luU=
=YMLh
-----END PGP SIGNATURE-----
