From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.1
Date: Sun, 7 Jul 2002 06:23:41 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020707042341.GK3729@aaricia.hemmet.chalmers.se>
References: <20020706224109.GH3729@aaricia.hemmet.chalmers.se> <20020705165354.GD3729@aaricia.hemmet.chalmers.se> <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com> <20020706091259.F13116@oknodo.bof.de> <20020706172342.H13116@oknodo.bof.de> <20020706211451.GG3729@aaricia.hemmet.chalmers.se> <20020706224109.GH3729@aaricia.hemmet.chalmers.se> <5.1.0.14.0.20020707013649.00bfce68@sss.dnsalias.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Svenning Sorensen <sss@sss.dnsalias.net>
Content-Disposition: inline
In-Reply-To: <5.1.0.14.0.20020707013649.00bfce68@sss.dnsalias.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-07 04:30:00+0200, Svenning Sorensen <sss@sss.dnsalias.net> ->
> At 01:16 07-07-2002, Joakim Axelsson wrote:
> >I guess you all are begining to get a little tired of my mails :-). Anyhow
> >on our little misstake what ^ really does in C (should have known better
> >:-). I guess I seldom use xor in my c-code.) res ^= 0x47441DFB ^ 0x57655A7D
> >is kinda of useless then. So I changed it into:
> >
> >res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
> >res ^= key->sip ^ key->proto;
> >res ^= key->dport ^ key->sport;
> >res ^= 0x47441DFB;
> >res ^= (res >> 24);
> >res ^= (res >> 8);
> >res ^= 0x57655A7D;
> 
> Heh, still as useless... :)
> Two random 32 bit values xor'ed gives, well, 32 random bits.
> And you don't get more randomness into the first value by shifting and
> xor'ing with itself.
> 

Thx for the input!

> But actually, I don't see how it buys you anything to xor with a random value.
> It doesn't effect the distribution of the hash values, so an attacker can
> still attack a single bucket. He just doesn't know which one, but I bet he
> doesn't care :)
> 

Well, since the value is later % with the hashsize it might matters somewhat,
but not as much as a multiplication. Anyhow, you are right.

> A multiplication would be slightly better (and more expensive, cpu-wise),
> since that would make it harder to predict which input bits change which
> output bits. Furthermore, you need to perform the two prf functions on
> different parts of the input, so any variation in one part of the input
> can't be easily nullified by the inverse variation in the other part.
> 
> Maybe it would also make sense to distribute the source & destination ports
> across all 32 bits, and similarly mix the high and low parts better,
> like this (completely untested):
> 

Yepp, the spread of ports can be good.

>         res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
>         res ^= (res * secret_value_a);
>         res ^= key->sip ^ key->proto;
>         res ^= (key->dport << 16) ^ key->sport;
>         res ^= (res * secret_value_b);
>         res ^= ((res >> 25) | (res << 7));
> 
> The compiler should optimize the two last shifts into a single rotate instruction.
>

Why this rotate? 


I tested your code and concluded two things:

1. res ^= (res * value) is not good. You can't bring "parts" of the res it
self to xor with. A plain "res *= value" was better.

2. res ^= ((res >> 25) | (res << 7)); did not do the same fine thing as our
>> 24 followed by >> 8. It gave a second "hill" as a tail. Not giving a fine
line.

I also noticed that its using dip in the first shifts. Now we (me and
Martin) only got router conntrack-data where dip is a wide range. But on an
end machine/server there will to 99% only be one dip present. Considering
packets coming TO the machine. It will take more packets than it gives on an
attack. Remember also the orignal routing cache wants to know where the
packet are heading. We want to know where it came from. If anyone has more
ideas on this one I'll happly hear them. So, I swaped placed on dip and sip.
The swaping didn't seams to affect anything on my input data. Ending in this
function:

res = ((key->sip & 0xF0F0F0F0) >> 4) | ((key->sip & 0x0F0F0F0F) << 4);
res *= 0x47441DFB;
res ^= key->dip ^ key->proto;
res ^= (key->dport << 16) ^ key->sport;
res *= 0x57655A7D;
res ^= (res >> 24);
res ^= (res >> 8);

I think this solution will make the two random constanst enough independent
to make it impossible to attack one, any, bucket. Better solutions on the
two constants are welcome.

This hash takes about 25 cycles on my CPU compared to the plain first
rt-hash which takes about 20 cycles. The first rt_ab I made takes about 22
cyles.

Results on:
http://aaricia.hemmet.chalmers.se/~gozem/cttest-0.2/rt_new

I called your idea rt_sven, my new idea rt_new. I only displayed the 4
rt-hashes and random to get some resolutions in the grafs. abcd and original
only kills them with long tails.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
