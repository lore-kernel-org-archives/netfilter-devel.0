From: "tung tran" <tunghack@gmail.com>
Subject: Re: Netfilter module help
Date: Sun, 13 Jul 2008 19:41:41 -0400
Message-ID: <13f1ba4c0807131641k471f9c30wfcfdd6ce0a0de1a8@mail.gmail.com>
References: <13f1ba4c0807091558m5fff70ear7515557278001922@mail.gmail.com>
	 <alpine.LNX.1.10.0807100127040.27323@fbirervta.pbzchgretzou.qr>
	 <13f1ba4c0807091641j33a9ebe0ocbe6c0cb95883159@mail.gmail.com>
	 <1215648362.11885.5.camel@henriknordstrom.net>
	 <13f1ba4c0807091754oca9211dxd4166c1b56c0c66@mail.gmail.com>
	 <13f1ba4c0807121328m527a4fclcf5df079cf7cc836@mail.gmail.com>
	 <1215986057.13491.8.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: "Henrik Nordstrom" <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:65232 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYGMXlo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jul 2008 19:41:44 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2289654ywe.1
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Jul 2008 16:41:41 -0700 (PDT)
In-Reply-To: <1215986057.13491.8.camel@henriknordstrom.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Henrik,
Really really appreciate your help.
Thanks,
Tung.

On Sun, Jul 13, 2008 at 5:54 PM, Henrik Nordstrom
<henrik@henriknordstrom.net> wrote:
> On l=F6r, 2008-07-12 at 16:28 -0400, tung tran wrote:
>> I have another question, if I use QUEUE, is there any way  that I ca=
n
>> pass a packet back to a chain after processing it? For example, I us=
e
>> libipq to receive a packet from kernel (through the special QUEUE
>> chain) and process the packet.  After processing the packet, I do no=
t
>> want to ACCEPT or REJECT the packet, but pass it back to a different
>> chain, for example INPUT. Can I do this?
>
> The verdict from the QUEUE handler needs to be a final ACCEPT/DROP
> verdict from that chain.
>
> But on ACCEPT the packet continues as if the iptables rule had been a=
n
> ACCEPT rule. The next priority handler will be called in the netfilte=
r
> hook, and then the packet will continue in the ip stack as usual..
>
> So you can use QUEUE in PREROUTE, return ACCEPT and then see it in IN=
PUT
> again as that a different hook.
>
> You can also use QUEUE in the raw table and then see the packet in
> filter/mangle/nat as these are different even if you are using the sa=
me
> hook.
>
> Regards
> Henrik
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
