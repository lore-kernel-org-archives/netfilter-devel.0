From: Jean-Francois Dive <jef@linuxbe.org>
Subject: Re: RFC 2694 and iptables
Date: Wed, 6 Nov 2002 11:40:52 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021106004052.GF484@gnoll.homeip.net>
References: <3DC6A4E7.30708@gemplus.com> <20021105061017.25960.qmail@web40310.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Didier Tournier <Didier.TOURNIER@gemplus.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kevin McConnell <kevymac@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20021105061017.25960.qmail@web40310.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Well, you're riht this does not look usefull in his case, but this
does not mean this is not usefull at all..

It may be used to interconnect with NAT to network which have the same
address space: make each network look at the other one as another 
network prefix than what it is. This sounds bad network design and
i agree, but this is a real world situation where, for exemple, 2 
mega corp's merges and changing the network prefix is not a feasable
thing. Off course, then, dns payload manipulation is usefull.

JeF

On Mon, Nov 04, 2002 at 10:10:17PM -0800, Kevin McConnell wrote:
> 
> --- Didier Tournier <Didier.TOURNIER@gemplus.com>
> wrote:
> > Hi,
> > I would like to build a dns alg with iptables.
> > The main role of a dns alg is to modify DNS response
> > packet by replacing 
> > private IP address with public ones.
> 
> Before you go trying to implement this module, you do
> of course realize that there isn't a need for this,
> right? The current bind9 is perfectly capable of
> coexisting on a host that has both RFC 1918 addresses
> and real addresses, and depending on what clients ask
> it for resolution, it can define a "view" of what the
> internet/intranet should look like for them. Before
> you go putting too much effort for this, please look
> into seeing if this can solve what you are trying to
> accomplish. If not, then please reword your statement
> to explain what you are trying to do.
> 
> 
> =====
> Kevin C. McConnell --RHCE-- <Red Hat Certified Engineer>
> 
> __________________________________________________
> Do you Yahoo!?
> HotJobs - Search new jobs daily now
> http://hotjobs.yahoo.com/

-- 

-> Jean-Francois Dive
--> jef@linuxbe.org

  There is no such thing as randomness.  Only order of infinite
  complexity.  - _The Holographic Universe_, Michael Talbot
