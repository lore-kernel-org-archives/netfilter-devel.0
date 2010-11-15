From: Patrick McHardy <kaber@trash.net>
Subject: Re: Verdict with ebtables?
Date: Mon, 15 Nov 2010 10:39:41 +0100
Message-ID: <4CE0FFDD.4090407@trash.net>
References: <AANLkTinCazaFKSXnfGe2e0nnfeRorV7AHcadQaxGvWg+@mail.gmail.com>	<AANLkTikxkvB2pagQswH1S8=sxA+OVfWrqO45FD6+hDQE@mail.gmail.com>	<4CDBC9E9.2010508@trash.net> <AANLkTinobDP53eegFuhaQCds4TOb98YHWibf9P7L7_D4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Kfir Lavi <lavi.kfir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60915 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0KOJjl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:39:41 -0500
In-Reply-To: <AANLkTinobDP53eegFuhaQCds4TOb98YHWibf9P7L7_D4@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.11.2010 12:56, Kfir Lavi wrote:
> On Thu, Nov 11, 2010 at 12:48 PM, Patrick McHardy <kaber@trash.net> wrote:
>>
>> On 11.11.2010 11:05, Kfir Lavi wrote:
>>> Hi,
>>> It seems to me that its not possible to do a verdict in userspace of
>>> ethernet packets, like it is done with nfqueue and iptables.
>>> Why it is not implemented?
>>
>> Nobody ever implemented it. IIRC the main problem is that under
>> certain circumstances the packets need to be passed back to
>> __netif_receive_skb() when queuing in LOCAL_IN, which isn't
>> possible from the completion handler.
> 
> Thanks Patrick for your replay.
> Can you explain why it's not possible to pass packets back?

Because the completion handler is executed asynchronously,
while the bridge receive functions are called directly from
__netif_receive_skb().

> Also, why should packets need to be sent back?

That's f.i. how the NF_BR_LOCAL_IN handler works for link-local
packets. Have a look at br_handle_frame().
