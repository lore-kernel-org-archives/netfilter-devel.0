From: Brad Fisher <brad@info-link.net>
Subject: Re: Unique IDs for rules?
Date: Mon, 19 Jan 2004 12:04:35 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400C1C33.4A6A7DBC@info-link.net>
References: <Pine.LNX.4.44.0401191700100.11664-100000@filer.marasystems.com> <200401191738.26995.lists@edeca.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: david@edeca.net
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



David Cannings wrote:

> On Monday 19 January 2004 4:03 pm, Henrik Nordstrom wrote:
> > On Mon, 19 Jan 2004, David Cannings wrote:
> > > I want to do similar with other rules elsewhere in the chain but I
> > > can't be sure that they'll always be number 12, for example.  This
> > > makes grepping for them a little harder.  Would it be possible to
> > > have some sort of "comment" field for each rule so that some sort of
> > > token or unique ID for the rule could be inserted.  That way, it
> > > would simply be a case of "iptables -L -v | grep 'token'".
> >
> > There was a dummy match posted some time ago intended for this purpose,
> > or at least it was discussed. This adds very little extra overhead
> > provided the match is the last match used in the rule.
> >

FWIW: I did post a patch for a "comment" match a while back.  Splitting your
rules into separate chains is probably the way to go for your situation, but
I thought I'd mention it.  If you're still interested, I'd be glad to send
you a copy of the patch.

-Brad
