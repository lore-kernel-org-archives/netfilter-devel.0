From: "Vladimir B. Savkin" <master@sectorb.msk.ru>
Subject: Re: ULOG and bandwidth monitor
Date: Thu, 30 Jun 2005 20:08:40 +0400
Message-ID: <20050630160840.GA21269@tentacle.sectorb.msk.ru>
References: <421134A9.8010204@utilitran.com>
	<7174b1e405021416134d63fd4e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: netfilter-devel@lists.netfilter.org,
	Michael Gale <michael.gale@utilitran.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ben La Monica <ben.lamonica@gmail.com>
Content-Disposition: inline
In-Reply-To: <7174b1e405021416134d63fd4e@mail.gmail.com>
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

On Mon, Feb 14, 2005 at 05:13:12PM -0700, Ben La Monica wrote:
> Hello,
> 
> On Mon, 14 Feb 2005 16:30:49 -0700, Michael Gale
> <michael.gale@utilitran.com> wrote:
> > Hello,
> > 
> >         I have recently downloaded ulogd-1.02 and gone through the
> > documentation. With the mysql plugin, it would seem very easy to create
> > a web base front end to produce total stats.
> 
> ulog has problems when there is a lot of traffic flowing, and it drops
> packets. This is because that it passes every packet into userspace
> and it usually runs out of buffer space. I think there are plans to
> actually integrate a conntrack-acct module into ulogd (I can't find
> the post right now, so I can't provide a reference).
> 

With --ulog-cprange and --ulog-threshold it's not nearly that bad.
I'm doing accounting with more than 50kpps peak rate, with no drops.
It's not a hard limit, we just have that much of a traffic here,
with artificial tests it can do more.

~
:wq
                                        With best regards, 
                                           Vladimir Savkin. 
