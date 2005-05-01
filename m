From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: iptables command and target ULOG problem
Date: Sun, 01 May 2005 20:06:00 +0000
Message-ID: <427536A8.7040001@outerspace.dyndns.org>
References: <79a98d9f05050112304848c6ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andre Luiz da Silva <andrack@gmail.com>
In-Reply-To: <79a98d9f05050112304848c6ce@mail.gmail.com>
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

Quoting Andre Luiz da Silva on 2005-05-01 19:30 UTC:

> Hello friends...

Hello :)

> When I insert the rule and the parameter '-j ULOG' are before icmp protocol
> options, I received the error "Bad argument":
> 
> andre:~/iptables-1.2.11 # ./iptables -I INPUT -j ULOG --protocol icmp
> --icmp-type echo-reply
> Bad argument `echo-reply'
> Try `iptables -h' or 'iptables --help' for more information.
> 
> But with '-j ULOG' later the icmp protocol options (or any other
> options), no error occurs.
> 
> andre:~/iptables-1.2.11 # ./iptables -I INPUT --protocol icmp
> --icmp-type echo-reply -j ULOG

I think options should be grouped together with their owners, and all
options after -j <ANYTHING> should be associated with the target.

FYI: I'm not a regular maintainer, just expressing my thoughts here :)

> This problem does not occur with target "LOG".

It might be that LOG does not validate its arguments strictly and thus
not react on the "echo-reply" argument. Or it might be some peculiar
iptables bug..

> Any ideias? 

Just put --icmp-type echo-reply before -j :)

> Thank's

Be well :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCdTanxyF48ZTvn+4RAm/4AKDalaJR0tbaonulqgNeV4SBxNf8FgCgp75r
lFEYC84MW2kSGcVgTFDk6Q8=
=VosE
-----END PGP SIGNATURE-----
