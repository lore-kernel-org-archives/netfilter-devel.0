From: Robert Iakobashvili <coroberti@gmail.com>
Subject: Re: Netlink send from the interrupt context
Date: Wed, 23 Nov 2005 09:28:37 +0200
Message-ID: <7e63f56c0511222328w6368f7bcl7877fe3aa62c2807@mail.gmail.com>
References: <7e63f56c0511210034h49917721k74ddb251b9bb1815@mail.gmail.com>
	<00a901c5ee79$389e5040$6704a8c0@skqianyi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yu Zhiguo <yuzg@nanjing-fnst.com>
In-Reply-To: <00a901c5ee79$389e5040$6704a8c0@skqianyi>
Content-Disposition: inline
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

Dear Yu Zhiguo,

Have you called for send_broadcast from a driver HW interrupt?

Sincerely,
Robert

On 11/21/05, Yu Zhiguo <yuzg@nanjing-fnst.com> wrote:
> Hello,
>
> Don't worry, netlink socket can be used in interrupt context very well.
>
> regards,
> ----- Original Message -----
>
> >A bit offline question.
> >
> > Are there netlink socket netlink_unicast () and netlink_broadcast ()
> > interrupt safe?
> >
> > If not, where is the problem and the direction to make them safe?
> >
> > If it is not easy, what could be a workaroud?
> >
> > Thank you in advance.
> >
> >
> > Sincerely,
> > ----------------------------------------------------------------
> > Robert Iakobashvili  - NAVIGARE NECESSE EST
> > coroberti at gmail dot com
> > ---------------------------------------------------------------
> >


--
Sincerely,
----------------------------------------------------------------
Robert Iakobashvili  - NAVIGARE NECESSE EST
coroberti at gmail dot com
---------------------------------------------------------------
