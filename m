From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: fix - mistake to pass a pointer where
 array is required
Date: Mon, 15 Oct 2007 08:07:14 +0200
Message-ID: <47130392.60902@trash.net>
References: <470F09EF.9080606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: lizf <lizf@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34837 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXJOGHq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:07:46 -0400
In-Reply-To: <470F09EF.9080606@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

lizf wrote:
> Hi,
> 
> Macros like SCTP_CHUNKMAP_XXX(chukmap) require chukmap to be an array,
> We can see from below:
> 
> #define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))
> 
> #define SCTP_CHUNKMAP_RESET(chunkmap)                \
>     do {                            \
>         int i;                        \
>         for (i = 0; i < ELEMCOUNT(chunkmap); i++)    \
>             chunkmap[i] = 0;            \
>     } while (0)
> 
> But match_packet() passes a pointer to these macros. Here's the patch.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Thanks, but your mailer corrupted the patch by converting tabs to
spaces. Please resend as attachment so I can apply it.


