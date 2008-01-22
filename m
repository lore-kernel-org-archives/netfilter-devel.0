From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RESEND][PATCH] Introducing socket mark socket option
Date: Tue, 22 Jan 2008 15:39:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801221539170.22770@fbirervta.pbzchgretzou.qr>
References: <12010126891806-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35365 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYAVOjq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:39:46 -0500
In-Reply-To: <12010126891806-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 22 2008 15:38, Laszlo Attila Toth wrote:
>
>If netfilter is enabled, a userspace program may wish to set the mark for
>each packets its send instead of using the MARK target.
>
For systems where conntrack and xtables is not loaded, I presume?
Sounds reasonable.
