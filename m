From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH][RFC] Race in ip_conntrack_alter_reply
Date: Tue, 18 May 2004 07:48:36 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040518144836.GA25729@linuxace.com>
References: <20040516210616.GA20291@linuxace.com> <1084784652.1909.43.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1084784652.1909.43.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have not tried the patch yet -- I wanted to see if anyone else thought it
looked sane.  

Not much unique about my situation -- box with 6 interfaces, one of which is
internet link.  Pushing about 50mb peak per day...though the box dies at 2 - 6am
when traffic is light.  Doing nat for a handful of subnets, but most of the
/16 is not natted.  The box does run OSPF and has ~800 routes in the routing
table.  What specific info were you looking for?

Phil

On Mon, May 17, 2004 at 11:04:12AM +0200, KOVACS Krisztian wrote:
> 
>   Hi,
> 
> 2004-05-16, v keltezéssel 23:06-kor Phil Oester ezt írta:
> > I am still experiencing near daily deadlocks on a few heavily used
> > firewalls here (on all kernels from ~2.4.2x - 2.6.6).
> > 
> > In searching for a solution, I noticed that back in September 2003,
> > Rusty Russell pointed out the possibility of a race in ip_conntrack_alter_reply
> > and offered the below patch.
> > 
> > The relevant threads are:
> > 
> > http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012368.html
> > http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012388.html
> > 
> > And the patch is included below.
> 
>   Does it fix your problems? There were conversations on problems with
> ip_nat_setup_info() stuck in endless loop, but I did not experience any
> problems up to now. Could you provide some more info about your setup?
> 
> -- 
>  Regards,
>    Krisztian KOVACS
> 
> 
