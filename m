From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: no extension found for this protocol
Date: Mon, 24 Sep 2012 15:07:51 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209241506300.17187@nerf07.vanv.qr>
References: <CAGuaRCvtBG4dn70f=gjkB_ep7LDtWn_eHZJ+2PVtU2sikS94AQ@mail.gmail.com> <alpine.LNX.2.01.1209241431310.12534@nerf07.vanv.qr> <CAGuaRCu2tFRhg2euL7UFKQmHzKAUFpZ90aa2nOs7niGeKJaMqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34316 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab2IXNHw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:07:52 -0400
In-Reply-To: <CAGuaRCu2tFRhg2euL7UFKQmHzKAUFpZ90aa2nOs7niGeKJaMqg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-09-24 15:03, Aft nix wrote:
>On Mon, Sep 24, 2012 at 6:32 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>> On Monday 2012-09-24 13:12, Aft nix wrote:
>>
>>>Hi,
>>>
>>>I've added a target extension. The kernel module(xt_*.ko)  and  the
>>>userspace plugin(libxt_*.so) are there. But when
>>>i try to invoke the rule, it gives me "No extension found for this protocol".
>>>
>>>What am i doing wrong here?
>>
>> You forgot to FedEx a magic glass sphere to me...
>
>But i'm confused which debug information is useful here. Both *.ko and
>*.so files are in place. iptables --version states 1.4.15(Actually the
>libxt_*.c is included "in tree". i've just checked out v1.4.15 tag
>from git tree and added libxt_*.c and xt_*.h)
>
>Please help me out with which information you need to understand the
>phenomenon.

Specify the command you ran, and the _exact_ error message. There is
no "No extension found for this protocol" string anywhere in the code
to spot.
