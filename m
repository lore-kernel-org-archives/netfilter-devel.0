From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] bump version to 1.0.3
Date: Wed, 21 Jun 2017 23:20:36 +0200
Message-ID: <8c83afe4-3947-13cb-0bbd-973ac8ef960f@nod.at>
References: <20170621211846.20630-1-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752462AbdFUVUk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 17:20:40 -0400
In-Reply-To: <20170621211846.20630-1-richard@nod.at>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 21.06.2017 um 23:18 schrieb Richard Weinberger:
> Time to make a new version such that distros can pick this version.
> Many distros ship only 1.0.2 which is almost five years old and
> does not support recent netfilter features such as NFQA_CT.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
> Hi!
> 
> As discussed with Florian on IRC, it is time for a new version.
> I think we don't have to change the API version, so just increment
> the release version.
> 
> Thanks,
> //richard

Meh, forgot to mention that this is for libnetfilter_queue...

Thanks,
//richard
