From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: promiscuous mode
Date: Sun, 05 Jun 2005 20:21:23 +0000
Message-ID: <42A35EC3.1070905@outerspace.dyndns.org>
References: <32849.62.231.54.154.1117789778.squirrel@webmail.cs.tcd.ie>
	<42A16B04.5050807@outerspace.dyndns.org>
	<34862.62.231.54.45.1117987252.squirrel@webmail.cs.tcd.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: knash@cs.tcd.ie
In-Reply-To: <34862.62.231.54.45.1117987252.squirrel@webmail.cs.tcd.ie>
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

Quoting knash@cs.tcd.ie on 2005-06-05 16:00 UTC:

> Jonas,
>      Thanks for the info :-). I tried what you suggested by changing the
> rp_filter setting but this does not appear to effect the packets I
> see at the NF_IP_PRE_ROUTING hook.
> 
> Does this mean that rp_filter comes into effect after the
> NF_IP_PRE_ROUTING hook and before the NF_IP_LOCAL_IN hook?.

Sorry, I really have no idea about that.. I just hoped that rp_filter
would have helped :P

Hopefully somebody else can help out, you could also come to #netfilter
on freenode ircnet and ask..

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCo17CxyF48ZTvn+4RAqDEAKC3pJzDh7lS46qhM1csQI9VUls6hgCg0CF1
lP0k9XEHZnmD5E+LXQII4lE=
=/Nnt
-----END PGP SIGNATURE-----
