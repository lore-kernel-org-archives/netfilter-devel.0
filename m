From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack_hash() problem
Date: Thu, 5 Sep 2002 19:55:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020905195547.A21899@oknodo.bof.de>
References: <1031210342.9785.159.camel@biker.pdb.fsc.net> <20020905115208.4D0A02C064@lists.samba.org> <20020905135440.A10805@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rusty Russell <rusty@rustcorp.com.au>,
  Martin Wilck <Martin.Wilck@Fujitsu-Siemens.com>,
  Harald Welte <laforge@gnumonks.org>,
  Netfilter Mailing List <netfilter-devel@lists.netfilter.org>,
  Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
  Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andi Kleen <ak@suse.de>
Content-Disposition: inline
In-Reply-To: <20020905135440.A10805@wotan.suse.de>; from ak@suse.de on Thu, Sep 05, 2002 at 01:54:40PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 05, 2002 at 01:54:40PM +0200, Andi Kleen wrote:
> > I'll feed this through 2.5, once it's had some more testing (hint
> > hint!).  Then Harald will make a call on 2.4.
> 
> I would propose to include Martin's simple patch as a short term fix 
> for 2.4 until Rusty's full work can get in. It fixes an bad performance
> problems in some not too uncommon cases.

As a short time fix, seeing that it's mostly even hash bucket counts
that give a problem, I would still propose just making the bucket count
the nearest odd number, i.e. basically htable_size |= 1 in the startup code.

I don't expect any user to notice such a miniscule change.

best regards
  Patrick
