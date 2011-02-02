From: Pierre Chifflier <chifflier@wzdftpd.net>
Subject: Re: ebtables_nfqueue: missing structure afinfo
Date: Wed, 02 Feb 2011 20:22:36 +0100
Message-ID: <4D49AEFC.4040203@wzdftpd.net>
References: <4D3DE736.70808@wzdftpd.net> <4D3EA72B.7000509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.wzdftpd.net ([91.121.80.151]:56785 "EHLO mail.wzdftpd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab1BBTWm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:22:42 -0500
In-Reply-To: <4D3EA72B.7000509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/25/2011 11:34 AM, Patrick McHardy wrote:
> On 24.01.2011 21:55, Pierre Chifflier wrote:
>> Hi,
>>
>> I'm still working on a module to add the NFQUEUE target to ebtables.
>>
>> So far, I've been able to split the work on two parts: sending the
>> packets to nfqueue, and re-inject them after a verdict. I'll split
>> questions on separate emails.
>>
>> Adding the NFQUEUE target is not a difficult task (making the
>> ebt_do_tables return NF_QUEUE_NR(queue_num)), however this won't work
>> since the __nf_queue() function [1] requires an afinfo structure :
>> 132         afinfo = nf_get_afinfo(pf);
>> 133         if (!afinfo)
>> 134                 goto err_unlock;
>>
>> Since there is no afinfo structure for AF_BRIDGE, this won't work.
>>
>> I tried adding a dummy (empty) afinfo structure and registering it in
>> ebtables_init(), but that does not look like a clean solution ...
>>
>> What would be the best way (in order to be proposed mainstream) to do
>> that ? The afinfo structure seems to be called to save the route (and
>> then restored when re-injecting), I'm not sure yet if this is necessary
>> for AF_BRIDGE packets.
> 
> No, I don't think so either. I'd simply make the afinfo handling
> in nf_queue.c optional, we can't get packets for non-existant
> address families anyways.

Thanks Patrick,

I've spent a few days trying to make it optional (in nf_queue.c,
function __nf_queue), however I have a weird problem:
If I remove the test for afinfo (and ensure that the pointer is not used
if null), everything seems to work fine.
However, when I use a userspace program (always returning NF_ACCEPT), I
got a fatal kernel oops (or panic) regarding packets.
According to the info displayed, it seems to be sometimes in
br_handle_frame, at
this point:
	case BR_STATE_FORWARDING:
		rhook = rcu_dereference(br_should_route_hook);
		if (rhook) {
			if ((*rhook)(skb))

inside the (*rhook) call.

Sometimes it's in netlink_unicast (unknown location), always when
reinjecting packet.

I tried to get more info with kgdb, but without much success:
#2  0xc11d1adc in skb_release_all (skb=0xdf1ed600) at net/core/skbuff.c:403
#3  __kfree_skb (skb=0xdf1ed600) at net/core/skbuff.c:417
#4  0xc11d1bdb in kfree_skb (skb=0xdf1ed600) at net/core/skbuff.c:438
#5  0xc11ee4d1 in netlink_unicast (ssk=0xdbf15c00, skb=<value optimized
out>,
    pid=<value optimized out>, nonblock=0) at net/netlink/af_netlink.c:921

Any idea on what could cause this ? AFAICT, it was not happening when I
used a fake afinfo structure.

Thanks,
Pierre
