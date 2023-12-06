Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F0AD51;
	Wed,  6 Dec 2023 08:42:48 -0800 (PST)
Received: from [78.30.43.141] (port=54118 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAuyx-003xzA-MK; Wed, 06 Dec 2023 17:42:46 +0100
Date: Wed, 6 Dec 2023 17:42:42 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Jann Horn <jannh@google.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	coreteam@netfilter.org, Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Network Development <netdev@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Is xt_owner's owner_mt() racy with sock_orphan()? [worse with
 new TYPESAFE_BY_RCU file lifetime?]
Message-ID: <ZXCkgoVQCn6bMoKT@calendula>
References: <CAG48ez0TfTAkaRWFCTb44x=TWP_sDZVx-5U2hvfQSFOhghNrCA@mail.gmail.com>
 <CAG48ez1hXk_cffp3dy-bYMcoyCCj-EySYR5SzYrNiRHGD=hOUg@mail.gmail.com>
 <ZW+Yv6TR+EMBp03f@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZW+Yv6TR+EMBp03f@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Dec 05, 2023 at 10:40:15PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Tue, Dec 05, 2023 at 06:08:29PM +0100, Jann Horn wrote:
> > On Tue, Dec 5, 2023 at 5:40 PM Jann Horn <jannh@google.com> wrote:
> > >
> > > Hi!
> > >
> > > I think this code is racy, but testing that seems like a pain...
> > >
> > > owner_mt() in xt_owner runs in context of a NF_INET_LOCAL_OUT or
> > > NF_INET_POST_ROUTING hook. It first checks that sk->sk_socket is
> > > non-NULL, then checks that sk->sk_socket->file is non-NULL, then
> > > accesses the ->f_cred of that file.
> > >
> > > I don't see anything that protects this against a concurrent
> > > sock_orphan(), which NULLs out the sk->sk_socket pointer, if we're in
> > 
> > Ah, and all the other users of ->sk_socket in net/netfilter/ do it
> > under the sk_callback_lock... so I guess the fix would be to add the
> > same in owner_mt?
> 
> Sounds reasonable, although I wonder how likely a socket is to
> orphan while netfilter is processing a packet it just sent.
> 
> How about the attached patch? Not sure what hash to put into a Fixes:
> tag given this is a day 1 bug and ipt_owner/ip6t_owner predate git.
> 
> Thanks, Phil

> From 3e28490e43b04d49e6e7f145a70fff7dd42c8cc5 Mon Sep 17 00:00:00 2001
> From: Phil Sutter <phil@nwl.cc>
> Date: Tue, 5 Dec 2023 21:58:12 +0100
> Subject: [nf PATCH] netfilter: xt_owner: Fix for unsafe access of sk->sk_socket
> 
> A concurrently running sock_orphan() may NULL the sk_socket pointer in
> between check and deref. Follow other users (like nft_meta.c for
> instance) and acquire sk_callback_lock before dereferencing sk_socket.

For the record, I have placed this patch in nf.git

Thanks.
