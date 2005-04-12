From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Tue, 12 Apr 2005 16:50:15 +0200
Message-ID: <425BE027.1060301@eurodev.net>
References: <424747D5.8060500@eurodev.net> <42502B1B.7090309@trash.net>
	<42540839.8020405@ufomechanic.net> <4254265F.6080607@eurodev.net>
	<20050410204542.GT9155@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050410204542.GT9155@sunbeam.de.gnumonks.org>
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
> do you mind creating a patch against svn so we can put it into
> nfnetlink-ctnetlink/linux-2.6.11 ?

Attached two patches against pom-ng:

o ctevent-api: conntrack event API
o nfnetlink-ctnetlink: nfnetlink + conntrack netlink interface

--
Pablo
