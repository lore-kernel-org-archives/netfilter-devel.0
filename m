From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] remove exessive timer updates (3/4)
Date: 12 Jun 2002 11:10:45 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023873045.19812.95.camel@tux>
References: <1023365846.845.26.camel@tux>
	<20020611095922.G11177@sunbeam.de.gnumonks.org>
	<200206120021.15472@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
	Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200206120021.15472@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2002-06-12 at 00:21, Henrik Nordstrom wrote:
> On Tuesday 11 June 2002 09:59, Harald Welte wrote:
> > On Thu, Jun 06, 2002 at 02:24:04PM +0200, Martin Josefsson wrote:
> > > This patch adds a check to ip_ct_refresh() so it doesn't update
> > > the timer of a connection unless it's been >HZ ticks since the
> > > last update. both del_timer() and add_timer() disables interrupts
> > > while removing/inserting the timer, no reason to do this for each
> > > packet.
> >
> > ok.  I'm postponing this stuff for after 2.4.20 time, since for
> > 2.4.19 we already have enough netfilter [and core networking
> > changes], and for 2.4.20 there will be the newnat merge.
> 
> Haven't looked at the patch, but one thing to look out for is to make 
> sure timer transitions is not lost.
> 
> Unlike atime updates, conntrack timers vary in length depending on the 
> state. It would not be fun if a TIME_WAIT state got a timeout of 
> ESTABLISHED only because the transition was too quick to be noticed 
> by the timer update filter..

Yes I thought about it yesterday and I'll send Harald a new patch which
will allow us to force an update.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
