From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 14:11:53 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0903171409550.17354@bizon.gios.gov.pl>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1468237929-1237295513=:17354"
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:49408 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCQN2j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:28:39 -0400
In-Reply-To: <20090317082425.GA25491@mail.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1468237929-1237295513=:17354
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 17 Mar 2009, Holger Eitzenberger wrote:

> On Mon, Mar 16, 2009 at 05:56:52PM +0100, Patrick McHardy wrote:
>
>> Currently the default is set based on the old config option.
>> When unset, no acct-extend is allocated for *new* conntracks.
>> The old ones that do have an acct-extend are still displayed.
>
> I think the current implementation is unfortunate, because the
> connbytes match auto-selects CONFIG_NF_CT_ACCT, and you end up having
> the message always and can't get rid of it other than patching
> it out.

This is not exactly true. CONFIG_NF_CT_ACCT only selects the default 
value, you are still able to disable it with sysctl.

Best regards,

 				Krzysztof Olêdzki
---1144830174-1468237929-1237295513=:17354--
