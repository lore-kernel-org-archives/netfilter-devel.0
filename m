From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Tue, 4 Nov 2008 02:22:42 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811040211440.6991@fbirervta.pbzchgretzou.qr>
References: <490B46F0.4010100@hp.com> <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr> <490F9A3E.2060505@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rick Jones <rick.jones2@hp.com>, netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51070 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYKDBWp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:22:45 -0500
In-Reply-To: <490F9A3E.2060505@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-04 01:41, Philip Craig wrote:
>Jan Engelhardt wrote:
>> And strace should not be taught that. We have seen at least one
>> change of the interpretation of the binary stream.
>
>Are you saying I can't use an old iptables binary with a new kernel?
>
You can, but there is a corner case where you cannot, right, and that is 
when your extension's name is 31/32 characets long. Which was deemed so 
unlikely that the change actually occurred.
