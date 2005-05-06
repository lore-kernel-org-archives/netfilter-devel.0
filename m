From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Just starting with libipq
Date: Fri, 06 May 2005 12:54:28 +0000
Message-ID: <427B6904.70300@outerspace.dyndns.org>
References: <427A29A0.8020502@reading.ac.uk>
	<427B6809.4060300@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Duncan Godfrey <d.j.godfrey@reading.ac.uk>
In-Reply-To: <427B6809.4060300@outerspace.dyndns.org>
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

Quoting Jonas Berlin on 2005-05-06 12:50 UTC:

>>>quick.c:56: error: dereferencing pointer to incomplete type
>>>quick.c:58: error: dereferencing pointer to incomplete type
> 
> 
>>>     struct iphdr *ip = (struct iphdr*) m->payload;
>>>
>>>     struct tcphdr *tcp = (struct tcphdr*) (m->payload + (4 * ip->ihl));

Sorry for bad quote, the lines with errors were actually:

      struct tcphdr *tcp = (struct tcphdr*) (m->payload + (4 * ip->ihl));

      int port = htons(tcp->dest);

.. since the error message occurs when using a structure/union, not when
 declaring it. Nevertheless, it was just my quote bug, the solution
stays the same :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCe2kCxyF48ZTvn+4RAqcLAKC1lDLBikCu4nnq+3xwtluH8L2v1wCfdhr/
vc8bGniDkxJ8veM9StUFYhA=
=PRXh
-----END PGP SIGNATURE-----
