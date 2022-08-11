Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A71C19F2A
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Aug 2022 11:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiHKLcr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Aug 2022 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiHKLcV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Aug 2022 07:32:21 -0400
X-Greylist: delayed 1114 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Aug 2022 04:31:50 PDT
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445D06582A
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2022 04:31:50 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4M3PLK4vr1zY0y;
        Thu, 11 Aug 2022 13:13:13 +0200 (CEST)
Message-ID: <41eaef5f-a7b0-7ff6-ad97-5a3901b8bfe0@thelounge.net>
Date:   Thu, 11 Aug 2022 13:13:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Upgrading iptables firewall on Red Hat Enterprise Linux 9.0
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>,
        Turritopsis Dohrnii Teo En Ming <tdtemccna@gmail.com>,
        netfilter-devel@vger.kernel.org, ceo@teo-en-ming-corp.com
References: <CACsrZYbEL+rdWL89cMD4LZT=MQOOoruTOCYYjHM+yeaXzv-YLw@mail.gmail.com>
 <YvTd+VWCXk/MVvYb@orbyte.nwl.cc>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <YvTd+VWCXk/MVvYb@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 11.08.22 um 12:46 schrieb Phil Sutter:
> Hi,
> 
> On Thu, Aug 11, 2022 at 03:49:41PM +0800, Turritopsis Dohrnii Teo En Ming wrote:
>> Subject: Upgrading iptables firewall on Red Hat Enterprise Linux 9.0
>>
>> Good day from Singapore,
>>
>> The following RPM packages are installed on my Red Hat Enterprise
>> Linux 9.0 virtual machine.
>>
>> iptables-libs-1.8.7-28.el9.x86_64
>> iptables-nft-1.8.7-28.el9.x86_64
>>
>> Is it possible to upgrade iptables firewall to the latest version 1.8.8?
> 
> Of course, just download iptables tarball from netfilter.org[1] and
> compile it yourself! ;)

besides that it's a terrible idea to randomly overwrite  distro files 
one should have explained the OP that the actual firewall lives in the 
kernel

so this update is pretty pointless unless you have to fix a specific 
problem in the userland component
