From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv5 0/2] Find address type on the packet's interface
Date: Tue, 20 Nov 2007 09:00:41 +0100
Message-ID: <11955456442652-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:52288 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbXKTIAu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:00:50 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id C43F7C14D5
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Nov 2007 09:00:48 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

This is exactly the same as the previous patchset except the xtables changes:
ipt_addrtype.{c,h} is used, and ipt_addrtype_info for rev 0,
ipt_adddrtype_info_v1 for rev 1.

Regards,
  Attila
