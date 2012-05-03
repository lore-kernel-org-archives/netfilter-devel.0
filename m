From: Kelvie Wong <kelvie@ieee.org>
Subject: [RFC] Patches to allow updates of timeouts in expectations
Date: Wed,  2 May 2012 17:39:22 -0700
Message-ID: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:40408 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab2ECAjd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 May 2012 20:39:33 -0400
Received: by qafi31 with SMTP id i31so3951156qaf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 02 May 2012 17:39:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all,

These are a couple of patches that I will be using in order to solve a problem
I am having with (permanent) expectation timeouts not being able to be updated.

Initial testing tells me that these work; when I call NFCT_Q_CREATE_UPDATE with
an existing permanent expectation, it updates it correctly with the new timeout
value. I use nfexp_query directly (rather than through conntrack-tools).

Anyway, this is something that was useful to me, so I'm not sure if you guys
would like these patches upstream but also, am I doing this correctly 
(especially with respect to locking), or is there any other thing I may have
overlooked?

Thanks,
Kelvie

