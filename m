From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Help ip-limit
Date: Tue, 15 Mar 2005 02:11:59 +0200
Message-ID: <4236284F.8010600@outerspace.dyndns.org>
References: <200503140925.28555.denilson@bnet.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: denilson@bnet.com.br
In-Reply-To: <200503140925.28555.denilson@bnet.com.br>
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

Denilson Guedes Duarte wrote:

| I reading for a iptables because I need to make a solution to my case:
| I have a sever that I use only to redirect packets to another sever, I
control by IP source like example:
|
| iptables -A INPUT -s 200.sss.sss.sss -j ACCEPT -p tcp --dport 23
| /usr/sbin/iptables -t nat -A PREROUTING -s 200.sss.sss.sss -j DNAT -d
200.lll.lll.lll -p tcp --dport 23 --to 172.ddd.ddd.ddd:23
|
| /usr/sbin/iptables -t nat -A POSTROUTING -j SNAT -d 172.ddd.ddd.ddd -p tcp
- --dport 23 --to-source 172.aaa.aaa.aaa
|
| 200.sss.sss.sss = IP source Client
| 200.lll.lll.lll = IP Server localhost - extern IP
| 172.ddd.ddd.ddd = IP destination Server
| 172.aaa.aaa.aaa = IP configured to accept conections on 172.ddd.ddd.ddd
|
| I want to control the limit of conections by IP source simultaneous-use,
Ex. IP 200.sss.sss.sss can use 3 conections in the same time.
|
| It's possible?

Yes, by using the "connlimit" patch in patch-o-matic:

~  http://www.no.netfilter.org/patch-o-matic/pom-base.html#pom-base-connlimit

So after you install that, I think you could do like this on the router:

iptables -A FORWARD -p tcp --syn --dport 23 -m connlimit \
~      --connlimit-above 3 -j REJECT

This should reject new connections if there are already 3 open connections.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCNihNxyF48ZTvn+4RArqOAKCz1M7oHsbCg69NlvSIbdZsv2WD6ACeJvrg
KZyVzvwz06x2v8PSR/fCFIg=
=suCS
-----END PGP SIGNATURE-----
