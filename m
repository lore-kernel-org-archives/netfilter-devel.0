From: Jean-Francois Dive <jef@linuxbe.org>
Subject: Re: active failover ..
Date: Fri, 18 Oct 2002 17:17:00 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021018071700.GD2519@gnoll.homeip.net>
References: <20021016012047.GC563@gnoll.homeip.net> <20021016224148.GB2408@naboo.club.berlin.ccc.de> <1034923953.22519.37.camel@goofy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@gnumonks.org>,
	Jean-Francois Dive <jef@linuxbe.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jimmy Hedman <jimmy.hedman@southpole.se>
Content-Disposition: inline
In-Reply-To: <1034923953.22519.37.camel@goofy>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

some facts:

-> Harald have already spent some times as far as i can googelize to design some
the thing (but i cant find any documents, the presentation papers seems to be
gone from gnumonks.org)

-> As it is, only some cases of traffic pattern need synchronisation between 2 or n boxes:
 - An inside box, after failover send a data packet and the remove peer answer, your'e good, an entry is created.
 - If you have an impolite firewall (whic drop and dont send icmp back), a retransmit of an inside box
 will trigger as well a new conntrack entry to get created.
 - All of this is for TCP based traffic which seems to be the only real problem as udp protocols
 will always implement some sort of retransmit.

-> Inclusion into HA setups 'd probably be the best ans neatest scenario, so in userspace. 
  kernelspace / userspace beeing a performance issue. However, a kernel implementation 'd be
  pretty invasive, mainly for the management of the network protocol itself, and queing of events
  (i can't image very easily build UDP or whatever packets, information queuing).


On Fri, Oct 18, 2002 at 08:52:29AM +0200, Jimmy Hedman wrote:
> Hello,
> is there some code for active failover? I started looking at the
> netfilter code to try to implement this myself, but if there exist some
> code allready, i'd be glad to use that one instead.
> 
> // Jimmy
> 
> On Thu, 2002-10-17 at 00:41, Harald Welte wrote:
> > On Wed, Oct 16, 2002 at 11:20:47AM +1000, Jean-Francois Dive wrote:
> > > Hi guys,
> > > 
> > > I was wondering if there was any changes in the standstill for active failover
> > > developement ? 
> > 
> > no, at least for my part I won't be able to continue this project before
> > Qarter 2 / 2003
> > 
> > > -> Jean-Francois Dive
> > -- 
> > Live long and prosper
> > - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
> > ============================================================================
> > GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
> > V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
> -- 
> Jimmy Hedman                       South Pole AB
> Phone:  +46 8 51420420             Gelbjutarvägen 5
> Fax:    +46 8 51420429             SE - 17148 Solna 
> e-mail: jimmy.hedman@southpole.se  www.southpole.se
> 

-- 

-> Jean-Francois Dive
--> jef@linuxbe.org

  There is no such thing as randomness.  Only order of infinite
  complexity.  - _The Holographic Universe_, Michael Talbot
