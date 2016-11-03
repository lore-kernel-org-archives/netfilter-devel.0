From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH RFC netfilter-next 1/3] netfilter: introduce accessor functions for hook entries
Date: Thu, 03 Nov 2016 12:32:10 -0400
Message-ID: <f7tshr8y16d.fsf@redhat.com>
References: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
        <1477592873-4468-2-git-send-email-aconole@bytheb.org>
        <20161103161559.GA3362@salvia>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35384 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756598AbcKCQcO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 12:32:14 -0400
Received: by mail-qt0-f196.google.com with SMTP id m48so1889936qta.2
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Nov 2016 09:32:13 -0700 (PDT)
In-Reply-To: <20161103161559.GA3362@salvia> (Pablo Neira Ayuso's message of
        "Thu, 3 Nov 2016 17:15:59 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Thu, Oct 27, 2016 at 02:27:51PM -0400, Aaron Conole wrote:
>> This allows easier future refactoring.
>> 
>> Signed-off-by: Aaron Conole <aconole@bytheb.org>
>> ---
>>  include/linux/netfilter.h       | 35 ++++++++++++++++++++++++++++++++++-
>>  net/bridge/br_netfilter_hooks.c |  2 +-
>>  net/netfilter/core.c            |  8 +++-----
>>  net/netfilter/nf_queue.c        |  8 ++++----
>>  4 files changed, 42 insertions(+), 11 deletions(-)

...

> I'd suggest something like:
>
> static inline int
> nf_entry_hookfn(const struct nf_hook_entry *entry,
>                 struct sk_buff *skb, struct nf_hook_state *state)
> {
>         return entry->ops.hook(entry, nf_hook_entry_priv(entry), skb, state);
> }
>
> So you can avoid this:
>
> 		verdict = nf_hook_entry_hookfn(*entryp)
> 			(nf_hook_entry_priv(*entryp), skb, state);

Makes sense, I'll do that.  Thanks for the review!
