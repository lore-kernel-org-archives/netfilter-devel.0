From: tingwei liu <tingw.liu@gmail.com>
Subject: Re: NFQUEUE in bridge mode performance poor in the last kernels
Date: Wed, 7 Mar 2012 09:26:33 +0800
Message-ID: <CA+qZnSQF1yDyvKvg0PUAvOhT3JSOK7fzf1bV6y=zRdmKQMZDkA@mail.gmail.com>
References: <CA+qZnSTG+_5y=6dGFqoJwRj0LxMvr2qtmyvykFjfnVgaYgbNPA@mail.gmail.com>
	<20120306212337.GA19133@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47363 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031740Ab2CGB0e convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:26:34 -0500
Received: by obbuo6 with SMTP id uo6so6178259obb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Mar 2012 17:26:33 -0800 (PST)
In-Reply-To: <20120306212337.GA19133@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 7, 2012 at 5:23 AM, Florian Westphal <fw@strlen.de> wrote:
> tingwei liu <tingw.liu@gmail.com> wrote:
>> In the past few days, I have puzzled by NFQUEUE in bridge mode.
>> I have take some test with five kernels.
>> 2.6.24.4
>> 2.6.36.4
>> 2.6.38
>> 3.0.8
>> 3.1.10
>>
>> The result is : 2.6.24.4,2.6.26.4,2.6.38 have a goog performance;
>> 3.0.8 and 3.1.10 have a poor performance.
>> Next is copy from suricata maillist(=C2=A0eric@regit.org=C2=A0)
>>
>> I'm having a look at it. There has been some changes between the two
>> kernel versions (bringing more performances) but it seems there is s=
ome
>> side effects with bridge.
>
> Might be the 'gro+nfqueue eats MAC header' problem, you could try
> commit a8db7b2d197a0d624baab83f0c810b0edbc4ffd0 (netfilter: nf_queue:=
 fix
> queueing of bridged gro skbs). Or, disable gro on all bridge ports vi=
a
> ethtool -K $device gro off
>
I have test it.You are right.Now it is time to learn why the gro effect=
s it.
Thanks very much.
> If its not gro related, please provide more information about your
> machine, setup, ... etc.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
