From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info
 structure
Date: Thu, 17 May 2018 12:42:00 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1805171232210.30649@n3.vanv.qr>
References: <20180517084442.GA23981@kroah.com> <20180517085951.2wxvcg5herkjaxda@unicorn.suse.cz> <20180517093410.GB17597@kroah.com> <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com> <20180517100908.GA3150@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Hackmann <ghackmann@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Michal Kubecek <mkubecek@suse.cz>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180517100908.GA3150@kroah.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thursday 2018-05-17 12:09, Greg Kroah-Hartman wrote:
>> > --- a/net/netfilter/x_tables.c
>> > +++ b/net/netfilter/x_tables.c
>> > @@ -1183,11 +1183,10 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
>> >  	 * than shoot all processes down before realizing there is nothing
>> >  	 * more to reclaim.
>> >  	 */
>> > -	info = kvmalloc(sz, GFP_KERNEL | __GFP_NORETRY);
>> > +	info = kvzalloc(sz, GFP_KERNEL | __GFP_NORETRY);
>> >  	if (!info)
>> >  		return NULL;
>>
>> I am curious, what particular path does not later overwrite the whole zone ?
>
>In do_ipt_get_ctl, the IPT_SO_GET_ENTRIES: option uses a len value that
>can be larger than the size of the structure itself.
>
>Then the data is copied to userspace in copy_entries_to_user() for ipv4
>and v6, and that's where the "bad data"

If the kernel incorrectly copies more bytes than it should, isn't that
a sign that may be going going past the end of the info buffer?
(And thus, zeroing won't truly fix the issue)

And if the kernel copies too few (because it just does not have more
data than userspace is requesting), what remains in the user buffer
is the garbage that originally was there.
