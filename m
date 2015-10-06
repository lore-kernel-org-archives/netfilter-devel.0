From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH v3] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Tue, 6 Oct 2015 08:36:36 +0700
Message-ID: <CAMQP0skaxXXQGYhGe5tq772yEC4HC2hULwG6AKeDKajYV=THzg@mail.gmail.com>
References: <20151005173655.GA15088@oxygen>
	<alpine.LSU.2.20.1510052045420.11268@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35472 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbbJFBgh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 21:36:37 -0400
Received: by ioiz6 with SMTP id z6so205732251ioi.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2015 18:36:37 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.20.1510052045420.11268@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 6, 2015 at 1:46 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Monday 2015-10-05 19:36, Neutron Soutmun wrote:
>>  Drop the EXPORT_SYMBOL() tags also fix the failed to build with
>>  clang.
>
>>-CHECK_GCC_FVISIBILITY
>
> We should be able to also drop the m4 code behind CHECK_GCC_FVISIBILITY
> (I remember writing that, and so it's not something autoconf would
> provide on its own.)

Dropped m4/gcc4_visibility.m4 and also clean up the Make_global.am for
${GCC_FVISIBILITY_HIDDEN}

Please review again [1] - [PATCH v4] libmnl: Drop the EXPORT_SYMBOL() tags

Best regards,
Neutron Soutmun

[1] https://marc.info/?l=netfilter-devel&m=144409492019105&w=2
