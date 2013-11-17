From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCh 0/3] Fix jump operation
Date: Mon, 18 Nov 2013 00:54:42 +0100
Message-ID: <1384732485-12944-1-git-send-email-eric@regit.org>
References: <DUB109-W87FE1E5161E5C42ED6593AE1F80@phx.gbl>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	Alex Chapman <ajchapman88@hotmail.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:42595 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KRARt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:17:49 -0500
In-Reply-To: <DUB109-W87FE1E5161E5C42ED6593AE1F80@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

The jump operation was not correctly working in nftables. This
small patchset fixes the issue.

BR,
--
Eric
