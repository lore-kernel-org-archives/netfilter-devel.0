From: Jan Engelhardt <jengelh@medozas.de>
Subject: The glorious NFCT "none" helper
Date: Thu, 19 May 2011 00:21:04 +0200
Message-ID: <1305757266-8730-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50560 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab1ERWVJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 18:21:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hej,


While working with a customer setup, I came up with this funny idea
of plugging a no-op NFCT helper in to workaround some nfct_ftp
problem. Besides that, it may also be used to simply skip helping and
save cycles. See the patch's message for details - I'd love to hear
something about it.

(NB: nf_nat_ftp was loaded, but not used when connecting between netA
and netB.)


Jan
