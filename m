Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C18445BE2;
	Wed,  6 Dec 2023 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hcd8ItYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEA1C433C8;
	Wed,  6 Dec 2023 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701881431;
	bh=uOaUV/x5ijC7KJbVV3edKrjS8niRkEle6TaN8naPFz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hcd8ItYOoFEC/bFxRgyDSQg4eDgEi7NjBZZ1K/bZpZTpJ4dMCQ2Bavo/o4asTygME
	 Lxfuz8yvWNOS5re1U2V/UJzmZWRccnkWGE8IjSaq+2/VdNt1LHJX2E9SQEisfDhIfs
	 OtQuwh9qJk35wCLoovp6UQOpKs3aDg+AgBlHFoJTRCsnzH044NSgig0OOjQGe8Y+vG
	 spsC7mWYl1gPMw3pRUkKTwAE+C8J4/oe7iDKYDrYpXIBTM7wUFWbPzLYj1N9iBK6UR
	 J3kSMjADE2RKl1gufKnQATapZUN22fUEKf6jWHVOoRQb07o9twouWzUrV5mtQhE/Fd
	 hgpQyfspEzoRQ==
Date: Wed, 6 Dec 2023 17:50:25 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	coreteam@netfilter.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Network Development <netdev@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Is xt_owner's owner_mt() racy with sock_orphan()? [worse with
 new TYPESAFE_BY_RCU file lifetime?]
Message-ID: <20231206-gutmenschen-freie-5da710dfa4ab@brauner>
References: <CAG48ez0TfTAkaRWFCTb44x=TWP_sDZVx-5U2hvfQSFOhghNrCA@mail.gmail.com>
 <CAG48ez1hXk_cffp3dy-bYMcoyCCj-EySYR5SzYrNiRHGD=hOUg@mail.gmail.com>
 <20231206-refinanzieren-werkhalle-22db5334f256@brauner>
 <CAG48ez07dJ_=KUzRONVhMmr2koW9PwiZ5KxMHfx8ERPA=j4cUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez07dJ_=KUzRONVhMmr2koW9PwiZ5KxMHfx8ERPA=j4cUw@mail.gmail.com>

On Wed, Dec 06, 2023 at 03:38:50PM +0100, Jann Horn wrote:
> On Wed, Dec 6, 2023 at 2:58 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Tue, Dec 05, 2023 at 06:08:29PM +0100, Jann Horn wrote:
> > > On Tue, Dec 5, 2023 at 5:40 PM Jann Horn <jannh@google.com> wrote:
> > > >
> > > > Hi!
> > > >
> > > > I think this code is racy, but testing that seems like a pain...
> > > >
> > > > owner_mt() in xt_owner runs in context of a NF_INET_LOCAL_OUT or
> > > > NF_INET_POST_ROUTING hook. It first checks that sk->sk_socket is
> > > > non-NULL, then checks that sk->sk_socket->file is non-NULL, then
> > > > accesses the ->f_cred of that file.
> > > >
> > > > I don't see anything that protects this against a concurrent
> > > > sock_orphan(), which NULLs out the sk->sk_socket pointer, if we're in
> > >
> > > Ah, and all the other users of ->sk_socket in net/netfilter/ do it
> > > under the sk_callback_lock... so I guess the fix would be to add the
> > > same in owner_mt?
> >
> > In your other mail you wrote:
> >
> > > I also think we have no guarantee here that the socket's ->file won't
> > > go away due to a concurrent __sock_release(), which could cause us to
> > > continue reading file credentials out of a file whose refcount has
> > > already dropped to zero?
> >
> > Is this an independent worry or can the concurrent __sock_release()
> > issue only happen due to a sock_orphan() having happened first? I think
> > that it requires a sock_orphan() having happend, presumably because the
> > socket gets marked SOCK_DEAD and can thus be released via
> > __sock_release() asynchronously?
> >
> > If so then taking sk_callback_lock() in owner_mt() should fix this.
> > (Otherwise we might need an additional get_active_file() on
> > sk->sk_socker->file in owner_mt() in addition to the other fix.)
> 
> My understanding is that it could only happen due to a sock_orphan()
> having happened first, and so just sk_callback_lock() should probably
> be a sufficient fix. (I'm not an expert on net subsystem locking rules
> though.)

Ok, so as I suspected. That's good.
