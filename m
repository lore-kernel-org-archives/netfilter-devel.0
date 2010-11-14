From: Kfir Lavi <lavi.kfir@gmail.com>
Subject: Re: Verdict with ebtables?
Date: Sun, 14 Nov 2010 13:56:44 +0200
Message-ID: <AANLkTinobDP53eegFuhaQCds4TOb98YHWibf9P7L7_D4@mail.gmail.com>
References: <AANLkTinCazaFKSXnfGe2e0nnfeRorV7AHcadQaxGvWg+@mail.gmail.com>
	<AANLkTikxkvB2pagQswH1S8=sxA+OVfWrqO45FD6+hDQE@mail.gmail.com>
	<4CDBC9E9.2010508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55845 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab0KNL4p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Nov 2010 06:56:45 -0500
Received: by wwb29 with SMTP id 29so396929wwb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2010 03:56:44 -0800 (PST)
In-Reply-To: <4CDBC9E9.2010508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 11, 2010 at 12:48 PM, Patrick McHardy <kaber@trash.net> wrote:
>
> On 11.11.2010 11:05, Kfir Lavi wrote:
> > Hi,
> > It seems to me that its not possible to do a verdict in userspace of
> > ethernet packets, like it is done with nfqueue and iptables.
> > Why it is not implemented?
>
> Nobody ever implemented it. IIRC the main problem is that under
> certain circumstances the packets need to be passed back to
> __netif_receive_skb() when queuing in LOCAL_IN, which isn't
> possible from the completion handler.

Thanks Patrick for your replay.
Can you explain why it's not possible to pass packets back?
Also, why should packets need to be sent back?

Thanks,
Kfir
