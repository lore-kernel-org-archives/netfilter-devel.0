From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Sat, 29 Jun 2002 19:33:53 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020629193353.Q4136@oknodo.bof.de>
References: <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de> <15644.53466.193145.914415@isis.cs3-inc.com> <20020628232819.H4136@oknodo.bof.de> <15644.58258.483223.56527@isis.cs3-inc.com> <20020629110332.I4136@oknodo.bof.de> <15645.58583.30187.70748@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15645.58583.30187.70748@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Sat, Jun 29, 2002 at 09:48:23AM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> BTW it turns out this leads to a good demonstration of my point about
> making the modulus relatively prime to the size of the data.

Missed that point on first reading. I totally agree with you on this
point. We already pay for the modulus in the current code, so we may
as well take advantage of it.

In an unrelated piece of software (phone call correlation), I use a
precomputed table of primes that are all just a bit smaller than a
power of two, and for any bucket count desired by the user, I really
use the next largest almost-power-of-two prime from that table.

best regards
  Patrick

static unsigned sizes[] = {
        3,	/* 2^2-1 */
        7,      /* 2^3-1 */
        13,
        31,     /* 2^5-1 */
        61,
        127,    /* 2^7-1 */
        251,
        509,
        1021,
        2039,
        4093,
        8191,   /* 2^13-1 */
        16381,
        32749,
        65521,
        131071, /* 2^17-1 */
        262139,
        524287, /* 2^19-1 */
        1048571,
        2097157,
        4194301,
        8388581,
};
