From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables PATCH trunk7285 7/7] fix gcc warnings
Date: Tue, 29 Jan 2008 14:32:33 +0100
Message-ID: <479F2AF1.1070703@trash.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net> <20080127182503.15959.7989.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55092 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbYA2Nsd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:48:33 -0500
In-Reply-To: <20080127182503.15959.7989.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> ---
> 
>  configure.ac                    |    5 +++--
>  ...

Applied, thanks. It caused a few new warnings though, could you fix
those up as well?
