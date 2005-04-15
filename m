From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [patch] fix ACCOUNT locking
Date: Fri, 15 Apr 2005 21:49:25 +0200
Message-ID: <42601AC5.5070307@gmx.net>
References: <200504151024.28858.thomas.jarosch@intra2net.com>	<20050415155430.GG25433@sunbeam.de.gnumonks.org>
	<200504151808.37519.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200504151808.37519.thomas.jarosch@intra2net.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Thomas Jarosch schrieb:
> Hello Harald,
> 
> 
>>>attached is a patch to fix ipt_ACCOUNT locking. ipt_ACCOUNT now works
>>>finally for large networks without trouble.
>>
>>somehow I was neither able to apply this patch to what we had in
>>patch-o-matic-ng, nor incremental to your last email from April 05.

This is probably due to the fact that the new version introduces loads
of whitespace before the end of line. I struggled with that myself.

I'll soon have my 64-bit-cleanliness patches ready. They needed some
overhaul after the locking change.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
