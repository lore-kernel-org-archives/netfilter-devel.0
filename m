From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] libxt_hashlimit: always print burst value
Date: Fri, 25 Jun 2010 14:49:41 +0200
Message-ID: <4C24A5E5.6090701@trash.net>
References: <1277469942-26270-1-git-send-email-jengelh@medozas.de> <1277469942-26270-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0FYMtq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:49:46 -0400
In-Reply-To: <1277469942-26270-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> iptables -L lists the burst value, and so should iptables -S. I was
> certainly surprised to see it gone even when explicitly specifying
> --hashlimit-burst 5 on the command line.

I agree.
