From: Svenning Sorensen <sss@sss.dnsalias.net>
Subject: Re: cttest-0.1
Date: Sun, 07 Jul 2002 04:30:00 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <5.1.0.14.0.20020707013649.00bfce68@sss.dnsalias.net>
References: <20020706224109.GH3729@aaricia.hemmet.chalmers.se>
 <20020705165354.GD3729@aaricia.hemmet.chalmers.se>
 <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com>
 <20020706091259.F13116@oknodo.bof.de>
 <20020706172342.H13116@oknodo.bof.de>
 <20020706211451.GG3729@aaricia.hemmet.chalmers.se>
 <20020706224109.GH3729@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson),
	Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
In-Reply-To: <20020706231628.GJ3729@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

At 01:16 07-07-2002, Joakim Axelsson wrote:
>I guess you all are begining to get a little tired of my mails :-). Anyhow
>on our little misstake what ^ really does in C (should have known better
>:-). I guess I seldom use xor in my c-code.) res ^= 0x47441DFB ^ 0x57655A7D
>is kinda of useless then. So I changed it into:
>
>res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
>res ^= key->sip ^ key->proto;
>res ^= key->dport ^ key->sport;
>res ^= 0x47441DFB;
>res ^= (res >> 24);
>res ^= (res >> 8);
>res ^= 0x57655A7D;

Heh, still as useless... :)
Two random 32 bit values xor'ed gives, well, 32 random bits.
And you don't get more randomness into the first value by shifting and
xor'ing with itself.

But actually, I don't see how it buys you anything to xor with a random value.
It doesn't effect the distribution of the hash values, so an attacker can
still attack a single bucket. He just doesn't know which one, but I bet he
doesn't care :)

A multiplication would be slightly better (and more expensive, cpu-wise),
since that would make it harder to predict which input bits change which
output bits. Furthermore, you need to perform the two prf functions on
different parts of the input, so any variation in one part of the input
can't be easily nullified by the inverse variation in the other part.

Maybe it would also make sense to distribute the source & destination ports
across all 32 bits, and similarly mix the high and low parts better,
like this (completely untested):

        res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
        res ^= (res * secret_value_a);
        res ^= key->sip ^ key->proto;
        res ^= (key->dport << 16) ^ key->sport;
        res ^= (res * secret_value_b);
        res ^= ((res >> 25) | (res << 7));

The compiler should optimize the two last shifts into a single rotate instruction.



Svenning
