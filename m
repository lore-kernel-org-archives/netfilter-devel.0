From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 v5] New netfilter target to trigger LED devices
Date: Fri, 20 Feb 2009 10:57:38 +0100
Message-ID: <499E7E92.7030607@trash.net>
References: <49934702.9060909@shikadi.net> <4993B34C.1020307@trash.net>	 <49940D58.3040404@shikadi.net>  <49998E6C.2030504@trash.net> <1234878654.5312.34.camel@dax.rpnet.com> <499C17C2.9020502@trash.net> <499C899F.5010002@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Richard Purdie <rpurdie@linux.intel.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45234 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZBTJ5k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:57:40 -0500
In-Reply-To: <499C899F.5010002@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
>> Adam, I wanted to apply this, but I get rejects for every single
>> existing file. There appears to be some whitespace damage, please
>> resend as attachment.
> 
> Hmm, that's odd - Thunderbird must not like sending tabs - sorry
> about that!
> 
> I hope the attached files work better.

Applied, thanks. I've made some minor cosmetic changes, like removal
of /* noconst */ annotations and fixing indentation in one spot.

You can look at the final commit at:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
