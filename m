From: Patrick McHardy <kaber@trash.net>
Subject: Re: build: quote variables in release.sh
Date: Thu, 03 Jul 2008 20:26:12 +0200
Message-ID: <486D19C4.6000503@trash.net>
References: <alpine.LNX.1.10.0807032015430.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44894 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbYGCS0O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:26:14 -0400
In-Reply-To: <alpine.LNX.1.10.0807032015430.23294@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 68a69d9fbf610899aa95457cdd5c38dcfa447c02
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Jul 3 19:23:39 2008 +0200
> 
>     build: quote variables in release.sh
>     
>     Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

I knew that wouldn't take long :) I actually didn't qoute all
those variables on purpose since neither git versions, nor
iptables versions, nor the filenames need this, but anyway,
applied.

