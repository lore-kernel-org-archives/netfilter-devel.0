From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] TCP conntrack reopening fix (stable branch)
Date: Tue, 19 Feb 2008 16:08:34 +0100
Message-ID: <47BAF0F2.2010901@trash.net>
References: <Pine.LNX.4.64.0802052250560.3630@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep31-int.chello.at ([62.179.121.49]:51399 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYBSPIv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:08:51 -0500
In-Reply-To: <Pine.LNX.4.64.0802052250560.3630@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> Hi Patrick,
> 
> And here is the patch against the stable branch:
> 
> TCP connection tracking in netfilter did not handle TCP reopening
> properly: active close was taken into account for one side only and
> not for any side, which is fixed now. The patch includes more comments
> to explain the logic how the different cases are handled.
> The bug was discovered by Jeff Chua.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks.
