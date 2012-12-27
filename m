From: Eric Leblond <eric@regit.org>
Subject: Re: [libnetfilter_acct PATCH] Fix packets and bytes inversion.
Date: Thu, 27 Dec 2012 09:18:53 +0100
Message-ID: <1356596333.1102.0.camel@tiger2>
References: <1356561052-32655-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45140 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2L0IT2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 03:19:28 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=[192.168.1.128])
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1To8gZ-0004yt-QK
	for netfilter-devel@vger.kernel.org; Thu, 27 Dec 2012 09:19:27 +0100
In-Reply-To: <1356561052-32655-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, 2012-12-26 at 23:30 +0100, Eric Leblond wrote:
> Pkts and bytes are inversed in some part of the code. This patch
> fixes most of the occurence of this problem.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  src/libnetfilter_acct.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Pushed to Netfilter's git.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

