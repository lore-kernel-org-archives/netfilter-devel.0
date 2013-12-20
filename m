From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Fri, 20 Dec 2013 13:34:00 -0700
Message-ID: <CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
	<1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
	<20131218095322.GA4740@localhost>
	<CANLsYkxMzdFCpJ3456PPd8KsEPi-U70kJDqGv8c3BhCsKY8RiQ@mail.gmail.com>
	<20131219194339.GA4561@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:38544 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3LTUeB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Dec 2013 15:34:01 -0500
Received: by mail-ve0-f172.google.com with SMTP id jw12so1802410veb.31
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2013 12:34:01 -0800 (PST)
In-Reply-To: <20131219194339.GA4561@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19 December 2013 12:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Dec 19, 2013 at 10:20:56AM -0700, Mathieu Poirier wrote:
>>      >       NFNLGRP_CONNTRACK_EXP_DESTROY,
>>      >  #define NFNLGRP_CONNTRACK_EXP_DESTROY
>>      NFNLGRP_CONNTRACK_EXP_DESTROY
>>      > +     NFNLGRP_CONNTRACK_QUOTA,
>>      > +#define NFNLGRP_CONNTRACK_QUOTA
>>      NFNLGRP_CONNTRACK_QUOTA
>>      Use NFNLGRP_ACCT_QUOTA, this has nothing to do with conntrack.
>>
>>    Please confirm that you suggest to create a
>>    "enum nfnl_acct_groups{}"
>>    in include/uapi/linux/netfilter/nfnetlink_acct.h, the same way as
>>    above?
>
> No. I just mean that you rename that since it this has nothing to do
> with conntrack.
>
>>      >       __NFNLGRP_MAX,
>>      >  };
>>      >  #define NFNLGRP_MAX  (__NFNLGRP_MAX - 1)
>>      > diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h
>>      b/include/uapi/linux/netfilter/nfnetlink_acct.h
>>      > index c7b6269..ae8ea0a 100644
>>      > --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
>>      > +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
>>      > @@ -19,6 +19,7 @@ enum nfnl_acct_type {
>>      >       NFACCT_PKTS,
>>      >       NFACCT_BYTES,
>>      >       NFACCT_USE,
>>      > +     NFACCT_QUOTA,
>>      >       __NFACCT_MAX
>>      >  };
>>      >  #define NFACCT_MAX (__NFACCT_MAX - 1)
>>      > diff --git a/include/uapi/linux/netfilter/xt_nfacct.h
>>      b/include/uapi/linux/netfilter/xt_nfacct.h
>>      > index 3e19c8a..c2e49a6 100644
>>      > --- a/include/uapi/linux/netfilter/xt_nfacct.h
>>      > +++ b/include/uapi/linux/netfilter/xt_nfacct.h
>>      > @@ -3,11 +3,22 @@
>>      >
>>      >  #include <linux/netfilter/nfnetlink_acct.h>
>>      >
>>      > +enum xt_quota_flags {
>>      > +     XT_QUOTA_INVERT    = 1 << 0,
>>      I don't understand the interaction of invert and the event delivery.
>>
>>    It was added for flexibility [...]
>
> I mean: This is currently broken in your patch, it is always
> delivering an event when the quota is reached, no matter if invert is
> set or not.
>
>>      > +     XT_QUOTA_PACKET    = 1 << 1,
>>      > +     XT_QUOTA_QUOTA     = 1 << 2,
>>      XT_QUOTA_QUOTA ? :-)
>>
>>    Yes - quotas are not mandatory [...]
>
> I'm just proposing a plain rename:
>
> s/XT_QUOTA_PACKET/XT_NFACCT_QUOTA_PKTS
> s/XT_QUOTA_QUOTA/XT_NFACCT_QUOTA_BYTES
>
> XT_QUOTA refers to the xt_quota match, which is a different iptables
> match extensions.
>
> Thinking again on the event delivery, I think it's better if the
> nfacct match using the new --quota does not deliver the event itself.
> You can use libnetfilter_queue instead, eg.
>
>         iptables -I INPUT -p icmp \
>                  -m nfacct icmp --quota 12345 --mode bytes --match-once \
>                  -j NFLOG --nflog-prefix "icmp: " --nflog-group 34
>
> The --once parameter tells to match only if you just crossed the quota
> limit (so the event is sent once). The idea is to use nflog to deliver
> the event, which is way more flexible as it includes useful
> information.

I'm not against the idea as it is less code for me to write.  Is this
"--match-one" thing already available?  If not I'll come up with it.
Just to be clear, if "--match-one" isn't specified a message is sent
each time we try to send a packets and the quota has been reached.
