From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 08:21:47 -0800
Message-ID: <20050321162147.GA14696@linuxace.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<20050314171821.GA29034@linuxace.com>
	<200503211513.59943.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Content-Disposition: inline
In-Reply-To: <200503211513.59943.thomas.jarosch@intra2net.com>
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

On Mon, Mar 21, 2005 at 03:13:59PM +0100, Thomas Jarosch wrote:
> > > I'm facing a problem with conntrack on a 2.4.21 kernel.
> > > One machine which firewalls a webradio reproducable
> > > becomes unresponsive every week with
> > > "ip_conntrack: table full, dropping packet."
> >
> > When this happens, what does output from this look like:
> >
> > wc -l /proc/net/ip_conntrack ; grep ip_conntrack /proc/slabinfo
> 
> It happend again on Sunday night:
> 
> wc -l:
> 35 /proc/net/ip_conntrack
> 
> /proc/slabinfo:
> ip_conntrack       16263  16272    320 1356 1356    1

Yes, you're leaking conntracks somewhere.  Any possibility of testing
a somewhat newer kernel than 2.4.21?  This may have already been
fixed.

Phil
