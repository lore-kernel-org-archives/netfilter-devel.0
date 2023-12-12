Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FvYDJS4M"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C906CAD
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 14:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702421247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EIpACyfMr2Ovccl2lqXN8UX85Kghu0/KKci32Ppy0V4=;
	b=FvYDJS4M5AVCBKNj9fU229CiIe0ptzwxo5pQd1+ujyrRp+ZCC4Qw4AnhGYX0tILWCEwu2W
	TQ4qKPsSg8KcMw50PObJFsMwIAr95cFdTbqEAaBpAqy424vweNctfyJySZZAqJyekzKDL+
	uCMS4AnMX7vNTEuHCtKpDbCrulhsuOk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-uDyJjitoNhqYIjeS_1u3jw-1; Tue,
 12 Dec 2023 17:47:25 -0500
X-MC-Unique: uDyJjitoNhqYIjeS_1u3jw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C99003816B4E;
	Tue, 12 Dec 2023 22:47:24 +0000 (UTC)
Received: from localhost (unknown [10.22.10.1])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7CCC42026D66;
	Tue, 12 Dec 2023 22:47:24 +0000 (UTC)
Date: Tue, 12 Dec 2023 17:47:22 -0500
From: Eric Garver <eric@garver.life>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <ZXji-iRbse7yiGte@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
 <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, Dec 12, 2023 at 05:23:03PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Dec 12, 2023 at 02:08:50PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Dec 08, 2023 at 02:01:03PM +0100, Phil Sutter wrote:
> > > A process may take ownership of an existing table not owned yet or free
> > > a table it owns already.
> > > 
> > > A practical use-case is Firewalld's CleanupOnExit=no option: If it
> > > starts creating its own tables with owner flag, dropping that flag upon
> > > program exit is the easiest solution to make the ruleset survive.
> > 
> > I can think of a package update as use-case for this feature?
> > Meanwhile, package is being updated the ruleset remains in place.
> 
> Usually (with the distros I am familiar with at least), the daemon just
> keeps running while its package is updated. The run-time change then
> happens after reboot (or explicit restart). RHEL/Fedora support
> '%systemd_postun_with_restart' macro to request restart of the service
> upon package update, but it runs after the actual update process, so
> the time-window in between old service and new one is short (in theory).
> 
> Unless I'm mistaken, firewalld service restart is internally just "stop
> && start", not a distinct action.

Yes. This is typical. "systemctl restart firewalld". This is what's done
on a package update.

> Temporarily changing the config to
> make firewalld not clean up in that case to reduce/eliminate the
> downtime is a nice idea, though. Eric, WDYT?

It would be nice to eliminate the downtime, yes.

The original intention of CleanupOnExit is to allow shutting down the
daemon while retaining the runtime nftables rules, i.e. zero cost
abstraction.

> > Is there any more scenario are you having in mind for this?
> 
> No, it was basically just that. When discussing with Eric whether using
> 'flags owner' is good (to avoid clashes with other nf_tables users) or
> bad (ruleset is lost upon (unexpected) program exit), I thought of a
> switchable owner flag as a nice alternative to dropping and recreating
> the owned tables without owner flag before exiting.

It would be nice, but not a show stopper.

> BTW: A known limitation is that crashing firewalld will leave the system
> without ruleset. I could think of a second flag, "persist" or so, which
> makes nft_rcv_nl_event() just drop the owner flag from the table instead
> of deleting it. What do you think?

I'm not concerned with optimizing for the crash case. We wouldn't be
able to make any assumptions about the state of nftables. The only safe
option is to flush and reload all the rules.

> > > Mostly for consistency, this patch enables taking ownership of an
> > > existing table, too. This would allow firewalld to retake the ruleset it
> > > has previously left.
> > 
> > Isn't it better to start from scratch? Basically, flush previous the
> > table that you know it was there and reload the ruleset.
> 
> Yes, this is what firewalld currently does. Looking at the package
> update scenario you mentioned, a starting daemon can't really expect the
> existing table to be in shape and should better just recreate it from
> scratch.

Indeed. Always flush at start. Same as after a crash, IMO.

> > Maybe also goal in this case is to keep counters (and other stateful
> > objects) around?
> 
> Yes, this is a nice side-effect, too.
> 
> In my opinion, support for owner flag update (both add and remove) is
> simple enough to maintain in code and relatively straightforward
> regarding security (if owned tables may only be changed by the owner) so
> there is not much reason to not provide it for whoever may find use in
> it.
> 
> For firewalld on the other hand, I think introducing this "persist" flag
> would be a full replacement to the proposed owner flag update.

I don't think we need a persist flag. If we want it to persist then
we'll just avoid setting the owner flag entirely.

