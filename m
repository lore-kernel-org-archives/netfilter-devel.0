From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nft compat layer
Date: Mon, 18 Jan 2016 11:25:42 +0100
Message-ID: <CAOkSjBiY-sbWPKwokkUooYBq0X8wf0azqPmJrvz+6W8WNMBf9g@mail.gmail.com>
References: <CAOkSjBhpqYQ01xOehhG7zFAzStOcTttQTk1JcLaP_UnAWSzmPw@mail.gmail.com>
 <569CA968.9010702@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34472 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbcARK0D convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2016 05:26:03 -0500
Received: by mail-wm0-f44.google.com with SMTP id u188so97716939wmu.1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2016 02:26:03 -0800 (PST)
In-Reply-To: <569CA968.9010702@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 January 2016 at 09:59, Andreas Schultz <aschultz@tpip.net> wrote:
> Hi Arturo,
>
> On 01/15/2016 09:06 PM, Arturo Borrero Gonzalez wrote:
>>
>> Hi,
>>
>> I'm giving a spin to the nft compat layer, since it can be of certai=
n
>> importance for distributions.
>>
>> I just want to be clear on what I recommends to end users about
>> migrating from iptables (and friends) to nftables.
>>
>> Could you please remind me in which state was the discussion about
>> that patch to show x_tables extensions in nftables rulesets [0]?
>> I remember Patrick mentioned several concerns back then about this
>> approach.
>
>
> I have an updated version of this patch and also fixed some of
> the problems I encountered along the way (see attached patches).
> The nft patch is based on nftables-0.5 and the kernel change
> should apply cleanly to linux-4.4.
>
> With the update patch I can load a fairly complex iptables
> firewall with iptables-compat, dump it with nft and reload
> the dump with nft.
>
> The resulting ruleset appears to be working. YMMV.
>

The last I can find in patchwork [0] seems to support ebtables
watchers, among other things.
The kernel patch to disable validations in nft_compat I assume is work
in progress or something?

Anyway, I just want to make sure what is the roadmap with regards to
the compat stuff. What should I recommend users to do when migrating
to nftables?

[0] http://patchwork.ozlabs.org/patch/459772/
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
