From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] priv_data (formerly entry_data)
Date: Wed, 21 Jun 2006 10:31:50 +0200
Message-ID: <200606211031.51291.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it>
	<200606210245.26564.max@nucleus.it> <44989B26.8070704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44989B26.8070704@trash.net>
Content-Disposition: inline
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

On Wednesday 21 June 2006 3:04 am, Patrick McHardy wrote:

> >>I think this should be done somewhere in x_tables. I think I would
> >>rename xt_check_match to xt_init_match, put the allocation there
> >>and finally rename ->checkentry to ->init .. the name doesn't really
> >>fit anymore since people started doing real initialization in there,
> >>and changing prototypes is a good opportunity for fixing that.
> >
> > I was wandering why it was duplicated between IPv4 and IPv6.
>
> Do you mean the check_match functions and the ->checkentry calls?
> The only reason is because they use a different type for the "ip"
> argument.

No, I noticed several functions in ip_tables.c and ip6_tables.c that 
differentiate only by having struct ipt_entry_match * instead of struct 
ip6t_entry_match *, while they're both defines to xt_entry_match (the same 
goes for xt_entry_target).
I've not checked it throu yet, but I think that most of them could be moved to 
x_tables.c.

> > Are these changes planned for 2.6.18?
>
> I was hoping you could do it while you're changing this stuff ..
> I'd like to avoid touching all >30 files twice for a related
> change.

OK, I didn't know if someone else was already at work.
I can't do it today, though. I hope I'll start working on it tomorrow.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
