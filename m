From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH v2 0/2] ipset: rework extension handling to be more manageable.
Date: Tue, 03 Sep 2013 12:49:42 +0200
Message-ID: <5424021.zqoC0v9HMS@gentoovm>
References: <1378065522-65492-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309022153040.1199@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:60956 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab3ICKtz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:49:55 -0400
In-Reply-To: <alpine.DEB.2.00.1309022153040.1199@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 02 September 2013 22:04:55 Jozsef Kadlecsik wrote:
> Hi Oliver,
> 
<snip>
> 
> [Instead of extending "enum ipset_cadt_flags", better rely on the
> existing "enum ip_set_extension".]
> 
> The set extensions in their current form (full unique structures defined
> in all combinations ) reached their limit from management point of view.
> So a cleanup should change it, with the goal of keeping the memory
> requirements to the same as present but opening up for more possible
> extensions.
> 
> One possible way is to use memory blobs where the first part is the base
> structure for a given type (like "struct hash_netnet4_elem"), and the set
> structure is extended with the offsets to the extensions in the blob next
> to the base structure. That involves a couple of castings and changing
> access to all extensions by pointers (that means some reorganizatiom for
> the timeout extension).
> 
> What do you think?
> 
> Best regards,
> Jozsef

I looked again at my simplification and realised that actually it can be made 
extremely trivial, all the struct combinations and handling of flag 
combinations can go away and we can just have the for() loop that does setup 
for each flag. I'm still using cadt_flags because in order to move to using the 
extensions enum, from what I currently see, that'd require a bit of a redo in 
userspace to send it across in the netlink message as a separate thing - 
which, whilst that does strike me as a nice thing to get done, I'd consider it 
largely separate from just cleaning up that ugly mess.

Anyhow, I've completed the cleanup, [PATCH v2] will land shortly, details in 
cover letter.

Kind Regards,
Oliver.
