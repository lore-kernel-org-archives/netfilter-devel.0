From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Mon, 13 Jan 2014 08:30:17 -0800
Message-ID: <lb14ad$ps1$1@ger.gmane.org>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es> <20140113093912.GA14898@macbook.localnet> <CAOkSjBgTH=De81npZv_6P6B3rxJxt_0DW6yzK=pzp8uD03TpjA@mail.gmail.com> <20140113095252.GB15457@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43769 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbaARGuH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jan 2014 01:50:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1W4PjH-00059S-Ae
	for netfilter-devel@vger.kernel.org; Sat, 18 Jan 2014 07:50:03 +0100
Received: from c-50-132-41-203.hsd1.wa.comcast.net ([50.132.41.203])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2014 07:50:03 +0100
Received: from eternaleye by c-50-132-41-203.hsd1.wa.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2014 07:50:03 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:

> On Mon, Jan 13, 2014 at 10:49:51AM +0100, Arturo Borrero Gonzalez wrote:
>> On 13 January 2014 10:39, Patrick McHardy <kaber@trash.net> wrote:
>> >
>> > I think we should use .in files instead and perform variable
>> > substition.
>> >
>> 
>> Could you please elaborate this?
>> 
>> I have understood:
>> 
>> Use a variable in files/nftables/*, like:
>> <<
>> $shebang
>> 
>> table filter {
>> [...]
>> 
>> >>
>> 
>> And replace during install. Is this true?
> 
> Use f.i. files/nftables/ipv4-filter.in and use
> 
> #! ${sbindir}/nft

Another option would be the venerable

#!/usr/bin/env nft


