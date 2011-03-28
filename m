From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ctnetlink kernel dump while running multiple libnfct clients
Date: Mon, 28 Mar 2011 14:47:13 +0200
Message-ID: <4D908351.5010407@netfilter.org>
References: <AANLkTi=17VZ6Sjgj57LTa-xcJj00BSjv_-4DveiutNo1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45820 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1C1Mqp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:46:45 -0400
In-Reply-To: <AANLkTi=17VZ6Sjgj57LTa-xcJj00BSjv_-4DveiutNo1@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25/03/11 01:21, Sam Roberts wrote:
> Screenshot attached.
>
> At the time I had 3 connections to nfnetlink open
> - a userspace connection tracker

what protocol are you tracking from user-space?

> - a utility of mine that prints conntrack and expect events
> (https://github.com/sam-github/libnet/blob/master/lua/nfct-events)
> - watch -n0.8 -d sudo conntrack -L e
>
> It was after 5 or so loops of the watch that the kernel BUGged out.
>
> kernel is 2.6.38-020638-generic (ubuntu's v2.6.28-natty).
>
> For what it's worth, ctnetlink_exp_dump_expect() seems to assume that
> the expectation being printed has a helper with a name that it can
> call strlen() on:
>
>                 helper = rcu_dereference(help->helper);
>                  if (helper)
>                          NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
>          }

AFAICS, the only way to hit this problem is to have some connection 
tracking helper in the kernel which overlaps your user-space helper, ie. 
someone is attaching a kernel helper to your conntrack.

> The expectation being printed is one I created from userspace, so I
> don't know what helper was found for it, or what it's name would be
> (if any).

Need more info to know what's going on.
