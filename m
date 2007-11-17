From: David Miller <davem@davemloft.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 16:19:26 -0800 (PST)
Message-ID: <20071116.161926.00949588.davem@davemloft.net>
References: <20071116.044413.227110480.davem@davemloft.net>
	<473D91E9.4010809@trash.net>
	<20071116153541.GA25986@linuxace.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, jengelh@computergmbh.de,
	netfilter-devel@vger.kernel.org
To: kernel@linuxace.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35552
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760772AbXKQATa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 19:19:30 -0500
In-Reply-To: <20071116153541.GA25986@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Oester <kernel@linuxace.com>
Date: Fri, 16 Nov 2007 07:35:41 -0800

> I'd vote for at least FTP here...most users will use it at
> some point (or if they don't, wonder why FTP is broken).

I disagree, passive ftp is extremely pervasive, there is no reason to
use traditional ftp these days.

I don't use it on my NAT box here at home and learned instintively
to type 'pftp' from the command line over time :-)
