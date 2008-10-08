From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 21/23] netfilter: xtables: cut down on static data for
 family-independent extensions
Date: Wed, 08 Oct 2008 11:25:53 +0200
Message-ID: <48EC7CA1.9000806@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <5f5447e4a742a69c6222caced36ba693b4c335df.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43633 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbYJHJ0A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:26:00 -0400
In-Reply-To: <5f5447e4a742a69c6222caced36ba693b4c335df.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Using ->family in struct xt_*_param, multiple struct xt_{match,target}
> can be squashed together.

Applied, thanks.
