From: David Miller <davem@davemloft.net>
Subject: Re: Problem with ipset on sparc64
Date: Thu, 05 Nov 2009 14:48:30 -0800 (PST)
Message-ID: <20091105.144830.268358661.davem@davemloft.net>
References: <alpine.LSU.2.00.0911051202050.23132@obet.zrqbmnf.qr>
	<alpine.DEB.2.00.0911051220090.13373@blackhole.kfki.hu>
	<alpine.LSU.2.00.0911051229590.28909@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, georg.chini@hp.com,
	netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56794
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbZKEWsG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 17:48:06 -0500
In-Reply-To: <alpine.LSU.2.00.0911051229590.28909@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Thu, 5 Nov 2009 12:30:55 +0100 (CET)

> But since the Ultra10 is just 32-bit IIRC, you would not have a
> chance to hit the rare 64-bit alignment problems (both in terms of
> SIGBUS and "invalid match size 16 != 12"), should there be any.

Ultra10 is sparc64 and thus 64-bit
