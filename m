From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 20:31:17 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702203117.G7684@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com> <20020702183242.E7684@oknodo.bof.de> <20020702183547.F7684@oknodo.bof.de> <15649.59247.55523.824241@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15649.59247.55523.824241@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Tue, Jul 02, 2002 at 10:48:31AM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>  > > Everybody, have a look at http://bei.bof.de/ex1/. There's a bunch of
>  > > pictures, which may become legible together with reading my recent
>  > > mails on this thread.
> 
> The only thing that looks really suspicious to me is the lump in
> original for large table sizes.

Note that due to the y-axis log-10 scale, the tail is more visible; the far
out tail does not consist of many buckets. I agree with your correlation
observation for the original hash. portscans, again?

With an overcrowded bucket table (the ~7000 entry cases), there is almost
no difference between the original hash, and the alternatives. They are
all equally bad (because of the overcrowding). With a wide bucket table
(130000 and 260000 buckets for 65000 entries), the general badness of
the original hash clearly shows in the shape of the curve.

> Have you tried the ABCD suggestion I posted?
> Just as a quick test:
> static u32 hash_conntrack(struct ct_key *key)
> {
>  return
>    0x47441DFB * key->sip
>    + 0x57655A7D * key->dip
>    + 0x1C7F1D2D * key->sport
>    + 0xDF91D738 * key->dport
>    + key->proto;

I now added this to cttest (new hash called 'abcd'), and updated the
pictures on the website accordingly. Looks good for odd table sizes,
and detoriates badly for even table sizes - like you said.

best regards
  Patrick
