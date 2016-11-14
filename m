From: David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH] netfilter: Update ip_route_me_harder to consider L3
 domain
Date: Mon, 14 Nov 2016 16:04:26 -0700
Message-ID: <6698ac14-9706-88b3-ed1f-0ec47c64fb48@cumulusnetworks.com>
References: <1478715880-18952-1-git-send-email-dsa@cumulusnetworks.com>
 <20161114225920.GA9221@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34269 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934108AbcKNXL5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 18:11:57 -0500
Received: by mail-pf0-f169.google.com with SMTP id c4so19977577pfb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 15:11:57 -0800 (PST)
In-Reply-To: <20161114225920.GA9221@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/14/16 3:59 PM, Pablo Neira Ayuso wrote:
> Does ip6_route_me_harder need an update too?

I have not hit a use case yet. Rather than blindly going through and adding l3mdev hooks I would like to tie the changes to known uses cases.
