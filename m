From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Patches for 2.6.26
Date: Wed,  2 Apr 2008 13:11:42 +0200
Message-ID: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43141 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbYDBLMI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Rebased against net-2.6.26/master (f0bdb7b). There were some changes
regarding netns, which were likely the cause of your most recent
merge attempts/conflicts.


N.B. I needed a command no less than 3 lines to get it done...
guess what options should be made default :^)

rm -f 00*; git-format-patch -C -M --stat=72 --summary -p --thread -n
455b3b0^..HEAD && git-send-email --suppress-from --no-chain --compose --to
kaber --cc netfilter-devel 00*
