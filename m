From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/6] netfilter: xtables: mark initial tables constant
Date: Mon, 24 Aug 2009 14:57:06 +0200
Message-ID: <4A928E22.6040504@trash.net>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de> <1249931992-18761-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51437 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZHXM5I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:57:08 -0400
In-Reply-To: <1249931992-18761-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The inputted table is never modified, so should be considered const.

Applied, thanks.
