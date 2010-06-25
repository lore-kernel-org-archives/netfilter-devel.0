From: Tim Gardner <tim.gardner@canonical.com>
Subject: nf-next-2.6 pull request, Complete deprecation of CONFIG_NF_CT_ACCT (V4)
Date: Fri, 25 Jun 2010 06:31:30 -0600
Message-ID: <1277469092-6247-1-git-send-email-tim.gardner@canonical.com>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2446 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab0FYMcE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:32:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The first patch adds some functionality to CT accounting that allows xt_connbytes
to check and/or enable CT accounting, a feature upon which the filter depends. CT
accounting is currently enforced by a 'SELECT CONFIG_NF_CT_ACCT' in the 
xt_connbytes Kconfig entry.

All this in preparation for deprecating CONFIG_NF_CT_ACCT which happens
in the second patch.

