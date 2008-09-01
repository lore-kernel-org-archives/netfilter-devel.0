From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Missing limits.h includes
Date: Mon, 01 Sep 2008 15:08:06 +0200
Message-ID: <48BBE936.7050007@trash.net>
References: <20080819153750.GB13246@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34675 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYIANII (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:08:08 -0400
In-Reply-To: <20080819153750.GB13246@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> Latest git doesn't compile for me on Fedora 9 due to various *MAX constants
> being undefined.  Below adds the include in 3 files which need it (although
> I can't see why this isn't required in 1.4.1.1).

Applied, thanks.
