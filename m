From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/3] OSF: code beautification.
Date: Wed, 1 Jun 2005 04:11:11 +0400
Message-ID: <20050601041111.6c0d9075@zanzibar.2ka.mipt.ru>
References: <cede307105053115377afb8aac@mail.gmail.com>
	<20050601025731.7dac3234@zanzibar.2ka.mipt.ru>
	<20050601030415.5b667669@zanzibar.2ka.mipt.ru>
	<cede307105053117037c68cd3a@mail.gmail.com>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pavel A. Nekrasov" <pnekras@gmail.com>
In-Reply-To: <cede307105053117037c68cd3a@mail.gmail.com>
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

On Wed, 1 Jun 2005 02:03:28 +0200
"Pavel A. Nekrasov" <pnekras@gmail.com> wrote:

> it seems that I forgot to reply to the mailling list...
> 
> On 6/1/05, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > On Wed, 1 Jun 2005 02:57:31 +0400
> > Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > 
> > > On Wed, 1 Jun 2005 00:37:05 +0200
> > > "Pavel A. Nekrasov" <pnekras@gmail.com> wrote:
> > 
> > ...
> > 
> > > > BTW, fix a deadlock. match() can be called from both bh and process context.
> > >
> > > Neither it suffers rcu lock in nf_hook_slow()?
> > 
> > Ugh, it is read lock, but OSF match() method can be safely
> > interrupted and reentered. BH are disabled when broadcasting over netlink,
> > reading finger table is guarded by read_lock, while modification
> > can be done only in process context which uses write_lock_bh().
> 
> not talking about netlink
> 
> say a program does send() running on you machine, so some packets can
> hit match() from process context. While holding read lock, match() is
> interrupted to handle a bh. now say, a packet coming from bh context
> hits match() and tries to gets read lock but it's already held by the
> packet coming from process context. deadlock.

It is read lock, which can be held by several users.

Modification part, which lives in osf_proc_write(), uses write_lock_bh().

> kind regards,
> Pavel


	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
