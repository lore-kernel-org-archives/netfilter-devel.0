From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: xt_bpf: support ebpf
Date: Mon, 5 Dec 2016 18:01:20 -0500
Message-ID: <CAF=yD-JN+u_Qk25Qp79_1UxM1x77sjyHV4oe47BN1w9AsuMtGA@mail.gmail.com>
References: <1480969684-74414-1-git-send-email-willemdebruijn.kernel@gmail.com>
 <5845F060.2050700@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34460 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcLEXCB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Dec 2016 18:02:01 -0500
In-Reply-To: <5845F060.2050700@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 5, 2016 at 5:55 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> Hi Willem,
>
> On 12/05/2016 09:28 PM, Willem de Bruijn wrote:
>>
>> From: Willem de Bruijn <willemb@google.com>
>>
>> Add support for attaching an eBPF object by file descriptor.
>>
>> The iptables binary can be called with a path to an elf object or a
>> pinned bpf object. Also pass the mode and path to the kernel to be
>> able to return it later for iptables dump and save.
>>
>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>
>
> just out of pure curiosity, use case is for android guys wrt
> accounting, or anything specific that cls_bpf on tc ingress +
> egress cannot do already?

That is the immediate motivation, yes.
