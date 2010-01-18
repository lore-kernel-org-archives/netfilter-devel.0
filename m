From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: simplify warning message
Date: Mon, 18 Jan 2010 08:53:59 +0100
Message-ID: <4B541397.6010708@trash.net>
References: <1263593151-20651-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48280 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0ARHyC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:54:02 -0500
In-Reply-To: <1263593151-20651-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch remove variable part from a debug message to have
> message concatenation from syslog.

It also makes the message less informative, but OK, this information
is not particulary important and available through proc anyways.

But I do need a Signed-off-by: line :)

