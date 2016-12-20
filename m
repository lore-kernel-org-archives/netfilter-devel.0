From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: Feature request: Load u32 value into packet mark
Date: Tue, 20 Dec 2016 13:17:56 +0100
Message-ID: <CAOkSjBhT-dyAcgajjiwo3cWLFDkKfaEO7hrbTt174PGVgrN5BA@mail.gmail.com>
References: <4ea9be0e2a17475485a0b3e6bccc19d3@aalto.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Llorente Santos Jesus <jesus.llorente.santos@aalto.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38742 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763173AbcLTMSS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 07:18:18 -0500
Received: by mail-it0-f52.google.com with SMTP id x2so21504193itf.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 04:18:17 -0800 (PST)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com. [209.85.223.175])
        by smtp.gmail.com with ESMTPSA id e68sm10172593ioj.39.2016.12.20.04.18.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Dec 2016 04:18:16 -0800 (PST)
Received: by mail-io0-f175.google.com with SMTP id h30so177556017iod.2
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 04:18:16 -0800 (PST)
In-Reply-To: <4ea9be0e2a17475485a0b3e6bccc19d3@aalto.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 December 2016 at 12:24, Llorente Santos Jesus
<jesus.llorente.santos@aalto.fi> wrote:
> Hi,
>
> I have been playing quite a bit with iptables lately. Ever since the ipset was updated to support hash:ip,mark sets, there has been the potential to apply efficient matching on packet marks.
> Does it make any sense to you to develop a new extension that following U32 and MARK syntax would allow us to read a 32bit value  and load it onto the packet mark ?

It guess what makes sense is to switch to nftables :-)
