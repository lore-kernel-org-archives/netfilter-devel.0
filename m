From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 17:04:51 +0200
Message-ID: <4A2FCB93.3090507@trash.net>
References: <20090610133716.14805.95308.stgit@Decadence> <20090610134150.14805.4528.stgit@Decadence> <4A2FB985.8030002@netfilter.org> <4A2FB9BA.5050106@trash.net> <4A2FC9B5.8030600@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60553 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbZFJPEw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:04:52 -0400
In-Reply-To: <4A2FC9B5.8030600@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> There's another issue that I have to fix here that I haven't noticed so far:
> 
> +       if (nf_conntrack_event_report(IPCT_DESTROY, ct,
> +                                     NETLINK_CB(skb).pid,
> +                                     nlmsg_report(nlh)) < 0) {
> +               nf_ct_delete_from_lists(ct);
> +               /* we failed to report the event, try later */
> +               nf_ct_insert_dying_list(ct);
> +               nf_ct_put(ct);
> +               return 0;
> +       }
> 
> With this, we send the first destroy event including the netlink pid.
> However, in the second try, we send it using netlink pid 0. The netlink
> pid is important to notice who has triggered this event (the kernel,
> myself or a different process). So I think that I need to add some
> structure like:
> 
> struct nf_conn_dying {
> 	struct list_head head;
> 	u32 pid;
> 	struct nf_conn *ct;
> };
> 
> Thus, destroy events are delivered using the original netlink pid. I can
> get rid of using the nulls list in that case.
> 
> I think this is necessary, or I'm completely driving nuts and seeing
> ghosts everywhere :D.

I agree, this is necessary. But I'd add the pid to the event structure
instead of adding a completely new structure I think. Or perhaps we can
reuse an unused-at-that-time conntrack member.

> Patrick, You still plan to send the patches for
> 2.6.31 along today? I think that I need one extra day, I have to leave
> now and I cannot work on this until tomorrow morning.

Yes, the networking merge window closes a lot earlier than the general
kernel merge window and I have to get the other patches in.

I can delay it today, but I don't want to risk waiting until tomorrow.
