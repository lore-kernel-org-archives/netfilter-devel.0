From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [ovs-dev] [RFC PATCH 1/5] netfilter: Remove IP_CT_NEW_REPLY
 definition.
Date: Thu, 22 Oct 2015 01:32:11 +0200
Message-ID: <20151021233211.GF23554@pox.localdomain>
References: <1445379629-112880-1-git-send-email-jrajahalme@nicira.com>
 <20151021083323.GB15539@pox.localdomain>
 <B6033DCD-F46E-4416-9844-CF663215559A@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev <netdev@vger.kernel.org>, dev@openvswitch.org,
	netfilter-devel@vger.kernel.org
To: Jarno Rajahalme <jrajahalme@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37868 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbbJUXcN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Oct 2015 19:32:13 -0400
Received: by wicfv8 with SMTP id fv8so96849360wic.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2015 16:32:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <B6033DCD-F46E-4416-9844-CF663215559A@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/21/15 at 01:15pm, Jarno Rajahalme wrote:
> 
> > On Oct 21, 2015, at 1:33 AM, Thomas Graf <tgraf@suug.ch> wrote:
> > I understand what you are doing here but this is part of the published
> > UAPI and removing this might break compilation of a user application
> > even if the definition is not used right now. It's probably safer to
> > leave the definition and obsolete it with a comment.
> 
> OK. I should probably separate the netlink and openvswitch changes to separate patches as well?

Given that at that point the changes become unrelated, I'd split
it into separate patches, yes.
