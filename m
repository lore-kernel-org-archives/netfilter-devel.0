From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Thu, 20 May 2004 13:27:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405201307440.5246-100000@blackhole.kfki.hu>
References: <40AB3372.5030606@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40AB3372.5030606@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 19 May 2004, Pablo Neira wrote:

> >After thinking on it again, you're right, but I meant the
> >application protocol-helper locks. If there is a TCP data lock, then there
> >is no need for (TCP based) application protocol-helper locks.
>
> so you mean that we could use a single lock to protect both protocol and
> application helper private information, don't you? but in the case of
> the ftp helper the lock is protecting that global buffer, so your
> assumption would be wrong, wouldn't it?

I was wrong again. Those global buffers cause a lot of headache. :-(

> I know that connection tracking shouldn't drop packets (in theory), but
> I think that it would be ok if we can add set an option via sysctl with
> the default return value. I mean, if we saw an unclean packet, return
> NF_DROP, just let the administrator choose how aggresive his tcp
> tracking is.

It's funny: (practically) connection tracking itself does not drop
packets, it leaves the administrator to do the dirty job by setting up
explicit rules to drop INVALID packets (or implicitly, by letting trough
only valid packets) :-)

> More feedback, I restructured the skeleton of the tcp_packet function,
> attached a patch. I moved up the call to the tcp_in_window function, so
> at first we check if a packets complies with Guido's four boundaries.

Some tests are done before checking the window boundaries from good
reasons: checking special cases when packets are possibly (mostly!) out of
window. You cannot move them behind the boundary checkings.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
