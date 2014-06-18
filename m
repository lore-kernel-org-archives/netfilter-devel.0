From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH libnetfilter_conntrack] add userspace dump filter
Date: Wed, 18 Jun 2014 10:59:36 +0200
Message-ID: <20140618085936.GA3923@localhost>
References: <20140617123718.GC24712@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53417 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965238AbaFRI7m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:59:42 -0400
Content-Disposition: inline
In-Reply-To: <20140617123718.GC24712@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 17, 2014 at 09:37:18PM +0900, Ken-ichirou MATSUZAWA wrote:
>  Hello,
> 
> I tried to filter dump by zone in userspace. But it seems for me
> that CTA_ZONE is classified larger class than CTA_MARK, then I
> think it allows to be filtered in kernel like CTA_MARK/CTA_MARK_MASK.
> 
> Which is preferable way?
>
> --------
> 
> This patch adds more type to filter_dump, working in userspace,

If this works from userspace, then you can just filter out the
conntracks from the callback handler itself. So I don't think this
patch is the way to go.

The kernel side filtering aims to reduce the time to dump conntrack
tables with lots of entries. If you want to add filtering by zone in
the ctnetlink_dump_table path, you have to generalize the existing
ctnetlink code.

My suggestion is to rework ctnetlink_dump_filter to make it look like
(just quick code, I didn't even compile test it):

struct ctnetlink_dump_filter {
        enum ctnetlink_filter_key       key;
        u_int32_t                       data;
        u_int32_t                       mask;
};

The keys can be:

enum ctnetlink_filter_key {
        CTNL_FILTER_MARK = 0,
        CTNL_FILTER_ZONE,
};

Then, from ctnetlink_dump_table() you'll need to do something like:

        if (filter) {
                data = ctnetlink_fetch_key(ct, filter->key);
                if (!(data & filter->mask == filter->data))
                        continue;
        }

The ctnetlink_fetch_key() should look like:

static u_int32_t ctnetlink_fetch_key(const struct nf_conn *ct, u_int32_t key)
{
        u_int32_t ret;

        switch (key) {
        case CTNL_FILTER_MARK:
                ret = ct->mark;
        case CTNL_FILTER_ZONE:
                ret = ct->zone;
        }

        return ret;
}

Please, if you work on this, first send us a patch to generalize the
filtering "framework" for ctnetlink dumps and then add the filtering
by zone.
