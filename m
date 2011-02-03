From: Pierre Chifflier <chifflier@edenwall.com>
Subject: WIP/RFC: add new module ebt_NFQUEUE for ebtables
Date: Thu,  3 Feb 2011 15:32:17 +0100
Message-ID: <1296743540-8148-1-git-send-email-chifflier@edenwall.com>
References: <4D49E1E0.50304@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:44574 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756288Ab1BCPMG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:12:06 -0500
Received: from [88.171.131.12] (helo=fydelkass.edenwall.com)
	by sd-6807.edenwall.com with esmtp (Exim 4.69)
	(envelope-from <chifflier@edenwall.com>)
	id 1Pl0ER-0007TX-4t
	for netfilter-devel@vger.kernel.org; Thu, 03 Feb 2011 15:32:23 +0100
Received: from piche2.inl.fr ([192.168.33.184])
	by fydelkass.edenwall.com with esmtp (Exim 4.63)
	(envelope-from <chifflier@edenwall.com>)
	id 1Pl0EQ-0003q8-KF
	for netfilter-devel@vger.kernel.org; Thu, 03 Feb 2011 15:32:22 +0100
In-Reply-To: <4D49E1E0.50304@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here is the code as requested for the module I'm trying to add.
Basically, the code is split in two parts:
- patch 1 and 2 prepare the ebtables and nfqueue existing code to allow
  sending packets from ebtables. Since these packets are labelled PF_BRIDGE
  they have no afinfo structure, so we just ignore (instead of exiting)
- patch 3 adds the new module, which just always returns EBT_QUEUE

This is of course not meant for inclusion, but comments would be welcome.

Note: to be tested, this requires a patched version of the ebtables
userspace tool to support adding rules.

The current problems I'm facing are described in the previous mail,
and specifically a fault in skb_free, deep inside the br_handle_frame code
after a reinject.
I'll try to isolate a backtrace when it happens.

Thanks,
Pierre

