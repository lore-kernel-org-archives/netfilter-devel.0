From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] TCP conntrack reopening fix
Date: Wed, 06 Feb 2008 02:50:53 +0100
Message-ID: <47A9127D.7040104@trash.net>
References: <Pine.LNX.4.64.0802052250370.3630@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40057 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793AbYBFBva (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:51:30 -0500
In-Reply-To: <Pine.LNX.4.64.0802052250370.3630@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> Hi Patrick,
>
> Here is the patch against the newest git version:
>
> TCP connection tracking in netfilter did not handle TCP reopening 
> properly: active close was taken into account for one side only and 
> not for any side, which is fixed now. The patch includes more comments
> to explain the logic how the different cases are handled.
> The bug was discovered by Jeff Chua.
>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks for fixing this.

