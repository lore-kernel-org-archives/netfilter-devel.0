From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/3] OSF: code beautification.
Date: Wed, 1 Jun 2005 03:04:15 +0400
Message-ID: <20050601030415.5b667669@zanzibar.2ka.mipt.ru>
References: <cede307105053115377afb8aac@mail.gmail.com>
	<20050601025731.7dac3234@zanzibar.2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20050601025731.7dac3234@zanzibar.2ka.mipt.ru>
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

On Wed, 1 Jun 2005 02:57:31 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> On Wed, 1 Jun 2005 00:37:05 +0200
> "Pavel A. Nekrasov" <pnekras@gmail.com> wrote:

...

> > BTW, fix a deadlock. match() can be called from both bh and process context.
> 
> Neither it suffers rcu lock in nf_hook_slow()?

Ugh, it is read lock, but OSF match() method can be safely 
interrupted and reentered. BH are disabled when broadcasting over netlink,
reading finger table is guarded by read_lock, while modification
can be done only in process context which uses write_lock_bh().



	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
