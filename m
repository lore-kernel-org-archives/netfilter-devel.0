From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: Backported conntrack-acct/connbytes to 2.4 tree
Date: Fri, 01 Apr 2005 12:02:06 +0200
Message-ID: <1112349726.20323.23.camel@develbox.linuxbox.cz>
References: <20041116220502.GA2677@fouk.org> <20041121163442.GA99261@fouk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotr Chytla <pch@fouk.org>
In-Reply-To: <20041121163442.GA99261@fouk.org>
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

Hi all, I'd like to ask, what is state of this patch? Is it going to
main tree? I'm not able to build iptables-1.3.1 without it, but it
breaks (at least) conntrack_{gre,mppe}
Can I do somethink to help?
Thanks!

Piotr Chytla p=ED=B9e v Ne 21. 11. 2004 v 17:34 +0100:
> On Tue, Nov 16, 2004 at 11:05:02PM +0100, Piotr Chytla wrote:
> > 1) Backported conntrack-acct=20
> > 2) Backported connbytes with per-connection accounting support , also=
=20
> >    shared library for iptables is attached .=20
> >    Shared library for iptables works with connbytes from 2.6 tree.
> >=20
> I've removed myself from pom-ng info file(fixed patches for pomng in at=
tachment).=20
> I was stupid, sorry for inconvenience.
>=20
>=20
> /pch
