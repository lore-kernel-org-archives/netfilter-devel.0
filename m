From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 17 May 2018 15:20:12 +0200
Message-ID: <20180517132012.GA29160@kroah.com>
References: <20180517084442.GA23981@kroah.com>
 <20180517085951.2wxvcg5herkjaxda@unicorn.suse.cz>
 <20180517093410.GB17597@kroah.com>
 <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com>
 <20180517100908.GA3150@kroah.com>
 <alpine.LSU.2.20.1805171232210.30649@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Hackmann <ghackmann@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Michal Kubecek <mkubecek@suse.cz>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1805171232210.30649@n3.vanv.qr>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 17, 2018 at 12:42:00PM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2018-05-17 12:09, Greg Kroah-Hartman wrote:
> >> > --- a/net/netfilter/x_tables.c
> >> > +++ b/net/netfilter/x_tables.c
> >> > @@ -1183,11 +1183,10 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
> >> >  	 * than shoot all processes down before realizing there is nothing
> >> >  	 * more to reclaim.
> >> >  	 */
> >> > -	info = kvmalloc(sz, GFP_KERNEL | __GFP_NORETRY);
> >> > +	info = kvzalloc(sz, GFP_KERNEL | __GFP_NORETRY);
> >> >  	if (!info)
> >> >  		return NULL;
> >>
> >> I am curious, what particular path does not later overwrite the whole zone ?
> >
> >In do_ipt_get_ctl, the IPT_SO_GET_ENTRIES: option uses a len value that
> >can be larger than the size of the structure itself.
> >
> >Then the data is copied to userspace in copy_entries_to_user() for ipv4
> >and v6, and that's where the "bad data"
> 
> If the kernel incorrectly copies more bytes than it should, isn't that
> a sign that may be going going past the end of the info buffer?
> (And thus, zeroing won't truly fix the issue)

No, the buffer size is correct, we just aren't filling up the whole
buffer as the data requested is smaller than the buffer size.

thanks,

greg k-h
