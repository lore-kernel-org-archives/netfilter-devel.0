From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Subject: Re: iptables.8 manpage not complete
Date: Mon, 3 Mar 2003 22:01:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303210134.GA493@eychenne.org>
References: <200302132039.58656.bdschuym@pandora.be> <20030214072944.GI14794@sunbeam.de.gnumonks.org> <20030218164739.GF445@eychenne.org> <20030303172520.GD11384@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Andras Kis-Szabo <kisza@sch.bme.hu>
Content-Disposition: inline
In-Reply-To: <20030303172520.GD11384@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 03, 2003 at 06:25:20PM +0100, Harald Welte wrote:
> On Tue, Feb 18, 2003 at 05:47:40PM +0100, Hervé Eychenne wrote:
> > > What also is on my TODO list for some time:  Put manpage sections for
> > > all recently-added-to-mainstream-kernel matches+targets.  I think the
> > > manpage hasn't been synced with the by-default available matches/targets
> > > for quite some time.

> > Oh, really?
> > It seems to me that my last patch added the missing matches and
> > targets, and that none has been added since (although I remember
> > having posted a request on netfilter-devel about the possible
> > inclusion of NETMAP in mainstream kernel and received no answer...).

> the 'helper' match present in 2.4.20 is at least one example which is
> not in the manpage yet. We already had this in 1.2.7a!

Yes, you're completely right.  I had checked before replying and had
noticed that only one was missing... indeed, it was ipt_helper.c...
But I didn't remember having ever heard about this match before (despite
my daily read of the devel mailing-list) and a very quick look to the
code made me consider it as... well, I don't know... a sort of 'dummy'
module. ;-) Maybe it's because of its very generic nature.
But I was clearly wrong. Never trust me again, please. :-)

So, now, I'll let Martin Josefsson document it, as he should have
right from the start. ;-)

And to win some kind of forgiveness, I'll help Andras Kis-Szabo by
letting him know that eui64 and length matches seem to be missing in
his ip6tables manpage.

Yesterday I was a loser, now I'm an informer... it's only getting
worser! ;-)

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
