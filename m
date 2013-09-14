From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH v3] netfilter: ipset: Fix serious failure in CIDR tracking
Date: Sat, 14 Sep 2013 10:38:14 +0200
Message-ID: <2121442.K0PkEKYW9J@gentoovm>
References: <1378894613-37279-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <34508068.QlVPmtIuPd@gentoovm> <alpine.DEB.2.00.1309132156290.4634@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:46096 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3INIiy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Sep 2013 04:38:54 -0400
In-Reply-To: <alpine.DEB.2.00.1309132156290.4634@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 13 September 2013 22:03:36 you wrote:
<snip>
> 
> I couldn't follow your reasoning above, maybe it's just too late here.
> 
> Anyway, I'd like to ask you two small modifications compared to v3 and
> that's all:
> 
> - Change the condition of the first "if" to an inequality, with a
>   continue statement in the if body. Thus the next lines can be shifted
>   to the left, for better readability.

OK, sounds good, I assume you mean v4, since a continue would not be valid in 
v3.

> - Move the "i == net_end" test to the last position, because that is
>   the less likely case.

This would create an error if we reached the very last possible iteration 
(i.e. *i* being 1 less than nets_length) - we need to check if it is equal to 
net_end (i.e. nets_length - 1) in the order it is right now so that we do not 
attempt a memory access beyond the boundary of the array (i.e. the final [i + 
1] check within the if() statement).

I'll land the new patch shortly.

Kind Regards,
Oliver.
