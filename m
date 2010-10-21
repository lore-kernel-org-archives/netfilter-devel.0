From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 9/9] tproxy: use the interface primary IP address as
 a default value for --on-ip
Date: Thu, 21 Oct 2010 16:48:44 +0200
Message-ID: <4CC052CC.8010702@trash.net>
References: <20101021104709.5192.31249.stgit@este.odu> <20101021104710.5192.65152.stgit@este.odu> <4CC04C81.9080504@trash.net> <4CC04D97.9020105@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: KOVACS Krisztian <hidden@balabit.hu>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59378 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0JUOss (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:48:48 -0400
In-Reply-To: <4CC04D97.9020105@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 21.10.2010 16:26, schrieb Amos Jeffries:
> On 22/10/10 03:21, Patrick McHardy wrote:
>> Also applied, thanks a lot.
>>
> 
> Hoooray!! Thanks very, very, very much.
> 
> Just one followup question:
>   which kernel and iptables release is this now headed for?

These patches will appear in 2.6.37-rc.
