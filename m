From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: The big Picture of all the tables ...
Date: Sat, 04 Jun 2005 22:11:15 +0000
Message-ID: <42A22703.5090000@outerspace.dyndns.org>
References: <3abe8064b60ddf1a@mayday.cix.co.uk>
	<42A218B8.8060504@outerspace.dyndns.org>
	<5559d90e8cb32fad@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert de Bath <list-netfilter@debath.co.uk>
In-Reply-To: <5559d90e8cb32fad@mayday.cix.co.uk>
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

Quoting Robert de Bath on 2005-06-04 21:49 UTC:
>>> 3) What happens if you use NOTRACK.
>>
>> If you look at my pic, NOTRACK makes the packet skip all the green boxes.
> 
> But what about the pink boxes (NAT), they can't do anything without
> connection tracking but do they try?

Yeah, I'm 99% sure nat isn't traversed either, nat afaik requires
connection tracking..

>>> 4) Is there anything else that can make a packet deviate (cf: DROP)
>>
>> Well there is QUEUE but I guess it continues from where it left off..
>> I'm not really sure.
> 
> Hmmm, QUEUE ... :-/

I mean

  iptables ... -j QUEUE

I don't know where in the chain it should/can go..

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCoicBxyF48ZTvn+4RAvE2AKDmyW8VVf1rwtgwAcP7lC2Z/9u9YQCfZJm7
ySFngQVolJnutrFFFln4IzE=
=q2uT
-----END PGP SIGNATURE-----
