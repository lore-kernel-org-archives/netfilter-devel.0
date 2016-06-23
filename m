From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH] ipset: Backports for the nla_put_net64() API changes
Date: Thu, 23 Jun 2016 18:41:45 +0700
Message-ID: <CAMQP0smTrOCvq6nXH3u5VLfLdj1nf7_D6760RCmCUx6DfrynNA@mail.gmail.com>
References: <20160623102211.GA31272@hydrogen> <20160623103744.GA10764@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35389 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbcFWLlr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 07:41:47 -0400
Received: by mail-yw0-f193.google.com with SMTP id v77so10547683ywg.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 04:41:46 -0700 (PDT)
In-Reply-To: <20160623103744.GA10764@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 23, 2016 at 5:37 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jun 23, 2016 at 05:22:11PM +0700, Neutron Soutmun wrote:
>> * Backports the patch "libnl: nla_put_net64():align on a 64-bit area" [1]
>>   by Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>
>> * Since the nla_put_net64() API has been changed, therefore, the
>>   ip_set_compat.h.in should provides the macro IPSET_NLA_PUT_NET64 that
>>   point to the nla_put_net64() with appropriate number of arguments.
>>
>>   The build script should distinguish the API changes by detect for
>>   the existence of nla_put_64bit() function in include/net/netlink.h.
>>   This function was added in the same patches set and called by
>>   the nla_put_be64() that called by nla_put_net64() respectively.
>
> What are you specifically fixing with this?

Sorry that the patch is not clear the point.
This patch is on top of the ipset master branch, http://git.netfilter.org/ipset,
which I face a problem to build the latest ipset kernel module against
the linux-4.7~rc4-1~exp1 (Debian Experimental).

Therefore, I have backported the patch from mainline and prepared the
macro for backward compatible which
the ipset kernel module could be compiled with earlier kernel version (< 4.7)

Best regards,
Neutron Soutmun
