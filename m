From: Willy Tarreau <willy@w.ods.org>
Subject: Re: Strange thing with iptables
Date: Sat, 11 Sep 2004 19:52:07 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040911175207.GA9095@alpha.home.local>
References: <opsd15s018le1n2s@mail.tlt.hu>
	<1094732295.8900.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1094732295.8900.7.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Thu, Sep 09, 2004 at 02:18:15PM +0200, Martin Josefsson wrote:
> > 
> > iptables -A FORWARD -s $machine/255.255.0.255 -j ACCEPT
> > 
> > 
> > What I was surprised on is the netmask. Is this a feature or a bug? I mean
> > this is quite strange netmask for me.
> 
> It's a feature :)
> It doesn't make the current code any more complicated.
> And ther are actually people using it to do weird stuff...

I second this. I actually had to use the same principle on some equipment
(alteon) which also supports this, and it saved me a lot of filters when
writing anti-spoofing rules on a port where two IP networks coexist.

Cheers,
Willy
