From: luciano.coelho@nokia.com
Subject: [PATCH iptables-next 0/2] extensions: add condition match and target extensions
Date: Tue, 31 Aug 2010 10:28:57 +0300
Message-ID: <1283239739-5739-1-git-send-email-luciano.coelho@nokia.com>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:37565 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab0HaH2X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:28:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Hi,

These patches add the condition match and target extensions to the iptables
tool.  These are the corresponding user space changes for the kernel patches I
sent previously (they work regardless of whether the capabilities patch is
applied or not).

This patches should be released in the iptables tool when the condition kernel
patches are released, so they should go to the iptables-next tree.

Cheers,
Luca.

Luciano Coelho (2):
  extensions: add condition match extension
  extensions: add condition target extension.

 extensions/libxt_CONDITION.c   |  144 ++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_CONDITION.man |    9 +++
 extensions/libxt_condition.c   |  128 +++++++++++++++++++++++++++++++++++
 extensions/libxt_condition.man |   10 +++
 4 files changed, 291 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_CONDITION.c
 create mode 100644 extensions/libxt_CONDITION.man
 create mode 100644 extensions/libxt_condition.c
 create mode 100644 extensions/libxt_condition.man

