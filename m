From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack tree
Date: Thu, 17 Mar 2005 17:31:41 +0900 (JST)
Message-ID: <200503170831.j2H8VgbY014017@toshiba.co.jp>
References: <423889E6.1000703@trash.net>
	<200503161954.j2GJsIhi017839@toshiba.co.jp>
	<42389136.3050900@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
In-Reply-To: <42389136.3050900@trash.net>
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


Hi, Patrick,

OK, I agree introducing nf_ct_ops.

But in the current, it's not acceptable to introduce nf_conntrack_common
as you said in other mail. I think it needs many changes to ip_conntrack and
ip_nat, it may be difficult to change nf_conn structure
(e.g. optimization), and it will confuse us - What we unify is ?

My suggestion is pulling out common definitions of enum and flags to some
common header files, and making {ip,nf}_conntrack*.h include them.
No change to ip_conntrack_*.c is necessary.

Regards,
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


From: Patrick McHardy <kaber@trash.net>
Date: Wed, 16 Mar 2005 21:04:06 +0100

> Yasuyuki KOZAKAI wrote:
> >>That won't work when nf_conntrack is already loaded. Do you think
> >>it is necessary to allow people to build both as modules?
> > 
> > 
> > You're right. #ifdef or other staff is needed.
> 
> If we go the way Joszef propsed, namely having something like
> a global struct nf_ct_ops *, we can simply add a flag to it
> which specifies which conntrack is usec.
> 
> >>                                                          It would
> >>be easier to just force them to choose, and would probably result
> >>in more people actually using it since ip_conntrack wouldn't be used
> >>by default anymore.
> > 
> > But I want this flexibility if possible so that we can test matches/targets
> > with ip_conntrack/nf_conntrack without recompiling.
> 
> I see that it would be useful for testing, but I fear that it will
> result in additional complexity and bugs with little gain for users.
> Let's see how it works out, if it really does cause a lot of extra
> complexity it would prefer to only allow one at a time.
> 
> Regards
> Patrick
> 
