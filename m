From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 14:02:54 +0100
Message-ID: <49BF9F7E.3090208@trash.net>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46506 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZCQNC6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:02:58 -0400
In-Reply-To: <20090317082425.GA25491@mail.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
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

Its only a compat option, it will get removed soon. 2.6.30 or 2.6.31
I'd say.
