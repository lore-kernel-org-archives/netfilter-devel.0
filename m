From: "Pavel A. Nekrasov" <pnekras@gmail.com>
Subject: Re: [1/3] OSF: code beautification.
Date: Wed, 1 Jun 2005 02:11:32 +0200
Message-ID: <cede3071050531171179774bd3@mail.gmail.com>
References: <cede307105053115377afb8aac@mail.gmail.com>
	<20050601025731.7dac3234@zanzibar.2ka.mipt.ru>
	<20050601030415.5b667669@zanzibar.2ka.mipt.ru>
	<cede307105053117037c68cd3a@mail.gmail.com>
	<20050601041111.6c0d9075@zanzibar.2ka.mipt.ru>
Reply-To: "Pavel A. Nekrasov" <pnekras@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20050601041111.6c0d9075@zanzibar.2ka.mipt.ru>
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

On 6/1/05, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> On Wed, 1 Jun 2005 02:03:28 +0200
> "Pavel A. Nekrasov" <pnekras@gmail.com> wrote:
>=20
> > it seems that I forgot to reply to the mailling list...
> >
> > On 6/1/05, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > > On Wed, 1 Jun 2005 02:57:31 +0400
> > > Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > >
> > > > On Wed, 1 Jun 2005 00:37:05 +0200
> > > > "Pavel A. Nekrasov" <pnekras@gmail.com> wrote:
> > >
> > > ...
> > >
> > > > > BTW, fix a deadlock. match() can be called from both bh and proce=
ss context.
> > > >
> > > > Neither it suffers rcu lock in nf_hook_slow()?
> > >
> > > Ugh, it is read lock, but OSF match() method can be safely
> > > interrupted and reentered. BH are disabled when broadcasting over net=
link,
> > > reading finger table is guarded by read_lock, while modification
> > > can be done only in process context which uses write_lock_bh().
> >
> > not talking about netlink
> >
> > say a program does send() running on you machine, so some packets can
> > hit match() from process context. While holding read lock, match() is
> > interrupted to handle a bh. now say, a packet coming from bh context
> > hits match() and tries to gets read lock but it's already held by the
> > packet coming from process context. deadlock.
>=20
> It is read lock, which can be held by several users.
>=20
> Modification part, which lives in osf_proc_write(), uses write_lock_bh().

You are right, sorry for the noise.

kind regards,
Pavel
