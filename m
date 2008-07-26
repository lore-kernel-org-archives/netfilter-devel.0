From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] selinux: use nf_register_hooks()
Date: Sun, 27 Jul 2008 00:40:28 +0200
Message-ID: <488BA7DC.2050004@trash.net>
References: <20080721162503.GB13264@martell.zuzino.mipt.ru> <4884B992.1040100@trash.net> <Xine.LNX.4.64.0807220726460.25813@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov,
	eparis@parisplace.org
To: James Morris <jmorris@namei.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42458 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbYGZWkf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 18:40:35 -0400
In-Reply-To: <Xine.LNX.4.64.0807220726460.25813@us.intercode.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James Morris wrote:
> On Mon, 21 Jul 2008, Patrick McHardy wrote:
> 
>> Alexey Dobriyan wrote:
>>> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>>> ---
>>>
>>>  security/selinux/hooks.c |   27 ++++++++-------------------
>>>  1 file changed, 8 insertions(+), 19 deletions(-)
>> I can pick this up or it can go through the SELinux tree.
>> Stephen, James?
> 
> Probably simplest for you to take it while I'm travelling.

Applied, thanks.
