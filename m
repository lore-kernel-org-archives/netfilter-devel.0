From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCHv3 2/2][RESEND] Addrtype match extension: limit addrtype
 check on the packet's interface
Date: Fri, 16 Nov 2007 18:19:44 +0100
Message-ID: <473DD130.8040601@balabit.hu>
References: <119514685071-git-send-email-panther@balabit.hu> <11952229272161-git-send-email-panther@balabit.hu> <Pine.LNX.4.64.0711161604060.3340@fbirervta.pbzchgretzou.qr> <473DB77B.4090206@balabit.hu> <Pine.LNX.4.64.0711161747290.31083@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:56058 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbXKPRTt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:19:49 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 0D701C1543
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Nov 2007 18:19:48 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0711161747290.31083@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 16 2007 16:30, Laszlo Attila Toth wrote:
>> Also it may be better if only the xt_addrtype remains and ipt_addrtype_info is
>> used for the old one and xt_addrtype_info for the new one. But it may be
>> confusing: ipt_* in the xt_* files...
> 
> Will be fixed 'one day' when all the compat code is removed :p

Not 'one': 'Mon' (Monday) :P

-- 
Panther
