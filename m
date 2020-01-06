Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88483C33C9B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 20:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AFA4206F0
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 20:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgAFUas (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 15:30:48 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:37712 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgAFUar (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 15:30:47 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ioZ1R-0006k7-0F; Mon, 06 Jan 2020 21:30:45 +0100
Date:   Mon, 6 Jan 2020 21:30:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, ebiederm@xmission.com,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 2/9] netfilter: normalize ebtables function
 declarations
Message-ID: <20200106203044.GQ795@breakpoint.cc>
References: <cover.1577830902.git.rgb@redhat.com>
 <c07cc1ecac3aaa09ebee771fa53e73ab6ac4f75f.1577830902.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c07cc1ecac3aaa09ebee771fa53e73ab6ac4f75f.1577830902.git.rgb@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> wrote:
> Git context diffs were being produced with unhelpful declaration types
> in the place of function names to help identify the funciton in which
> changes were made.
> 
> Normalize ebtables function declarations so that git context diff
> function labels work as expected.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

I suggest that you also drop the inline keyword for all functions
that are called from control path, for example

> -static inline void *
> -find_inlist_lock_noload(struct list_head *head, const char *name, int *error,
> -			struct mutex *mutex)
> +static inline void *find_inlist_lock_noload(struct list_head *head,
> +					    const char *name, int *error,
> +					    struct mutex *mutex)

> -static inline struct ebt_table *
> -find_table_lock(struct net *net, const char *name, int *error,
> -		struct mutex *mutex)
> +static inline struct ebt_table *find_table_lock(struct net *net,

> -static inline int
> -ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
> -		unsigned int *cnt)
> +
> +static inline int ebt_check_match(struct ebt_entry_match *m,

> -static inline int
> -ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
> -		  unsigned int *cnt)

> -static inline int
> -ebt_check_entry_size_and_hooks(const struct ebt_entry *e,

> -static inline int
> -ebt_get_udc_positions(struct ebt_entry *e, struct ebt_table_info *newinfo,
> -		      unsigned int *n, struct ebt_cl_stack *udc)

> -static inline int
> -ebt_cleanup_match(struct ebt_entry_match *m, struct net *net, unsigned int *i)

> -static inline int
> -ebt_cleanup_watcher(struct ebt_entry_watcher *w, struct net *net, unsigned int *i)

> -static inline int
> -ebt_cleanup_entry(struct ebt_entry *e, struct net *net, unsigned int *cnt)

> -static inline int
> -ebt_check_entry(struct ebt_entry *e, struct net *net,
> -		const struct ebt_table_info *newinfo,
> -		const char *name, unsigned int *cnt,
> -		struct ebt_cl_stack *cl_s, unsigned int udc_cnt)

.. can all have 'inline' removed.  Other than that this looks good to me.
