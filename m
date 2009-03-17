From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 15:39:01 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903171535210.3657@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <alpine.LNX.1.10.0903171409550.17354@bizon.gios.gov.pl>
 <alpine.LSU.2.00.0903171425520.30677@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Holger Eitzenberger <holger@eitzenberger.org>,
	Patrick McHardy <kaber@trash.net>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54061 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZCQOjE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:39:04 -0400
In-Reply-To: <alpine.LSU.2.00.0903171425520.30677@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-17 14:28, Jan Engelhardt wrote:
>On Tuesday 2009-03-17 14:11, Krzysztof Oledzki wrote:
>> On Tue, 17 Mar 2009, Holger Eitzenberger wrote:
>>> On Mon, Mar 16, 2009 at 05:56:52PM +0100, Patrick McHardy wrote:
>>>
>>>> Currently the default is set based on the old config option.
>>>> When unset, no acct-extend is allocated for *new* conntracks.
>>>> The old ones that do have an acct-extend are still displayed.
>>>
>>> I think the current implementation is unfortunate, because the
>>> connbytes match auto-selects CONFIG_NF_CT_ACCT, and you end up having
>>> the message always and can't get rid of it other than patching
>>> it out.
>>
>> This is not exactly true. CONFIG_NF_CT_ACCT only selects the default value, you
>> are still able to disable it with sysctl.
>
>The implication is that xt_connbytes will not do the right thing
>anymore as soon as user accounting is turned off, either by flipping
>the sysctl value or deactivating the kconfig option. That is not
>good.
>
xt_conntrack for example has a nicer effect: once you add a rule that
contains it, it will load nf_conntrack_ipv{4,6}, which in turn causes
Netfilter to start tracking in the first place.

So along the lines, xt_connbytes could pin a module (or perhaps
something more light-weight) to ultimately signify
"forced-activation"/"deactivation-impossible", much like you cannot
remove nf_conntrack while an xt_conntrack-using rule is in place.

Then only one thing remains. As for nf_conntrack, once it is loaded,
it picks up already-running connections (and loses them as soon
as you rmmod it). This is not the case with accounting as far as I
have observed yesterday - only new connections get to have (or
not to have) an acct structure; existing ones are not modified
or picked up like conntrack does.
