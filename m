From: jamal <hadi@cyberus.ca>
Subject: Re: RFC: netfilter: nf_conntrack: add support for "conntrack zones"
Date: Fri, 15 Jan 2010 10:03:42 -0500
Message-ID: <1263567822.23480.125.camel@bigi>
References: <4B4F24AC.70105@trash.net> <1263481549.23480.24.camel@bigi>
	 <4B4F6332.50606@candelatech.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Linux Netdev List <netdev@vger.kernel.org>,
	containers@lists.linux-foundation.org
To: Ben Greear <greearb@candelatech.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40827 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab0AOPDq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2010 10:03:46 -0500
In-Reply-To: <4B4F6332.50606@candelatech.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2010-01-14 at 10:32 -0800, Ben Greear wrote:

> For small or simple cases, this may be true..but there is a lot of work
> to make a complex user-space app that manages arbitrary amounts of interfaces
> routing tables in an arbitrary amount of network namespaces.  With the contrack-zones
> approach, user-space apps do not require any significant changes, and you do not
> need the rest of the namespace overhead to accomplish the task.

I think for your use case what you state is true. In the general case,
it is not. 
Note: I am not arguing against the patch - just that it is not the
generic scenario solution compared to namespaces.

cheers,
jamal

