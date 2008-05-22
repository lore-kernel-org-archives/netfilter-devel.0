From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] simplify list handing in ifname2index infrastructure
Date: Thu, 22 May 2008 15:02:53 +0200
Message-ID: <48356EFD.4000704@netfilter.org>
References: <483564C0.2000100@netfilter.org> <20080522125443.GL7436@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57895 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757946AbYEVNDD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 09:03:03 -0400
In-Reply-To: <20080522125443.GL7436@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Thursday, 2008 May 22 at 14:19:12 +0200, Pablo Neira Ayuso wrote:
>> Hi!
>>
>> The patch attached simplifies the ifname2index list handling by using
>> linux list and it introduces minor cleanups such as remove iftb_log()
>> calls. This patch also fixes the leak in the nlif_close path (we forgot
>> to release the ifindex nodes from the hashes) that Anton has reported.
>>
>> Slightly tested here. If you are OK with it I'll apply it asap.
> 
> Maybe, this patch is a little too much for a code which should disappear for
> libnl ?

Well, the current code is broken and we have to fix it anyway. If you
don't have any other objection I'll apply it asap.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
