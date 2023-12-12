Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="X0/wHSjo"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3018AD
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 08:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/jO/S38Qoh49xOQC6mBcBDn6L+HsmYY3hgY6l1YflMo=; b=X0/wHSjogeUUxNejkW+XCFg2yZ
	HTrcKPzYJkRjnQleQg59wUCt70ZT5cmKjdnft1vq/aKy/XDlZPkpe0c8Oam1hiQCdhvkET4RO+Du7
	GW9/nchUCewDdGoGabQC0npSBIIaPrjnxp+XT9Dw2LWDWAmIeHoGb0TyKaAzq77mgJ8jlxaHE7OKv
	dT6zvshKOV+E3Ec5Wqr1RMFSyj8pE1CZIAx3YUP3Ti1QqgcOnl3yXgSVmhiEBVi+PB12X3BeBjmAt
	/ccoCVlnOoyE6SqLTD49lrV7QIvdL5OEwyEl11iL34c4O4892SX00dc1e9W9pH1ucoITILnzm27gL
	q/mVie1Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rD5XD-0000RR-4q; Tue, 12 Dec 2023 17:23:03 +0100
Date: Tue, 12 Dec 2023 17:23:03 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXhbYs4vQMWX/q+d@calendula>

Hi Pablo,

On Tue, Dec 12, 2023 at 02:08:50PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 08, 2023 at 02:01:03PM +0100, Phil Sutter wrote:
> > A process may take ownership of an existing table not owned yet or free
> > a table it owns already.
> > 
> > A practical use-case is Firewalld's CleanupOnExit=no option: If it
> > starts creating its own tables with owner flag, dropping that flag upon
> > program exit is the easiest solution to make the ruleset survive.
> 
> I can think of a package update as use-case for this feature?
> Meanwhile, package is being updated the ruleset remains in place.

Usually (with the distros I am familiar with at least), the daemon just
keeps running while its package is updated. The run-time change then
happens after reboot (or explicit restart). RHEL/Fedora support
'%systemd_postun_with_restart' macro to request restart of the service
upon package update, but it runs after the actual update process, so
the time-window in between old service and new one is short (in theory).

Unless I'm mistaken, firewalld service restart is internally just "stop
&& start", not a distinct action. Temporarily changing the config to
make firewalld not clean up in that case to reduce/eliminate the
downtime is a nice idea, though. Eric, WDYT?

> Is there any more scenario are you having in mind for this?

No, it was basically just that. When discussing with Eric whether using
'flags owner' is good (to avoid clashes with other nf_tables users) or
bad (ruleset is lost upon (unexpected) program exit), I thought of a
switchable owner flag as a nice alternative to dropping and recreating
the owned tables without owner flag before exiting.

BTW: A known limitation is that crashing firewalld will leave the system
without ruleset. I could think of a second flag, "persist" or so, which
makes nft_rcv_nl_event() just drop the owner flag from the table instead
of deleting it. What do you think?

> > Mostly for consistency, this patch enables taking ownership of an
> > existing table, too. This would allow firewalld to retake the ruleset it
> > has previously left.
> 
> Isn't it better to start from scratch? Basically, flush previous the
> table that you know it was there and reload the ruleset.

Yes, this is what firewalld currently does. Looking at the package
update scenario you mentioned, a starting daemon can't really expect the
existing table to be in shape and should better just recreate it from
scratch.

> Maybe also goal in this case is to keep counters (and other stateful
> objects) around?

Yes, this is a nice side-effect, too.

In my opinion, support for owner flag update (both add and remove) is
simple enough to maintain in code and relatively straightforward
regarding security (if owned tables may only be changed by the owner) so
there is not much reason to not provide it for whoever may find use in
it.

For firewalld on the other hand, I think introducing this "persist" flag
would be a full replacement to the proposed owner flag update.

Cheers, Phil
