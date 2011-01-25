From: Patrick McHardy <kaber@trash.net>
Subject: Re: ebtables_nfqueue: missing structure afinfo
Date: Tue, 25 Jan 2011 11:34:19 +0100
Message-ID: <4D3EA72B.7000509@trash.net>
References: <4D3DE736.70808@wzdftpd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pierre Chifflier <chifflier@wzdftpd.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50483 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1AYKeZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:34:25 -0500
In-Reply-To: <4D3DE736.70808@wzdftpd.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.01.2011 21:55, Pierre Chifflier wrote:
> Hi,
> 
> I'm still working on a module to add the NFQUEUE target to ebtables.
> 
> So far, I've been able to split the work on two parts: sending the
> packets to nfqueue, and re-inject them after a verdict. I'll split
> questions on separate emails.
> 
> Adding the NFQUEUE target is not a difficult task (making the
> ebt_do_tables return NF_QUEUE_NR(queue_num)), however this won't work
> since the __nf_queue() function [1] requires an afinfo structure :
> 132         afinfo = nf_get_afinfo(pf);
> 133         if (!afinfo)
> 134                 goto err_unlock;
> 
> Since there is no afinfo structure for AF_BRIDGE, this won't work.
> 
> I tried adding a dummy (empty) afinfo structure and registering it in
> ebtables_init(), but that does not look like a clean solution ...
> 
> What would be the best way (in order to be proposed mainstream) to do
> that ? The afinfo structure seems to be called to save the route (and
> then restored when re-injecting), I'm not sure yet if this is necessary
> for AF_BRIDGE packets.

No, I don't think so either. I'd simply make the afinfo handling
in nf_queue.c optional, we can't get packets for non-existant
address families anyways.
