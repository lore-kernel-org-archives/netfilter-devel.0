From: "Kaloyan Kovachev" <kkovachev@varna.net>
Subject: Re: new target or new option
Date: Mon, 1 Oct 2007 10:04:06 +0300
Message-ID: <20071001065330.M72816@varna.net>
References: <20070928170244.M71172@varna.net> <Pine.LNX.4.64.0709281935540.25099@fbirervta.pbzchgretzou.qr> <46FD3DF2.10709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=windows-1251
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.Varna.Net ([217.145.80.1]:35183 "EHLO ns.varna.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbXJAHEM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:04:12 -0400
In-Reply-To: <46FD3DF2.10709@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 28 Sep 2007 19:46:26 +0200, Patrick McHardy wrote
> Jan Engelhardt wrote:
> > On Sep 28 2007 20:06, Kaloyan Kovachev wrote:
> > 
> >>Hello,
> >>i need to mark the connection with the realm number, but it seems there is no
> >>'easy way' and there should be separate rule for each realm.
> >>
> >>Are there any plans to add this functionality and which is the preferable way
> >>to go:
> >>  1) create new REALMCONNMARK target with and/or mask
> > 
> > 
> > Yeah, since there is already an xt_realm, a xt_REALM would be
> > the logical counterpart.
> 
> The realm belongs to the route, it can not be changed.
> 
> I'm currently working on the netlink based iptables successor,
> perhaps we should split matches into a "collector" part that
> gathers the data and some generic range/mask/... matching.
> That would allow to tell a target like CONNMARK to gather
> the data from somewhere else.

Great, this will also replace IPMARK, IPCLASSIFY etc with only common targets
MARK, CONNMARK and CLASSIFY. It would be good to use the same sintax for match
and for the mark value i.e. if the entry is a macth return true or false and
if it is in the target - return the matched value.


