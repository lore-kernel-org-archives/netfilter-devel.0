From: JC <bikkit@gmail.com>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 16:57:00 +0300
Message-ID: <a60102c30510170657t7ecdaa9bk@mail.gmail.com>
References: <4349D97A.9070708@snapgear.com>
	<200510160751.j9G7ph5t009316@toshiba.co.jp>
	<Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
	<Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
	<a60102c30510170647w24a8928o@mail.gmail.com>
	<Pine.LNX.4.61.0510171549520.21372@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510171549520.21372@filer.marasystems.com>
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

On 17/10/05, Henrik Nordstrom <hno@marasystems.com> wrote:
> On Mon, 17 Oct 2005, JC wrote:
>
> >> For the exact same reason the match also hotdrops fragments which woul=
d
> >> overwrite the TCP header.
> >>
> >> In theory just the second criteria is a must (drop fragments which cou=
ld
> >> override an earlier decision), but as it's there the first also makes
> >> sense to drop the first as we can not allow a fragment filling in the
> >> missing pieces.
> >
> > Could someone please explain these two?
>
> An IP fragment with offset 1 can overwrite parts of the TCP header, and i=
f
> this check is not there an attacker could bypass port matches in iptables
> by sending the packet in two fragments where the first fragment (which is
> used by the tcp match) has ports which is allowed by the ruleset and late=
r
> the second fragment (which is ignored by the tcp match) overwrites the
> port numbers with ports which would not be allowed by the ruleset.

and that doesnt get picked up by conntrack as a different connection??
