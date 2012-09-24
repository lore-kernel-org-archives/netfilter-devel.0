From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: no extension found for this protocol
Date: Mon, 24 Sep 2012 16:03:01 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209241602480.19065@nerf07.vanv.qr>
References: <CAGuaRCvtBG4dn70f=gjkB_ep7LDtWn_eHZJ+2PVtU2sikS94AQ@mail.gmail.com> <alpine.LNX.2.01.1209241431310.12534@nerf07.vanv.qr> <CAGuaRCu2tFRhg2euL7UFKQmHzKAUFpZ90aa2nOs7niGeKJaMqg@mail.gmail.com> <alpine.LNX.2.01.1209241506300.17187@nerf07.vanv.qr>
 <CAGuaRCub-iGfVvAQZNErFQQMcV2NoMM_DMzU1CtbMD60EF3npg@mail.gmail.com> <alpine.LNX.2.01.1209241528230.18274@nerf07.vanv.qr> <CAGuaRCuk57_ZddVXU9ndOLsNjwACeX0tvCLg5UvA+OYzyANFww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34651 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab2IXODD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:03:03 -0400
In-Reply-To: <CAGuaRCuk57_ZddVXU9ndOLsNjwACeX0tvCLg5UvA+OYzyANFww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2012-09-24 15:49, Aft nix wrote:

>On Mon, Sep 24, 2012 at 7:28 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>>
>> On Monday 2012-09-24 15:14, Aft nix wrote:
>>>>
>>>> Specify the command you ran, and the _exact_ error message. There is
>>>> no "No extension found for this protocol" string anywhere in the code
>>>> to spot.
>>>$iptables -t mangle -A PREROUTING -p udp --dport 9090 -j OBSF --key
>>>"abc" --enc-type "arc4" --enc
>>>$/usr/local/lib/xtables/libxt_OBSF.so : no "OBSF" extension found for
>>>this protocol.
>>>$iptables v1.4.15: unknown option "--key"
>>
>> (in libxt_OBSF.c): You do not have a _init function that actually
>> registers obsf_target.
>
>libxt_OBSF.c :
>
>static void __init(void)
>{
>	xtables_register_target(&obsf_target);
>}
>
>I do have a __init function.

And that's the problem. I said _init, not __init.
