From: David Miller <davem@davemloft.net>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 03 Nov 2010 05:19:25 -0700 (PDT)
Message-ID: <20101103.051925.193703726.davem@davemloft.net>
References: <20101102.135254.226783976.davem@davemloft.net>
	<4CD12B8B.9090506@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pascal.mail@plouf.fr.eu.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37055
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab0KCMTC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 08:19:02 -0400
In-Reply-To: <4CD12B8B.9090506@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Date: Wed, 03 Nov 2010 10:29:47 +0100

> What would be a use case ?

I thought it was painfully obvious but...  the use case is setting up
a rule that matches the prefix addresses and having such rules still
work properly when the link flaps onto a link with a different prefix
