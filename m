From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nf-next PATCH] netfilter: nf_conntrack_proto_tcp: propagate
 IP_CT_TCP_FLAG_BE_LIBERAL
Date: Fri, 21 Oct 2016 11:56:45 +0200
Message-ID: <20161021095645.GA17871@salvia>
References: <147695370184.31999.2434286995020619745.stgit@nfdev2.cica.es>
 <20161020181424.GA10898@salvia>
 <CAOkSjBj-Tyc90ph8-tEt9Ux07ZeCRBETnBNVCyL9RLXiByUHhA@mail.gmail.com>
 <CALFfGYaW3vaMmJ==gXqUATsmu5BWwZx8Aee8G8KknmVTySWrng@mail.gmail.com>
 <CAOkSjBg0TE_LjA4xYnbRvf=BzRP8xGvJK+xOWDURHnqAmjCJSQ@mail.gmail.com>
 <CALFfGYZa4H6aNK9_BgAj8M2cNTsWuXPhnpNah7Q7p2dDnp78AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
        netfilter-devel@vger.kernel.org
To: Mathew Heard <mat999@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52350 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753849AbcJUJ4v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 05:56:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1F2C25D28
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 11:56:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F21BDA81B
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 11:56:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76C91DA84C
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 11:56:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CALFfGYZa4H6aNK9_BgAj8M2cNTsWuXPhnpNah7Q7p2dDnp78AA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 21, 2016 at 06:26:28PM +1100, Mathew Heard wrote:
> However under testing, in practice is not. As covered in the bug.
> 
> Fields: CTA_IP_V4_DST, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL &
> CTA_PROTOINFO_TCP_FLAGS_REPLY
> Result: "**.**.56.135: 10 3"

>From where are you printing this? userspace or kernel?

> It's only being set on one side. I believe this is because the reply
> side flags are being set/initialised after the fact (i.e where they
> are initialised in that function for incoming connections would do it
> too).

Please develop this a bit more.

Is there anything we should know on your infrastructure? eg. kernel
and library version, what architecture you using?

Asking this because I found an old report on problems on ARM that the
submitter never confirmed to be fixed.

Thanks.
