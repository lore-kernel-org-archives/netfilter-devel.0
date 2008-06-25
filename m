From: Patrick McHardy <kaber@trash.net>
Subject: Re: build: ip6.h is not required
Date: Wed, 25 Jun 2008 12:18:57 +0200
Message-ID: <48621B91.5080103@trash.net>
References: <alpine.LNX.1.10.0806251031480.31898@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48669 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbYFYKTC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:19:02 -0400
In-Reply-To: <alpine.LNX.1.10.0806251031480.31898@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 7dc7126ec9b9d56528f0e7625dae3c2c05ac947d
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Jun 25 10:23:54 2008 +0200
> 
> build: ip6.h is not required
>     
> Remove the check from configure.ac that errors out when ip6.h is not
> found. The code does not actually depend on any structures from it.

Applied, thanks.
