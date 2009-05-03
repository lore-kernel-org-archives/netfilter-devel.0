From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables pull request
Date: Sun,  3 May 2009 21:54:24 +0200
Message-ID: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34567 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZECTyf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2009 15:54:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please pull from:
        git://dev.medozas.de/iptables  master

to receive 1 external submission, 1 manpage completion, and 7 code
transformations intended for the 1.4.4 'branch'.
   
Jan Engelhardt (8):
      DNAT/SNAT: add manpage documentation for --persistent flag
      extensions: remove redundant casts
      extensions: switch numeric to bool
      libxt_helper: fix invalid passed option to check_inverse
      extensions: switch invert to bool
      extensions: switch parse() return type to bool
      extensions: add const qualifiers in print/save functions
      iptables: replace open-coded sizeof by ARRAY_SIZE
   
Michael Granzow (1):
      iptables: accept multiple IP address specifications for -s, -d

