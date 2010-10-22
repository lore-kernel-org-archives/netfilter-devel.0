From: "Jeff Haran" <jharan@bytemobile.com>
Subject: Misleading statement in netfilter-hacking-HOWTO
Date: Thu, 21 Oct 2010 17:59:07 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A7021F262E@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:7703 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0JVBRi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:17:38 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'd like to point out that a statement in the netfilter-hacking-HOWTO
appears to be misleading. Section 3.1 Netfilter Base contains the
following:

"A module that registers a function must specify the priority of the
function within the hook; then when that netfilter hook is called from
the core networking code, each module registered at that point is called
in the order of priorites, and is free to manipulate the packet."

It's that "free to manipulate the packet" at the end that I am having
trouble with. To my reading, it implies that changes to the contents of
the packet will effect only the packet represented by the skb. However,
there appear to be places in the kernel where the skb that is passed to
a netfilter hook has been cloned. The particular instance I am referring
to here is in the bridge code. Assuming I am not misreading the code,
br_flood_deliver() in net/bridge/br_forward.c will result in cloned skbs
being passed to the netfilter hooks that register for NF_BR_LOCAL_OUT in
PF_BRIDGE.

In order to modify just one of the packets that get flooded out of the
bridge via a hook, it would appear that the hook function would have to
call skb_unshare() on the passed in skb first and modify only the data
associated with the skb returned from skb_unshare(). Otherwise, all of
the other skbs that are sharing the data and which in this case would
get transmitted out other bridge ports would experiencee the same
modification.

This however raises an interesting question:

If said hook function were to do this how would the modified skb get
iterated through the remainder of the hook functions?
Would one use nf_reinject() for this? That would cause it to be passed
through all of the hook functions, including the one that created it,
right?
Or is there some method I am unaware of that can cause the netfilter
frame work to unshared cloned skbs before they are passed to the hook
functions?

Perhaps the HOWTO could be updated to advise its readers if they run
into this situation.

Thanks,

Jeff Haran
Bytemobile

