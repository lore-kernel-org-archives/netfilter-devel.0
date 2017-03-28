From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH 2/4] netfilter: ipset: generalize netmask to support cidr
 and mask values
Date: Tue, 28 Mar 2017 07:35:52 -0500
Message-ID: <e813c815-6803-6268-2bc0-cfe28f128093@akamai.com>
References: <1490120944-1770-1-git-send-email-johunt@akamai.com>
 <1490120944-1770-3-git-send-email-johunt@akamai.com>
 <alpine.DEB.2.11.1703272110580.16553@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:47114 "EHLO
        prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752859AbdC1MgV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 08:36:21 -0400
In-Reply-To: <alpine.DEB.2.11.1703272110580.16553@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/27/2017 02:21 PM, Jozsef Kadlecsik wrote:
> Hi Josh,
>
> Overall, I like the feature and the patches. After reviewing I comment
> only the parts where I believe some modifications are needed.
>

Jozsef

Thanks for the review. I'll go through this and send a v2 in the next 
few days.

Josh
