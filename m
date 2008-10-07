From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/23] netfilter: xtables: do centralized checkentry call
 (1/2)
Date: Tue, 07 Oct 2008 15:03:41 +0200
Message-ID: <48EB5E2D.5000907@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45111 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbYJGNDt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:03:49 -0400
In-Reply-To: <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> It used to be that {ip,ip6,etc}_tables called extension->checkentry
> themselves, but this can be moved into the xtables core.

Applied, thanks.
