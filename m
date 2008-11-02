From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Issues building iptables-1.4.2 w/ linux 2.6.25 (and IMQ)
Date: Sun, 2 Nov 2008 23:16:25 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811022315160.25491@fbirervta.pbzchgretzou.qr>
References: <490E111C.9060006@redfish-solutions.com> <alpine.LNX.1.10.0811022204140.25491@fbirervta.pbzchgretzou.qr> <490E1B3D.7030003@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33487 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYKBWQ2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:16:28 -0500
In-Reply-To: <490E1B3D.7030003@redfish-solutions.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-11-02 22:27, Philip Prindeville wrote:
>
> Ok, so taking this from the other direction:  what is the
> recommended version of iptables to run on Linux 2.6.25.19?

There is no specific recommendation (a large number of (iptablesversion, 
kernelversion) tuples work), but to get certain features and bugfixes 
"newer is better" is probably a good line to follow.
