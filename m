From: Victor Julien <victor@inliniac.net>
Subject: [ulogd2] lower netfilter library requirements
Date: Fri,  5 Apr 2013 16:33:54 +0200
Message-ID: <1365172437-15042-1-git-send-email-victor@inliniac.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:39534 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161562Ab3DEOqZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:46:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Currently ulogd2 requires pretty much the latest versions of the
netfilter libraries. This seems to be unnecessary.

