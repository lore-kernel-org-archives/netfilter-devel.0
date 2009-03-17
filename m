From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 14:13:56 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0903171411560.17354@bizon.gios.gov.pl>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <49BF9F7E.3090208@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-194160537-1237295636=:17354"
Cc: Jan Engelhardt <jengelh@medozas.de>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:49408 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZCQN2h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:28:37 -0400
In-Reply-To: <49BF9F7E.3090208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-194160537-1237295636=:17354
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 17 Mar 2009, Patrick McHardy wrote:

> Holger Eitzenberger wrote:
>> On Mon, Mar 16, 2009 at 05:56:52PM +0100, Patrick McHardy wrote:
>> 
>>> Currently the default is set based on the old config option.
>>> When unset, no acct-extend is allocated for *new* conntracks.
>>> The old ones that do have an acct-extend are still displayed.
>> 
>> I think the current implementation is unfortunate, because the
>> connbytes match auto-selects CONFIG_NF_CT_ACCT, and you end up having
>> the message always and can't get rid of it other than patching
>> it out.
>
> Its only a compat option, it will get removed soon. 2.6.30 or 2.6.31
> I'd say.

I have the patch ready. Do you think it is a good moment to push it now, 
so it will be included in 2.6.30, or should I rather wait for 2.6.31?

Best regards,

 			Krzysztof Olêdzki
---1144830174-194160537-1237295636=:17354--
