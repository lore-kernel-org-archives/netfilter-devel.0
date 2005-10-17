From: JC <bikkit@gmail.com>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 16:47:40 +0300
Message-ID: <a60102c30510170647w24a8928o@mail.gmail.com>
References: <4349D97A.9070708@snapgear.com>
	<200510160751.j9G7ph5t009316@toshiba.co.jp>
	<Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
	<Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
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

> For the exact same reason the match also hotdrops fragments which would
> overwrite the TCP header.
>
> In theory just the second criteria is a must (drop fragments which could
> override an earlier decision), but as it's there the first also makes
> sense to drop the first as we can not allow a fragment filling in the
> missing pieces.

Could someone please explain these two?
