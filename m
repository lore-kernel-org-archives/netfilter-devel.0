From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: question about UNDEFINE/REDEFINE
Date: Fri, 26 Jan 2018 10:43:18 -0800
Message-ID: <CAOkSjBiHTwW_9rQhznubKnZ=DJJsySK4qo_XJ3r4PLAmKXt35w@mail.gmail.com>
References: <3622208.jy4NlOniyd@voxel> <20180123110728.i7hujeyz6224atd2@salvia>
 <1993002.08LkLsM8EI@voxel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: David Fabian <david.fabian@cldn.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:40708 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbeAZSnl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jan 2018 13:43:41 -0500
Received: by mail-wm0-f51.google.com with SMTP id v123so23049745wmd.5
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2018 10:43:40 -0800 (PST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com. [74.125.82.52])
        by smtp.gmail.com with ESMTPSA id x37sm3055024edx.3.2018.01.26.10.43.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jan 2018 10:43:39 -0800 (PST)
Received: by mail-wm0-f52.google.com with SMTP id f3so23075365wmc.1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2018 10:43:39 -0800 (PST)
In-Reply-To: <1993002.08LkLsM8EI@voxel>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23 January 2018 at 04:40, David Fabian <david.fabian@cldn.cz> wrote:
> Hello Pablo,
>
> Dne úterý 23. ledna 2018 12:07:28 CET, Pablo Neira Ayuso napsal(a):
>> I'm asking here because I would need to understand better how you've
>> structured your scripts, if you could explain a bit more, we would
>> appreciate.
>
> I have packed an excerpt of a playground FW with two VLANs 3 and 54. The
> configuration already uses my redefine keyword.
>
> ftp://ftp.bosson.eu/pub/tmp/nftables_excerpt.tar.gz
>
> The intended use case is to call nft -f fw-on and reload the firewall from
> scratch every time there is a config change. I don't know how a cmdline
> parameter would help us with it. Maybe if we would wrap nft calls with bash
> scripts but that would defeat the purpose of using the nft scripting
> capabilities in the first place.
>
> The most important for us is to have the FW logically structured for every
> customer and every FW rule related to a customer should be in his/her VLAN
> config file.
>

Your approach (redefining variables) doesn't save so much typing at
the end of the day.

My suggestion is to simply create one variable per value:

define INET_IFACES_VLAN43 = { bond0.x, bond3.y}
define INET_IFACES_VLAN3 = { bond3.x, bond3.y}
define XXX_VLAN43 = xxx
define XXX_VLAN3 = xxx

you could generate such a file, something like 'defines.nft' and
include it once in your main ruleset file.

If you will perform many updates to this file, you could even maintain
this in git to keep track of changes.
Example: https://wiki.nftables.org/wiki-nftables/index.php/Classic_perimetral_firewall_example

Other option is you create some kind of shell wrapper to replace
variable names before running nft -f (something like make .in files),
but that's even uglier? I don't know.
