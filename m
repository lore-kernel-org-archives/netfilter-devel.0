From: Pierre Chifflier <chifflier@wzdftpd.net>
Subject: ebtables_nfqueue: missing structure afinfo
Date: Mon, 24 Jan 2011 21:55:18 +0100
Message-ID: <4D3DE736.70808@wzdftpd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.wzdftpd.net ([91.121.80.151]:53025 "EHLO mail.wzdftpd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab1AXVDP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:03:15 -0500
Received: from [192.168.1.83] (96.252.77-86.rev.gaoland.net [86.77.252.96])
	by mail.wzdftpd.net (Postfix) with ESMTPSA id 4E4AA207A1
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Jan 2011 21:55:20 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm still working on a module to add the NFQUEUE target to ebtables.

So far, I've been able to split the work on two parts: sending the
packets to nfqueue, and re-inject them after a verdict. I'll split
questions on separate emails.

Adding the NFQUEUE target is not a difficult task (making the
ebt_do_tables return NF_QUEUE_NR(queue_num)), however this won't work
since the __nf_queue() function [1] requires an afinfo structure :
132         afinfo = nf_get_afinfo(pf);
133         if (!afinfo)
134                 goto err_unlock;

Since there is no afinfo structure for AF_BRIDGE, this won't work.

I tried adding a dummy (empty) afinfo structure and registering it in
ebtables_init(), but that does not look like a clean solution ...

What would be the best way (in order to be proposed mainstream) to do
that ? The afinfo structure seems to be called to save the route (and
then restored when re-injecting), I'm not sure yet if this is necessary
for AF_BRIDGE packets.

Thanks,
Pierre

[1]
http://www.cs.fsu.edu/~baker/devices/lxr/http/source/linux/net/netfilter/nf_queue.c#L108
