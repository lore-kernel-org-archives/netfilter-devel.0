From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: New extension: CRYPT target
Date: Sun, 21 May 2006 18:57:41 -0400
Message-ID: <10007.1148252261@sandelman.ottawa.on.ca>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
	<4470D859.7000706@speedy.com.ar>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: Message from Gervasio Bernal <gervasiobernal@speedy.com.ar>
	of "Sun, 21 May 2006 18:15:05 -0300." <4470D859.7000706@speedy.com.ar>
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


>>>>> "Gervasio" == Gervasio Bernal <gervasiobernal@speedy.com.ar> writes:
    Gervasio> Carl-Daniel Hailfinger wrote:
    >> Gervasio Bernal wrote:
    >> 
    >>> (on host A, 1.2.3.4, FTP client) # iptables -t mangle -A
    >>> POSTROUTING -d 1.2.3.5 -p tcp --dport 20:21 -j CRYPT --cipher
    >>> blowfish --key topsecret --mode ecb --direction encrypt
    >> 
    >> 
    >> Ouch. If anybody runs ps while this iptables command is running,
    >> he has your top secret key.
    >> 
    >> Does this provide any benefit over IPSEC?
    Gervasio> IPSEC/OpenSwan is complicated to use and quite heavy.
  
  Have you tried?
  It is not heavy. Your solution is generally rather incomplete, since
it seems to lack any configuration file, policy system, or automatic key
management. 

  It is only complicated if you have been mislead into assuming that you
need a certificate. (ipsec-tools' racoon is guilty in that regard)

    Gervasio> CRYPT is truely peer-to-peer. It is compatible with
    Gervasio> routing daemons. It allows you to encrypt all the traffic
    Gervasio> between two endpoints or only certain type of traffic (ej:
    Gervasio> only TCP connections). It is extremely easy to use for an

  I do exactly that regularly.

    Gervasio> administrator familiarized with Linux firewalling since it
    Gervasio> uses Iptables and it does not make any modification to the
    Gervasio> normal routing behavior. CRYPT is considerably light and

  We have patches that permit you to decide what to encrypt using
iptables. 

- -- 
]       ON HUMILITY: to err is human. To moo, bovine.           |  firewalls  [
]   Michael Richardson,    Xelerance Corporation, Ottawa, ON    |net architect[
] mcr@xelerance.com      http://www.sandelman.ottawa.on.ca/mcr/ |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [

    "The Microsoft _Get the Facts CD_ does not work on Linux." - orospakr




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Finger me for keys

iQEVAwUBRHDwY4CLcPvd0N1lAQI1Mwf/XpEika5C4N2GVLtLg1MEuXoQ+Sy5qKjX
KloJjQKnHPbz24sHJ6/80DtmXD4HmfaIfaDkjstgjxqEdoA0YR5MgwPgeucLhGVn
INXnTBrCHKamqMmI0I+RoH2pHbxNmtd1C849FF0gwzD//vwKqaIaVjxqkyXn1d6B
MMkPZwcnSY+NIDIab2O5Ycm0A5LfLTAsO8+MDxpP5LItjtAkT3Ur8AJdFgC8afwu
wnjFVzfZ/v2Rlgrolf6+0wH7VNVCkMcoiPp+DUmU5EhXyLMRvYzq8HwIcJLNgaGm
pP11DUKI8fAckx8APWmCSbmrR6MQFCmYeY8bTcr+D/kNJXJfkvJB+Q==
=eCAB
-----END PGP SIGNATURE-----
