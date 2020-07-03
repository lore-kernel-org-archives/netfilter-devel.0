Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360C5C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 14:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5B1820737
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 14:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=silentcreek.de header.i=@silentcreek.de header.b="hQ/rMtJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgGCOD6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 10:03:58 -0400
Received: from dd34104.kasserver.com ([85.13.151.79]:56326 "EHLO
        dd34104.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgGCOD6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 10:03:58 -0400
Received: from dd34104.kasserver.com (dd0805.kasserver.com [85.13.161.253])
        by dd34104.kasserver.com (Postfix) with ESMTPSA id DDE856C80373;
        Fri,  3 Jul 2020 16:03:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silentcreek.de;
        s=kas202007021019; t=1593785035;
        bh=Pj3TJmfKdPygrcgh7uRjpMNVsHhoDue5EiE6/zHCl0U=;
        h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
        b=hQ/rMtJrDES2qXMGRk2CbYqRw3Vq7CTk/GbRS6fsP4q9y4UYx4Mw3O0XoSSU6+JEA
         QYjeZj/+8RUIQRfqNxTokLlLySlk7MrTWfBJ2R7vCvUKxC+21kY83nx9lz/zm/FIqP
         L1FJDg0PILkLrnP5V0f94SoDqN0SZmAxd6Cjr3YZcUH3OXS6EBr4LnYkFTQeRJI+F9
         zhZ7iomur3Ahyuvn1CWigGW+zppbGOo1uJqnsNnTUwOkLz8HKecSZYL7P48n4tigBs
         LqXSolPG2xyVIZHpWD7j5X64WBzLcM04uvq6lgzYg3WbMct+pVmFesVFYUAWopw5KT
         ba6MLPxuYcl8w==
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-SenderIP: 89.245.242.209
User-Agent: ALL-INKL Webmail 2.11
In-Reply-To: <20200703112809.72eb94bf@elisabeth>
References: <20200702223010.C282E6C848EC@dd34104.kasserver.com><20200703112809.72eb94bf@elisabeth>
Subject: Re: Moving from ipset to nftables: Sets not ready for prime time yet?
From:   "Timo Sigurdsson" <public_timo.s@silentcreek.de>
To:     sbrivio@redhat.com
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc, kadlec@netfilter.org
Message-Id: <20200703140355.DDE856C80373@dd34104.kasserver.com>
Date:   Fri,  3 Jul 2020 16:03:55 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

Stefano Brivio schrieb am 03.07.2020 11:28 (GMT +02:00):

> On Fri,  3 Jul 2020 00:30:10 +0200 (CEST)
> "Timo Sigurdsson" <public_timo.s@silentcreek.de> wrote:
> 
>> Another issue I stumbled upon was that auto-merge may actually
>> generate wrong/incomplete intervals if you have multiple 'add
>> element' statements within an nftables script file. I consider this a
>> serious issue if you can't be sure whether the addresses or intervals
>> you add to a set actually end up in the set. I reported this here
>> [2]. The workaround for it is - again - to add all addresses in a
>> single statement.
>> ...
>> [2] https://bugzilla.netfilter.org/show_bug.cgi?id=1438
> 
> Practically speaking I think it's a bug, but I can't find a formal,
> complete definition of automerge, so one can also say it "adds items up
> to and including the first conflicting one", and there you go, it's
> working as intended.

Actually, I think it's a bug regardless of how auto-merge is defined exactly. Simply because I don't think that this
  add element family table myset { A }
  add element family table myset { B }
should give a different result compared to this
  add element family table myset { A, B }

But that's basically what's happening in my example.

> In general, when we discussed this "automerge" feature for
> multi-dimensional sets in nftables (not your case, but I aimed at
> consistency), I thought it was a mistake to introduce it altogether,
> because it's hard to define it and whatever definition one comes up
> with might not match what some users think. 

I understand that depending on the use case, one may have different expectations and that merging entries may cause issues. One example I read before was about adding a single IP address to a set which already contains the full /24 interval. If the addition would be simply ignored, you either wouldn't be able to delete the entry again or you'd have to break up the interval when doing so. So, I understand that it's impossible to make everybody happy.

> Let's try to reorder the insertions:
> 
> # nft add element t s '{ 10.0.0.1/16 . 192.168.0.0/16 }'
> # nft add element t s '{ 10.0.0.1/24 . 172.16.0.1 }'
> # nft add element t s '{ 10.0.1.1/30 . 192.168.1.1/24 }'
> Error: Could not process rule: File exists
> add element t s { 10.0.1.1/30 . 192.168.1.1/24 }
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> ...because that entry would never match anything: it's inserted after a
> more generic one that already covers it completely, and we'd like to
> tell the user that it doesn't make sense.
> 
> Now, this is pretty much the only advantage of not allowing overlaps:
> telling the user that some insertion doesn't make sense, and thus it
> was probably not what the user wanted to do.

Two thoughts here:
1) If there is a real conflict, say in a verdict map with diverging entries, then sure, refusing to accept the conflicting entries is certainly useful. But if there is an overlap that bears no meaning other than you'd either have an additional entry in your set that would never be matched, then I think there should be a way to just allow this or ignore the addition altogether.

2) Another problem here in practice is that nft doesn't emit a warning but fails entirely if you load a large set from a script with a duplicate entry (without auto-merge). You could avoid this by adding each element individually, but that's very slow for large sets, so not really an option either.
 
> So... I wouldn't know how deal with your use case, even in theory, in a
> consistent way. Should we rather introduce a flag that allows any type
> of overlapping (default with ipset), which is a way for the user to
> tell us they don't actually care about entries not having any effect?

Giving advice here is difficult, since I'm not in any position to make judgements about other use cases that might be affected by this. But, generally speaking, yes I think some option that makes overlaps ignorable like `ipset -exist' would be useful as well as good documentation what is to be expected from each flag/option, so the user at least knows about the limitations. And if there is a way to determine this programmatically, there could be a distinction along the lines what I described above between conflicting statements (leading to an error) and statements that simply overlap or are superfluous (leading to a simple warning unless a flag/option is used to allow and ignore them).

> And, in that case, would you expect the entry to be listed in the
> resulting set, in case of full overlap (where one set is a subset, not
> necessarily proper, of the other one)?

I would have expected the entries to be merged, so if I add 192.168.0.0/24 and then 192.168.0.2, I'd only expect to get 192.168.0.0/24 returned when listing the set. But even if both entries were added and the second one would never match, that would be fine for my use case. The problem is, when working with multiple blacklists, I cannot keep track of which entries are already added to the set, especially if one list may contain complete networks and another list contains individual IP addresses.

Thanks and regards,

Timo
