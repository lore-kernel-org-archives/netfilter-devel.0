From: Artur Molchanov <arturmolchanov@gmail.com>
Subject: Re: [PATCH] net/bridge: Fix dropping packets that moving through
 bridge interface
Date: Thu, 5 Jan 2017 10:11:45 +0300
Message-ID: <63ae7ead-9fcb-4030-4b2e-69229a8c0265@gmail.com>
References: <947bdfc8-07f1-f909-2328-85af084de741@gmail.com>
 <20161230165811.GA1403@breakpoint.cc> <20161230172207.GA22162@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35366 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753267AbdAEHLm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 02:11:42 -0500
Received: by mail-lf0-f65.google.com with SMTP id x140so32451373lfa.2
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jan 2017 23:11:41 -0800 (PST)
In-Reply-To: <20161230172207.GA22162@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

30.12.2016 20:22, Pablo Neira Ayuso wrote:

> On Fri, Dec 30, 2016 at 05:58:11PM +0100, Florian Westphal wrote:
>> Artur Molchanov <arturmolchanov@gmail.com> wrote:
>>> From: Artur Molchanov <artur.molchanov@synesis.ru>
>>>
>>> Fixes: c5136b15ea36 ("netfilter: bridge: add and use br_nf_hook_thresh")
>>>
>>> Problem:
>>> br_nf_pre_routing_finish() calls itself instead of
>>> br_nf_pre_routing_finish_bridge().
>>> Due to this bug reverse path filter drops packets that moving through
>>> bridge interface.
>> Indeed, thanks for fixing this!
> Applied, thanks everyone.

When the fix will be available in upstream?
