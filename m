From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/23] netfilter: xtables: do centralized checkentry call
 (1/2)
Date: Mon, 06 Oct 2008 18:23:27 +0200
Message-ID: <48EA3B7F.9000007@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030505090607090001000807"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46189 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJFQXe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:23:34 -0400
In-Reply-To: <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030505090607090001000807
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> It used to be that {ip,ip6,etc}_tables called extension->checkentry
> themselves, but this can be moved into the xtables core.

This one doesn't apply cleanly:

patching file net/bridge/netfilter/ebtables.c
Hunk #3 FAILED at 684.
1 out of 3 hunks FAILED -- saving rejects to file 
net/bridge/netfilter/ebtables.c.rej

Since I guess this will introduce new rejects in the following
patches, I'll wait until you've figured out what went wrong.
I've applied the patches in the order specified on top of
8d51a6615, replacing the previous patches.

--------------030505090607090001000807
Content-Type: text/plain;
 name="ebtables.c.rej"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ebtables.c.rej"

*************** ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
*** 692,706 ****
  	}
  
  	ret = xt_check_target(target, NFPROTO_BRIDGE, t->target_size,
- 	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
  	if (ret < 0) {
  		module_put(target->me);
  		goto cleanup_watchers;
- 	} else if (t->u.target->checkentry &&
- 	    !t->u.target->checkentry(name, e, NULL, t->data, hookmask)) {
- 		module_put(t->u.target->me);
- 		ret = -EINVAL;
- 		goto cleanup_watchers;
  	}
  	(*cnt)++;
  	return 0;
--- 684,694 ----
  	}
  
  	ret = xt_check_target(target, NFPROTO_BRIDGE, t->target_size,
+ 	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
+ 	      e, t->data);
  	if (ret < 0) {
  		module_put(target->me);
  		goto cleanup_watchers;
  	}
  	(*cnt)++;
  	return 0;

--------------030505090607090001000807--
