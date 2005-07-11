From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Mon, 11 Jul 2005 09:47:24 +0200
Message-ID: <42D2240C.7000508@trash.net>
References: <Pine.LNX.4.58.0506061017330.16223@blackhole.kfki.hu>
	<42A83B96.4050302@eurodev.net> <42A83D72.1000106@eurodev.net>
	<Pine.LNX.4.58.0506091519580.7610@blackhole.kfki.hu>
	<42A9698F.30909@eurodev.net>
	<Pine.LNX.4.62.0506140433070.4718@kaber.coreworks.de>
	<42B6E918.5080603@ufomechanic.net> <42B6EADF.9040002@trash.net>
	<42B92AE2.3070004@ufomechanic.net> <42B99E88.8090604@trash.net>
	<20050711054107.GB14851@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Amin Azez <azez@ufomechanic.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050711054107.GB14851@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> I'm still not convinced that the ID is a good idea (or that it is needed
> in most cases).  However,
> 
> However, flow based accounting is basically finished, all that it lacks
> is nfnetlink/ctnetlink.  So I want to submit them pretty soon for
> mainline inclusion.
> 
> If you have decided onto which form of ID, please try to merge those patches
> (if any) soon and tell me when I can finalize ctnetlink/nfnetlink for
> submission.

Pablo decided to keep the 64bit ID, mainly there is no better
alternative for dumping. I don't know about the state, but AFAIK
he is currently reworking the ctnetlink message format to use
nested attributes instead of kernel structures. Unicast communication
also needs to be fixed, right now everything is only broadcasted and
userspace needs to filter. It should behave like all other netlink
families. That's all I know of that needs to be done, Pablo probably
has more.

Regards
Patrick
