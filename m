From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 11:01:18 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903191057280.25879@fbirervta.pbzchgretzou.qr>
References: <49C202EA.40006@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36148 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbZCSKBW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:01:22 -0400
In-Reply-To: <49C202EA.40006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-03-19 09:31, Patrick McHardy wrote:

> I've planned to release the next iptables version sometime (late)
> this weekend. We've had quite a lot of changes since the last
> version, please test the latest version from git and report any
> issues.

    libxtables: add -I/-L flags to pkgconfig files
    
    These are needed in case iptables gets installed into a non-standard
    path. It also enables automatic detection of these locations from 3rd
    party programs via pkgconfig.


Patch pullable from  git://dev.medozas.de/iptables master

Updating 71bc61f..467e72c
Fast forward
 xtables.pc.in |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
