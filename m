From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] xt_recent: use proc_create_data()
Date: Thu, 16 Oct 2008 15:12:30 +0200
Message-ID: <48F73DBE.5040808@trash.net>
References: <20081015041326.GB24058@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33672 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYJPNMe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:12:34 -0400
In-Reply-To: <20081015041326.GB24058@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> It's tiny little bit safer because ->data always appears initialized.

These don't seem to actually fix anything, so please also resend
once net-next is open again.
