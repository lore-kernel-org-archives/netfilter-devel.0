From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Mon, 11 Jul 2005 11:50:02 +0200
Message-ID: <42D240CA.2030604@eurodev.net>
References: <Pine.LNX.4.58.0506061017330.16223@blackhole.kfki.hu>
	<42A83B96.4050302@eurodev.net> <42A83D72.1000106@eurodev.net>
	<Pine.LNX.4.58.0506091519580.7610@blackhole.kfki.hu>
	<42A9698F.30909@eurodev.net>
	<Pine.LNX.4.62.0506140433070.4718@kaber.coreworks.de>
	<42B6E918.5080603@ufomechanic.net> <42B6EADF.9040002@trash.net>
	<42B92AE2.3070004@ufomechanic.net> <42B99E88.8090604@trash.net>
	<20050711054107.GB14851@sunbeam.de.gnumonks.org>
	<42D2240C.7000508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42D2240C.7000508@trash.net>
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

Hi!

Patrick McHardy wrote:
> Harald Welte wrote:
> 
>>I'm still not convinced that the ID is a good idea (or that it is needed
>>in most cases).
> 
> Pablo decided to keep the 64bit ID, mainly there is no better
> alternative for dumping.

Yes, we don't know any reliable way to know from which point the dumping 
stopped once the skbuff gets full.

> he is currently reworking the ctnetlink message format to use
> nested attributes instead of kernel structures.

Indeed. The new message format has required tons of changes but it's the 
way to go.

> Unicast communication
> also needs to be fixed, right now everything is only broadcasted and
> userspace needs to filter. It should behave like all other netlink
> families. That's all I know of that needs to be done, Pablo probably
> has more.

I expect to send the patches tomorrow, so we could discuss on the code.

--
Pablo
