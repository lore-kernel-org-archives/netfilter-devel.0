From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_RAWNAT target idea
Date: Mon, 14 Jan 2008 10:45:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801140944000.10906@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
 <478AFB75.7040701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34704 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYANJp1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:45:27 -0500
In-Reply-To: <478AFB75.7040701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 14 2008 07:04, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> the following series implements xt_RAWNAT, a target to do network
>> address translation not depending on conntrack. I still have an issu=
e
>> though, if you have an idea what could be wrong, please let me know.
>
> Whats the advantage over using the TC NAT action?

Let me put it this way... =E2=80=9Cwhat is tc?=E2=80=9D

- tc is a real black-box to most users;
  lack of documentation (despite lartc.org efforts)

- act_nat only works like NETMAP, i.e.
  on outgoing packets, you can only change the source addr

At which point I would be asking: why is tc trying to do the same
as netfilter mangling targets?
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
