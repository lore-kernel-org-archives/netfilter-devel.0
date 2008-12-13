From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] More secure SYSRQ for xtables-addons
Date: Sat, 13 Dec 2008 23:14:10 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812132313260.27276@fbirervta.pbzchgretzou.qr>
References: <492E926D.5020807@oracle.com> <4935747C.5090207@oracle.com> <4942230F.2000106@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52732 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYLMWOL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Dec 2008 17:14:11 -0500
In-Reply-To: <4942230F.2000106@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-12-12 09:38, John Haxby wrote:
> John Haxby wrote:
>> Hello All,
>>
>> This is a patch to the SYSRQ xtables-addon that is, I believe, secur=
e enough
>> to use in moderately untrustworthy environments.
>>
>> This is an updated version of the patch to address comments previous=
ly
>> received.   The main change, prompted by Patrick McHardy's question,=
 is to
>> allow the hash algorithm to be changed at module load time.  Other t=
han that
>> I've clarified the '\n' password termination and updated the man pag=
e to
>> include using -m limit, the configurable hash algorithm and made it =
a little
>> that you can send multiple request keys.
>
> I don't know if I'm being overly anxious or impatient, but is there a=
nything
> more I need to do for this updated patch?

Hm, did I miss to send an =E2=80=9Cok=E2=80=9D? It definitely is up in =
the git repo already.
Thanks again for the submission!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
