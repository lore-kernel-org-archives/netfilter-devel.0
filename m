From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: remove CONFIG_NF_CT_ACCT
Date: Fri, 06 Nov 2009 15:57:14 +0100
Message-ID: <4AF4394A.2070807@trash.net>
References: <4AF3E5A3.1080805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Krzysztof Piotr Oledzki <ole@ans.pl>
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63952 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZKFO5L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 09:57:11 -0500
In-Reply-To: <4AF3E5A3.1080805@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> remove CONFIG_NF_CT_ACCT
> 
> Accounting can now be enabled/disabled without kernel recompilation.
> Currently used only to set a default value for a feature that is also
> controlled by a kernel/module/sysfs/sysctl parameter.

We need to automatically enable this when the connbytes match is used.
Krzysztof is working on a patch to do that.
