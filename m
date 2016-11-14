From: David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH] netfilter: Update ip_route_me_harder to consider L3
 domain
Date: Mon, 14 Nov 2016 16:53:12 -0700
Message-ID: <a6ae84a7-b923-e989-321f-88cdce4fe088@cumulusnetworks.com>
References: <1478715880-18952-1-git-send-email-dsa@cumulusnetworks.com>
 <20161114225920.GA9221@salvia>
 <6698ac14-9706-88b3-ed1f-0ec47c64fb48@cumulusnetworks.com>
 <20161114234817.GA9609@salvia> <20161114234942.GA9640@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:34557 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965449AbcKNXxP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 18:53:15 -0500
Received: by mail-pg0-f41.google.com with SMTP id x23so56578904pgx.1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 15:53:14 -0800 (PST)
In-Reply-To: <20161114234942.GA9640@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/14/16 4:49 PM, Pablo Neira Ayuso wrote:
> On Tue, Nov 15, 2016 at 12:48:17AM +0100, Pablo Neira Ayuso wrote:
>> Hi David,
>>
>> On Mon, Nov 14, 2016 at 04:04:26PM -0700, David Ahern wrote:
>>> On 11/14/16 3:59 PM, Pablo Neira Ayuso wrote:
>>>> Does ip6_route_me_harder need an update too?
>>>
>>> I have not hit a use case yet. Rather than blindly going through and
>>> adding l3mdev hooks I would like to tie the changes to known uses
>>> cases.
>>
>> Hm, your follow up patch updates nf_send_reset6() but not
>> nf_send_reset(). Sorry but it strikes me as inconsistent that some
>> spots are updated and some others are not.
> 
> What usecases you have in mind, btw? I can help testing other
> scenarios and fix other spots too if it makes sense to do it in one
> go.
> 

As mentioned in the commit message, both this one and the IPV6 one get the REJECT target working for tcp-reset:

iptables -I OUTPUT -p tcp --dport 12345 -j REJECT --reject-with tcp-reset

ip6tables -A OUTPUT -p tcp --dport 12345 -j REJECT --reject-with tcp-reset


