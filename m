From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 22:10:46 +0100
Message-ID: <CAOkSjBi_X40RrdHDpNNsdbSp-=3okki21s=wkK3J+BsD97Jpqg@mail.gmail.com>
References: <20141217205407.06558f65@turingmachine> <CAOkSjBg_O4GRuFkm7hNoZDv_JqCjOVRcP7VNV=K1NYqHdSuJmA@mail.gmail.com>
 <b3a6e72b6713574b986ab81624dddeda@mail.higgsboson.tk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:45647 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQVLI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:11:08 -0500
Received: by mail-la0-f54.google.com with SMTP id pv20so13543068lab.41
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2014 13:11:07 -0800 (PST)
In-Reply-To: <b3a6e72b6713574b986ab81624dddeda@mail.higgsboson.tk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 December 2014 at 21:57, J=C3=B6rg Thalheim <joerg@higgsboson.tk> =
wrote:
>>> +nftables_restart() {
>>> +       nftables_stop
>>> +       nftables_start "$1"
>>
>> Here, I think the time between the stop and start, there is not
>> ruleset in the kernel.
>> I guess we can do it better, flushing the old ruleset and loading th=
e
>> new one in a single,atomic step.
>
> Is this possible with nft? If so, how?
>

add a heading 'flush ruleset' to the file to be loaded.

Also, to load multiple files you can use "include" statements, and
still be atomic B-)

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
