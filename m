From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: ctnetlink attributes [was: Re: [PATCH 1/2] updates for
 [nf|ct]netlink and event API]
Date: Mon, 11 Jul 2005 18:50:20 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507111849360.28440@yvahk01.tjqt.qr>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net>
	<42C2F2DF.7070301@eurodev.net> <42C2FC14.80609@trash.net>
	<42C33E33.7090908@eurodev.net>
	<42C34445.9020709@trash.net> <42C426B2.6030907@eurodev.net>
	<42D29EC0.9050707@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42D29EC0.9050707@ufomechanic.net>
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

>I'm interested in adding MAC addr attributes and CTA_TUPLE_MAC; not just
>because of my fixation with MAC addresses but also to use conntrack to
>record flow data for non IP-related protocols.

Can't this be done with ebtables?

On another note, how about bringing ebt and ipt closer together, maybe merge 
them?


Jan Engelhardt
-- 
