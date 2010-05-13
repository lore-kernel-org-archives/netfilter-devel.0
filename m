From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: libxt_TEE
Date: Thu, 13 May 2010 15:48:48 +0200
Message-ID: <4BEC0340.6080400@trash.net>
References: <1271681322-29994-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55736 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0EMNsv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 May 2010 09:48:51 -0400
In-Reply-To: <1271681322-29994-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The following changes since commit db6d027bb9626129617ea3a3f2fe4b87ab307bf6:
>   Jan Engelhardt (1):
>         libxt_osf: import nfnl_osf program
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (1):
>       extensions: add support for xt_TEE

I've created a new branch "iptables-next" and pulled this in so
people can already test the new features in net-next.
