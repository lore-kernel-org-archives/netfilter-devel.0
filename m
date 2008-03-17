From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: interface based conntrack entry
Date: Tue, 18 Mar 2008 00:35:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803180032560.18817@fbirervta.pbzchgretzou.qr>
References: <CAC6870A2B8FE846AD24D7E75B05F90A3F1960@moe.nextone.local>
 <1C6541574A2FC447B53A6B4522B678AF015A12C5@moe.nextone.local>
 <20080317232543.GB4003@bayen.regit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sohan Shetty <sshetty@nextpointnetworks.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Paritosh Tyagi <ptyagi@nextpointnetworks.com>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58742 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYCQXfQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:35:16 -0400
In-Reply-To: <20080317232543.GB4003@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 18 2008 00:25, Eric Leblond wrote:
>On Monday, 2008 March 17 at 16:13:45 -0400, Sohan Shetty wrote:
>> Forwarding query from Paritosh Tyagi to Netfilter mailing list.
>> 
>> Is there a patch to support the in-interface and out-interface or
>> mark in the conntrack module? So, we can have two entries in there
>> where the 4 tuple is the same only the interface is different?
>
>There is no such patch. A similar question was asked some time ago and
>if I remember well, the conclusion was the setup was too weird from a 
>firewall point-of-view.
>Suggestion was made to use some virtualization solution.

I believe that nf_conntrack deliberately does not use interfaces
as tuple parts because packets may very well come in on
and/or leave on different interfaces (routing on fwmark).
