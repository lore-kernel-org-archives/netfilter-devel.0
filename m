From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/69]: Netfilter Update
Date: Wed, 30 Jan 2008 16:54:03 -0800 (PST)
Message-ID: <20080130.165403.99896363.davem@davemloft.net>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
	<Pine.LNX.4.64.0801302153450.3599@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58602
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbYAaAxn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:53:43 -0500
In-Reply-To: <Pine.LNX.4.64.0801302153450.3599@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Wed, 30 Jan 2008 21:55:25 +0100 (CET)

> What do people use to apply this batch? I exported them into an MBOX
> and tried git-am, but that always uses the mail's From: and Subject:
> rather than the --raw patch after the three-dashes.

I do it by hand in emacs, one email at a time :-)
