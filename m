From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] addrtype match: added revision 1
Date: Fri, 06 Jun 2008 14:18:41 +0200
Message-ID: <48492B21.2090509@trash.net>
References: <> <1212753710-22423-1-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42973 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYFFMSo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:18:44 -0400
In-Reply-To: <1212753710-22423-1-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laszlo Attila Toth wrote:
> In revision 1 address type checking can be limited to either the incoming
> or outgoing interface depending on the current chain. In the FORWARD chain
> only one of them is allowed at the same time.
> 
> Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>

Applied, thanks.
