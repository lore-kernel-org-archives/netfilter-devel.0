From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 20/23] netfilter: xtables: provide invoked family value
 to extensions
Date: Wed, 08 Oct 2008 11:25:05 +0200
Message-ID: <48EC7C71.7040904@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <79f8fcf64eb5718d8597cee7007121bd70f28496.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43612 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYJHJZM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:25:12 -0400
In-Reply-To: <79f8fcf64eb5718d8597cee7007121bd70f28496.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> By passing in the family through which extensions were invoked, a bit
> of data space can be reclaimed. The "family" member will be added to
> the parameter structures and the check functions be adjusted.

Makes sense in combination with NFPROTO_UNSPEC.

Applied. thanks.
