From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: fix nflog timeout handling
Date: Mon, 09 Feb 2009 18:37:51 +0100
Message-ID: <499069EF.5010104@trash.net>
References: <1233354708-22009-1-git-send-email-eric@inl.fr> <1233354708-22009-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60248 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZBIRhy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:37:54 -0500
In-Reply-To: <1233354708-22009-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> NFLOG timeout was computed in timer by doing:
>  flushtimeout*HZ/100
> Default value of flushtimeout was HZ (for 1 second delay). This was
> wrong for non 100HZ computer.
> 
> This patch modifies the delay computation by using:
>  flushtimeout*HZ/1000
> delay and set default value of flushtimeout to 1000 (as 1/100 sec is not
> a common unit).

I think we should adjust the default instead as that doesn't
affect the units exposed to userspace (which is 10ms).


