From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Mon, 22 Mar 2010 20:14:31 +0100
Message-ID: <4BA7C197.3030609@intra2net.com>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net> <201003191604.45719.thomas.jarosch@intra2net.com> <4BA39B3D.4070509@trash.net> <201003191719.54550.thomas.jarosch@intra2net.com> <4BA7A967.9060308@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: timg@tpi.com, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:51783 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0CVTOV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:14:21 -0400
In-Reply-To: <4BA7A967.9060308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/22/2010 06:31 PM, Patrick McHardy wrote:
>> Clearly your new version is more readable about the intent.
> 
> Thomas, before I send this upstream with a Tested-by tag in your name,
> could you please confirm that this is the change you've actually tested?

Yes and I just did another test run with your final patch, works fine.

Cheers,
Thomas
