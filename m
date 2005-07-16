From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Logging process ID
Date: Sat, 16 Jul 2005 23:10:34 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507162250180.20061@yvahk01.tjqt.qr>
References: <1121542135.17007.124.camel@ws50.darkcore.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John Lange <john.lange@open-it.ca>
In-Reply-To: <1121542135.17007.124.camel@ws50.darkcore.net>
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


>Does iptables have the ability (or is there a patch available) to log
>the process id that generated a packet that was blocked? Obviously we
>are talking about internally generated packets only. This would be
>similar to --log-uid.
>
>Google and a quick look through patch-o-matic didn't turn up anything.
>
>This would probably be easy to add wouldn't it?

This was just recently discussed on nf or nf-dev mailing list (matching a 
process's pid).
Problem is the bh locking on SMP, as usual :)



Jan Engelhardt
-- 
