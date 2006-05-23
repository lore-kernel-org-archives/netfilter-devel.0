From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: New extension: CRYPT target
Date: Tue, 23 May 2006 14:26:43 -0400
Message-ID: <10815.1148408803@sandelman.ottawa.on.ca>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
	<4470D859.7000706@speedy.com.ar> <4470E716.1090001@gmx.net>
	<44724DFE.5030806@speedy.com.ar> <4473380F.5050102@speedy.com.ar>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: Message from Gervasio Bernal <gervasiobernal@speedy.com.ar>
	of "Tue, 23 May 2006 13:27:59 -0300." <4473380F.5050102@speedy.com.ar>
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


uhm, the absolutely correct answer is that you have to input the key via
netlink, not via system(). call. 

The lack of a modular netlink interface to netfilter is what prevents
this.

Failing that, need to provide the key on a pipe. Perhaps have fd#3 be
open for the module to read it from the key management application.

However, in general, you don't really want to tie the iptables policy to
the keying system. You want to be able to rekey the cipher keys
independant of the policy. 

I would, btw, remove ecb mode completely. Don't even make it an
option.  It has essentially no value, and it is a code path that you
will have to test.

- -- 
]       ON HUMILITY: to err is human. To moo, bovine.           |  firewalls  [
]   Michael Richardson,    Xelerance Corporation, Ottawa, ON    |net architect[
] mcr@xelerance.com      http://www.sandelman.ottawa.on.ca/mcr/ |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [

    "The Microsoft _Get the Facts CD_ does not work on Linux." - orospakr

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Finger me for keys

iQEVAwUBRHNT4YCLcPvd0N1lAQJVGAgAvdz1pRShuuBdme/LcVfFCtbeB1EVka22
FE7VM4vqIm5LS/wJRBRU8255LG3eebiJGihgQfm+QG4OIt6nuBEyuXW64dNP4pyU
W4kt2WvM0S1zWh9iUeJ5e3RA9PvMr9S2TWCenVI1GazTnly6x701lkwEsi86gFyy
isFfQctvunDl55F/A5Q40gzRBAxoBuXlPtOcs7lKazjwP9QjHpf7KtR32b3EVdCz
mIlmIz7HVgueoJglXQNEnpn/5M9gvblRDHxmdfsugWaE3le+4VUhY7esMkdowkoT
2AdIk4phonoUkisLM+wWf8uss8e1sTmmj4QNZWcZpoeKFo4YnnktZw==
=KiuX
-----END PGP SIGNATURE-----
