From: Mathew Heard <mat999@gmail.com>
Subject: Re: [RFC nf-next PATCH] netfilter: nf_conntrack_proto_tcp: propagate IP_CT_TCP_FLAG_BE_LIBERAL
Date: Fri, 21 Oct 2016 21:15:18 +1100
Message-ID: <CALFfGYY0PNHwhNsh_71_pGMX=LrpE9c4tcLZaCLS8SZsCRF-vQ@mail.gmail.com>
References: <147695370184.31999.2434286995020619745.stgit@nfdev2.cica.es>
 <20161020181424.GA10898@salvia> <CAOkSjBj-Tyc90ph8-tEt9Ux07ZeCRBETnBNVCyL9RLXiByUHhA@mail.gmail.com>
 <CALFfGYaW3vaMmJ==gXqUATsmu5BWwZx8Aee8G8KknmVTySWrng@mail.gmail.com>
 <CAOkSjBg0TE_LjA4xYnbRvf=BzRP8xGvJK+xOWDURHnqAmjCJSQ@mail.gmail.com>
 <CALFfGYZa4H6aNK9_BgAj8M2cNTsWuXPhnpNah7Q7p2dDnp78AA@mail.gmail.com> <20161021095645.GA17871@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36765 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbcJUKPj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 06:15:39 -0400
Received: by mail-it0-f66.google.com with SMTP id 66so10345692itl.3
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 03:15:39 -0700 (PDT)
In-Reply-To: <20161021095645.GA17871@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 21, 2016 at 8:56 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Oct 21, 2016 at 06:26:28PM +1100, Mathew Heard wrote:
>> However under testing, in practice is not. As covered in the bug.
>>
>> Fields: CTA_IP_V4_DST, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL &
>> CTA_PROTOINFO_TCP_FLAGS_REPLY
>> Result: "**.**.56.135: 10 3"
>
> From where are you printing this? userspace or kernel?
>

CTA_* comes from libnetfilter_conntrack, which is userspace.

I have however also printk'ed flags in the kernel during testing and
seen the same (further confirmed by the crude fix working).

>> It's only being set on one side. I believe this is because the reply
>> side flags are being set/initialised after the fact (i.e where they
>> are initialised in that function for incoming connections would do it
>> too).
>
> Please develop this a bit more.
>
> Is there anything we should know on your infrastructure? eg. kernel
> and library version, what architecture you using?
>
> Asking this because I found an old report on problems on ARM that the
> submitter never confirmed to be fixed.
>
> Thanks.

AMD64 in both native (staging) and virtual (dev) environments.

Originally we found this issue with incoming connections, however due
to it being simpler to test I moved to testing outgoing.

I hope this ASCII diagram survives the mail system. Test System:

[NAT Router A]  -----
         |                    \_____
    Conntrackd          ______ Target Box
         |                   /
[NAT Router B] ------

Target box connected via GRE (internal network range 10.x.x.x). Router
A and B both with standard DNAT & SNAT rules to provide connectivity &
port forwards. To test, I just change the route of an outgoing
connection from Target Box on Target Box mid connection (i.e via using
"ip rule")

With TCP window tracking disabled using sysctl's, or with the crude
patch this all works as expected.
Without the patch, due to the tcp flags of the reply side not
containing the correct flags, it does not.

Inbound testing was tested similarly, but by moving BGP announcements
between routers.

I have also replicated the same results in our staging environment but
thats substantially more complex.

Regards,
Mathew
