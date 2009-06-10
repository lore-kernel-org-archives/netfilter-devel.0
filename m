From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 16:56:53 +0200
Message-ID: <4A2FC9B5.8030600@netfilter.org>
References: <20090610133716.14805.95308.stgit@Decadence> <20090610134150.14805.4528.stgit@Decadence> <4A2FB985.8030002@netfilter.org> <4A2FB9BA.5050106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60897 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbZFJO5B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:57:01 -0400
In-Reply-To: <4A2FB9BA.5050106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Pablo Neira Ayuso wrote:
>>> This patch improves ctnetlink event reliability if one broadcast
>>> listener has set the NETLINK_BROADCAST_ERROR socket option.
>>
>> This is missing reliable event delivery for _eventmask_report(). I'm
>> going to resend this patch. Sorry and rebase my git tree with the new
>> patch.
> 
> OK thanks. I'll back them out again from my tree :)

There's another issue that I have to fix here that I haven't noticed so far:

+       if (nf_conntrack_event_report(IPCT_DESTROY, ct,
+                                     NETLINK_CB(skb).pid,
+                                     nlmsg_report(nlh)) < 0) {
+               nf_ct_delete_from_lists(ct);
+               /* we failed to report the event, try later */
+               nf_ct_insert_dying_list(ct);
+               nf_ct_put(ct);
+               return 0;
+       }

With this, we send the first destroy event including the netlink pid.
However, in the second try, we send it using netlink pid 0. The netlink
pid is important to notice who has triggered this event (the kernel,
myself or a different process). So I think that I need to add some
structure like:

struct nf_conn_dying {
	struct list_head head;
	u32 pid;
	struct nf_conn *ct;
};

Thus, destroy events are delivered using the original netlink pid. I can
get rid of using the nulls list in that case.

I think this is necessary, or I'm completely driving nuts and seeing
ghosts everywhere :D. Patrick, You still plan to send the patches for
2.6.31 along today? I think that I need one extra day, I have to leave
now and I cannot work on this until tomorrow morning.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
