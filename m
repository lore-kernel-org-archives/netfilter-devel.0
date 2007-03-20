From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH RESEND]: conntrack: kill destroy() in nf_conntrack for
 diet
Date: Tue, 20 Mar 2007 15:06:56 +0900 (JST)
Message-ID: <200703200606.l2K66wTE019129@toshiba.co.jp>
References: <200703200057.l2K0vXrV009665@toshiba.co.jp>
	<45FF339B.5030202@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FF339B.5030202@trash.net>
	<45FF33FE.3000802@trash.net>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 20 Mar 2007 02:06:35 +0100

> Yasuyuki KOZAKAI wrote:
> > The destructor per conntrack is unnecessary, then this replaces it with
> > system wide destructor.
> > 
> > Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> > ---
> >  include/linux/skbuff.h                 |    7 +------
> >  net/ipv4/netfilter/ip_conntrack_core.c |    4 +++-
> >  net/netfilter/core.c                   |   19 ++++++++++++++++++-
> >  net/netfilter/nf_conntrack_core.c      |    4 +++-
> >  4 files changed, 25 insertions(+), 9 deletions(-)
> 
> 
> Thanks Yasuyuki, but this still doesn't apply to net-2.6.22
> since ip_conntrack got removed and there are also rejects in
> net/netfilter/core.c. Please rediff against Dave's net-2.6.22
> tree, thanks.

Sorry, I didn't take care that. I've deleted ip_conntrack part and replaced
NF_CONNTRACK_ENABLED with NF_CONNTRACK.

> > The destructor per conntrack is unnecessary, then this replaces it with
> > system wide destructor.
> > 
> > +extern void (*nf_ct_destroy)(struct nf_conntrack*);
> 
> BTW, please add whitespace between nf_conntrack and * (also in some
> other spots).

Thanks for pointing out this. I've also fixed them.

-- Yasuyuki Kozakai
