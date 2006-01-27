From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PATCH] x_tables : Use SMP friendly (percpu) rwlock_t to
 protect x_tables
Date: Fri, 27 Jan 2006 09:53:00 -0800
Message-ID: <20060127095300.57fdd7e7@localhost.localdomain>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<43C247CF.2000608@cosmosbay.com> <43DA393F.6010801@cosmosbay.com>
	<20060127073721.1888808f@localhost.localdomain>
	<43DA403D.8090405@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <43DA403D.8090405@cosmosbay.com>
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

On Fri, 27 Jan 2006 16:46:05 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Stephen Hemminger a =C3=A9crit :
> > On Fri, 27 Jan 2006 16:16:15 +0100
> > Eric Dumazet <dada1@cosmosbay.com> wrote:
> >=20
> >> This patch helps scalability of x_tables on SMP, especially NUMA mac=
hines.
> >>
> >> Instead of using a single rwlock_t to protect x_tables, use an array=
 of=20
> >> rwlock_t, one for each possible cpu in the machine.

It makes no sense to have a per-cpu lock. Why not just use per-cpu counte=
rs
and bh_disable()?
