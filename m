From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 22/23] netfilter: xtables: use NFPROTO_UNSPEC in more
 extensions
Date: Wed, 08 Oct 2008 11:26:31 +0200
Message-ID: <48EC7CC7.7020607@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <13992bcb338f0044010a1809f24d2198b5bd91c8.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43653 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbYJHJ0i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:26:38 -0400
In-Reply-To: <13992bcb338f0044010a1809f24d2198b5bd91c8.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Lots of extensions are completely family-independent, so squash some code.

Applied, thanks.
