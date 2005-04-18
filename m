From: Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Mon, 18 Apr 2005 19:13:43 +0800
Message-ID: <20050418185959.037A.LARK@linux.net.cn>
References: <425BE280.3040904@eurodev.net> <42639065.70809@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42639065.70809@ufomechanic.net>
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

Hi Amin Azez,

Pablo gave a patch the other day that patches pom-ng to get ctevent-api/.
I use this patch along with new nfnetlink/ and ctnetlink/, and it works
fine. Of course, you need to rename or symbol link ctevent-api/ to
conntrack-event-api/, because Harald Welte chooses it as name.

Execpt the ctevent-api, I think other parts have been put into new
nfnetlink/ and ctnetlink/.

Harald Welte also merged ctnetlink-conntrack_acct.patch, which seems to
do per stream packets/bytes counting stuff. (I just take a look at it,
so I may be wrong).


On Mon, 18 Apr 2005 11:48:05 +0100, Amin Azez <azez@ufomechanic.net> wrote:

> Pablo Neira wrote:
> > Pablo Neira wrote:
> > 
> >> Harald Welte wrote:
> >>
> >>> do you mind creating a patch against svn so we can put it into
> >>> nfnetlink-ctnetlink/linux-2.6.11 ?
> >>
> >>
> >>
> >> Attached two patches against pom-ng:
> >>
> >> o ctevent-api: conntrack event API
> >> o nfnetlink-ctnetlink: nfnetlink + conntrack netlink interface
> > 
> > oops, sorry, forgot the patches...
> 
> Can I just check that nfnetlink-ctnetlink-0.13 and 
> nfnetlink-ctnetlink-0.50 in pom-ng-20050404 have been replaced by
> pom-ng/nfnetlink and pom-ng/ctnetlink in pom-ng-20050417
> 
> Pablo, do they also fully supercede your patches 1-5 at 
> http://people.netfilter.org/~pablo/patches/nfnetlink-conntrack-0.50-2.6.11/ 
> and that there is nothing new in those?
> 
> If so, do you want me to create a pom-ng for the netlink packet counting 
> stuff I sent last week, our will you spit that out at an appropriate 
> point combined with your pattern defined dumping?
> 
> Sam



-- 
  lark
