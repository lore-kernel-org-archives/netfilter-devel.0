From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: current pom-ng's nfnetlink doesn't apply cleanly to kernel 2.4.22
Date: Sun, 18 Apr 2004 18:21:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404181817380.6618-100000@filer.marasystems.com>
References: <20040418101022.15235.qmail@web41703.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhi wang <pangy2004@yahoo.com>
In-Reply-To: <20040418101022.15235.qmail@web41703.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 18 Apr 2004, zhi wang wrote:

> apply_dependencies: unable to apply dependent ctstat: ERROR (2 rejects out of
> 15 hunks)

Ok. So it is the ctstat patch you have problems with, not nfnetlink..

This applies without any modifications in my kernel builds, but then again 
I am also applying a lot of other patches so it is possible this patch 
does depend on something else.. in addition I am using 2.4.25 and 
2.4.26-rc2.. not 2.4.22.

Regards
Henrik
