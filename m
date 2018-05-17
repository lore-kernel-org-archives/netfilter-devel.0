From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 17 May 2018 12:09:08 +0200
Message-ID: <20180517100908.GA3150@kroah.com>
References: <20180517084442.GA23981@kroah.com>
 <20180517085951.2wxvcg5herkjaxda@unicorn.suse.cz>
 <20180517093410.GB17597@kroah.com>
 <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Michal Kubecek <mkubecek@suse.cz>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Hackmann <ghackmann@google.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 17, 2018 at 02:55:42AM -0700, Eric Dumazet wrote:
> 
> 
> On 05/17/2018 02:34 AM, Greg Kroah-Hartman wrote:
> > When allocating a xt_table_info structure, we should be clearing out the
> > full amount of memory that was allocated, not just the "header" of the
> > structure.  Otherwise odd values could be passed to userspace, which is
> > not a good thing.
> > 
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > v2: use kvzalloc instead of kvmalloc/memset pair, as suggested by Michal Kubecek
> > 
> >  net/netfilter/x_tables.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> > index cb7cb300c3bc..cd22bb9b66f3 100644
> > --- a/net/netfilter/x_tables.c
> > +++ b/net/netfilter/x_tables.c
> > @@ -1183,11 +1183,10 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
> >  	 * than shoot all processes down before realizing there is nothing
> >  	 * more to reclaim.
> >  	 */
> > -	info = kvmalloc(sz, GFP_KERNEL | __GFP_NORETRY);
> > +	info = kvzalloc(sz, GFP_KERNEL | __GFP_NORETRY);
> >  	if (!info)
> >  		return NULL;
> >  
> > -	memset(info, 0, sizeof(*info));
> >  	info->size = size;
> >  	return info;
> >  }
> > 
> 
> I am curious, what particular path does not later overwrite the whole zone ?

The path back was long, adding Greg Hackman who helped to debug this to
the To: to confirm that I got this correct...

In do_ipt_get_ctl, the IPT_SO_GET_ENTRIES: option uses a len value that
can be larger than the size of the structure itself.

Then the data is copied to userspace in copy_entries_to_user() for ipv4
and v6, and that's where the "bad data" was noticed (a researcher was
using a kernel patch to determine what the data was)

Greg, that's the correct path here, right?

> Do not get me wrong, this is not fast path, but these blobs can be huge.

Yeah, I bet, but for "normal" cases the size should be small and all
should be fine.

thanks,

greg k-h
