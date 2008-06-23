From: Patrick McHardy <kaber@trash.net>
Subject: Re: build: change equality for old bash
Date: Mon, 23 Jun 2008 11:37:43 +0200
Message-ID: <485F6EE7.8000606@trash.net>
References: <alpine.LNX.1.10.0806221849530.24624@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43035 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYFWJhr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:37:47 -0400
In-Reply-To: <alpine.LNX.1.10.0806221849530.24624@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 1063d1608700beb14687078b526d11bf1cf0be5f
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sun Jun 22 14:45:48 2008 +0200
> 
> build: change equailty test for old bash
>     
> Michael used GNU bash, version 1.14.7(1), which apparently does not
> seem to know about the double ("==") variant of equality tests.

Applied, thanks.
