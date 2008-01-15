From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] Fix CONNMARK mask value demolition
Date: Tue, 15 Jan 2008 16:46:32 +0100
Message-ID: <478CD558.5050805@trash.net>
References: <4780454E.3050803@endian.com> <478C5B0A.0@trash.net> <478C9CC7.30902@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42989 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYAOPqo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:46:44 -0500
In-Reply-To: <478C9CC7.30902@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:
> Hi Patrick
> 
> Patrick McHardy wrote:
>> Good catch, but don't we also need set the mask for --save-mark
>> and --restore-mark? I would suggest to move the initialzation
>> to a ->init() function.
> 
> Oh, yes. That's necessary.
> Here's the revised patch with the init() function.

Applied, thanks Peter.
