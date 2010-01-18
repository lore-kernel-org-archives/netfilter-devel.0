From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] #ifdef ->iptable_security, ->ip6table_security
Date: Mon, 18 Jan 2010 08:09:06 +0100
Message-ID: <4B540912.4080401@trash.net>
References: <20100116180417.GA9527@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47561 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab0ARHJJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:09:09 -0500
In-Reply-To: <20100116180417.GA9527@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> 'security' tables depend on SECURITY, so ifdef them.

Applied, thanks.
