From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 1 May 2003 09:04:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501070408.GD15143@oknodo.bof.de>
References: <20030501060522.GB15143@oknodo.bof.de> <20030501064732.ADD9C2C003@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, Martin Josefsson <gandalf@wlug.westbo.se>,
  Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
  Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
  Harald Welte <laforge@netfilter.org>,
  Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030501064732.ADD9C2C003@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 01, 2003 at 04:46:44PM +1000, Rusty Russell wrote:
> In message <20030501060522.GB15143@oknodo.bof.de> you write:
> > > 	struct nf_ct_info infos[IP_CT_NUMBER];
> > > 7 * 4 bytes.  We could eliminate this by adding an skb field to hold
> > > the state.
> > 
> > Given a guaranteed cacheline alignment of our 'struct ip_conntrack',
> > we could make the current pointer on the skbuffs a tagged pointer,
> > i.e. stuff our 3 info bits into the low 3 bits, without consuming
> > more room in the skbuffs.
> 
> That was my original implementation.  It was fairly ugly, but worse, I
> can imagine an arch where it would break.  None would at the moment,
> though, since kmalloc cacheline aligns

This boils down to the question whether SLAB_HWCACHE_ALIGN is a guarantee,
or a hint. I would have expected it to be a guarantee.

Argh. Are you worried about architectures with 8 byte or less cache lines?

Well, use another field in the skbuff, then. I would recycle nfcache,
but that's just because nobody ever explained to me what it would be
used for... :)

> (although we'd have to be a
> little careful to explicitly align a conntrack if we were to use a
> dummy one for a "notrack" target.

Unless you are after static initializability, what keeps us from
allocating such dummies in the same way as we allocate the rest?

best regards
  Patrick
