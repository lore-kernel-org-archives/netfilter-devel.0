From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip{,6}_queue: convert to seq_file interface
Date: Sat, 20 Oct 2007 16:55:54 +0200
Message-ID: <471A16FA.2030506@trash.net>
References: <20071019152221.GB6271@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, devel@openvz.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33129 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbXJTO4z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 10:56:55 -0400
In-Reply-To: <20071019152221.GB6271@localhost.sw.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexey Dobriyan wrote:
> I plan to kill ->get_info which means killing proc_net_create().
>   

Applied, thanks Alexey.

