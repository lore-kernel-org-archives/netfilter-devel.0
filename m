From: JC <bikkit@gmail.com>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 17:03:44 +0300
Message-ID: <a60102c30510170703o39080134l@mail.gmail.com>
References: <4349D97A.9070708@snapgear.com>
	<200510160751.j9G7ph5t009316@toshiba.co.jp>
	<Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
	<Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
	<a60102c30510170647w24a8928o@mail.gmail.com>
	<Pine.LNX.4.61.0510171549520.21372@filer.marasystems.com>
	<a60102c30510170657t7ecdaa9bk@mail.gmail.com>
	<Pine.LNX.4.61.0510171558500.21372@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510171558500.21372@filer.marasystems.com>
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

> > and that doesnt get picked up by conntrack as a different connection??
>
> conntrack always refragments packets completely, making this largely a
> non-issue.
>
> the hotdrop is only when you use the tcp match without conntrack.

ok, got you. thanx for the explanation

JC
