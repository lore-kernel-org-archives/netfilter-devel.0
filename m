From: Patrick Schaaf <bof@bof.de>
Subject: Re: cttest-0.3 (conntrack hashing)
Date: Mon, 8 Jul 2002 19:40:44 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020708194044.U13116@oknodo.bof.de>
References: <20020708114504.CAF79473F@lists.samba.org> <15657.50484.842528.683308@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15657.50484.842528.683308@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Mon, Jul 08, 2002 at 10:00:36AM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Don,

> My friend the crypto expert told me that crc is easy to attack,
> and suggested ABCD(EF) because it has the right properties to
> resist attack.  It would take more work for me to demonstrate that
> crc is bad, and to better understand ABCD and possibly adjust it,
> but just on the basis of expert opinion, I think it's worth working
> on ABCD and giving up on crc and most of the others.

I have nothing against ABCD at this point, but I won't give up too
easily on the crc thing. There could be choice, maybe in the form
of an extra patch-o-matic section.

However, I agree that ABCD is generally the way to go, as far as the
main kernel is concerned. However, before we start pushing any change
into that general direction, I would love to A) see more pictures from
different sources, and B) see you or others continue to explore attack
schemes on the hashes.

To aid A) I'll probably respin cttest once or twice without diddling
with any hashes, just making the report and index generation more useful
for different viewpoints.

Regarding B) I personally don't have much drive to think about it.
I entered this endeavour in order to understand how to choose the
hash table size for some real setups where I start to use conntrack,
and I'm content with what we found out.

> I welcome input from any other crypto experts out there.

Strongly seconded. I'm not a crypto expert, and I won't start playing
one here on the mailing list. I'm an experimental opportunist, and
I stand by that :)

best regards
  Patrick
