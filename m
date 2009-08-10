From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 008/103] netfilter: xtables: remove obsolete /proc/net/ipt_recent
Date: Mon, 10 Aug 2009 10:46:47 +0200
Message-ID: <4A7FDE77.5070306@trash.net>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <1249370787-17583-9-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZHJIqu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:46:50 -0400
In-Reply-To: <1249370787-17583-9-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The directory has been superseded by /proc/net/xt_recent
> (v2.6.27-rc8-889-g079aa88).

It has been superseeded for not even a year now, I'd say its too
early to remove it.
