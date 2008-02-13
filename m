From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH 4/5] adds AF_BRIDGE support to IP2STR
Date: Wed, 13 Feb 2008 12:13:15 +0100
Message-ID: <47B2D0CB.3020707@endian.com>
References: <20080211220753.796791654@endian.com> <20080211221056.846673328@endian.com> <20080212211538.GB13507@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:46299 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbYBMLN3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:13:29 -0500
In-Reply-To: <20080212211538.GB13507@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric

Eric Leblond wrote:
> So, this patch breaks IP display for OUTPUT packet. It could be fixed by
> using a combination of oob_family and oob_protocol.
>   
Oh, I understand. I was not aware of it and did not test with
OUTPUT packets :/
Thank you for the advice!

So, I will use family as it was before, and use protocol only when
family is AF_BRIDGE.

I will send fixes later

peter

