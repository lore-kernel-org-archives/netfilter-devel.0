From: Angel Mieres <amieres@eneotecnologia.com>
Subject: Re: Errors trying to build conntrack
Date: Mon, 28 Aug 2006 08:42:56 +0200
Message-ID: <1156747376.31720.3.camel@supercoco>
References: <925A849792280C4E80C5461017A4B8A206F9D0@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A206F9D0@mail733.InfraSupportEtc.com>
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

> Hello - 
>  
> This is not my day!  I am trying to build the conntrack utility to help me debug some other problems.  First I tried the latest snapshot, conntrack-20060826.  But when I unpacked it (tar -xvjf conntrack-20060826.tar.bz2) there was no configure script.  
> 
> So I tried beta2, conntrack-1.00beta2.tar.bz2.  This unpacked cleanly and the configure script ran to completion without errors.  But make blew up.  I will past in the complete output below.
> 
> Any idea how to build conntrack or what I am doing wrong?

You must install before libnetfilter_conntrack & libnfnetlink.

Please read documentation ;) 

Regards,
Angel M.


-- 
Angel Mieres - amieres@eneotecnologia.com
///////////////////////////////////////// Gentoo has you...
