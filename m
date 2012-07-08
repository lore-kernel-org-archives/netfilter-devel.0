From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2 0/6] IPv6 tarpit support
Date: Sun,  8 Jul 2012 11:11:19 -0700
Message-ID: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: jengelh@inai.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41153 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab2GHSL0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:11:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan

I believe I've addressed the concerns you raised in the original set.
This version separates out the XTTARPIT_* modes into their own functions
(patches 1-3.) It also changes tarpit_generic to return a bool so we
can now handle the early exits properly.

Thanks
Josh

Josh Hunt (6):
  netfilter: tarpit: Move XTTARPIT_TARPIT mode processing to its own
    function
  netfilter: tarpit: Move XTTARPIT_HONEYPOT mode into its own function
  netfilter: tarpit: Move XTTARPIT_RESET to its own function
  netfilter: tarpit: Make tarpit code generic
  netfilter: tarpit: Add IPv6 support
  netfilter: tarpit: Enable IPv6 userspace support

 extensions/libxt_TARPIT.c |    2 +-
 extensions/xt_TARPIT.c    |  407 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 316 insertions(+), 93 deletions(-)

