From: Aft nix <aftnix@gmail.com>
Subject: Re: no extension found for this protocol
Date: Mon, 24 Sep 2012 19:03:14 +0600
Message-ID: <CAGuaRCu2tFRhg2euL7UFKQmHzKAUFpZ90aa2nOs7niGeKJaMqg@mail.gmail.com>
References: <CAGuaRCvtBG4dn70f=gjkB_ep7LDtWn_eHZJ+2PVtU2sikS94AQ@mail.gmail.com>
	<alpine.LNX.2.01.1209241431310.12534@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54559 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2IXNDP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:03:15 -0400
Received: by ieak13 with SMTP id k13so10707050iea.19
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Sep 2012 06:03:14 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1209241431310.12534@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 24, 2012 at 6:32 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> On Monday 2012-09-24 13:12, Aft nix wrote:
>
>>Hi,
>>
>>I've added a target extension. The kernel module(xt_*.ko)  and  the
>>userspace plugin(libxt_*.so) are there. But when
>>i try to invoke the rule, it gives me "No extension found for this protocol".
>>
>>What am i doing wrong here?
>
> You forgot to FedEx a magic glass sphere to me...

Fair enough.

But i'm confused which debug information is useful here. Both *.ko and
*.so files
are in place. iptables --version states 1.4.15(Actually the libxt_*.c
is included "in tree". i've just
checked out v1.4.15 tag from git tree and added libxt_*.c and xt_*.h)

kernel version is also misleading. Its modified with 3.5.0 taken as base.

Please help me out with which information you need to understand the phenomenon.

cheers.


-- 
-aft
