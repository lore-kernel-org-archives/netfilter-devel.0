From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 10:59:12 +0200
Message-ID: <4462FCE0.20300@astaro.com>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
	<4462CD64.1060507@net.in.tum.de>
	<20060511083925.GD10324@sunbeam.de.gnumonks.org>
	<4462F95A.7060305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Gregor Maier <gregor@net.in.tum.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4462F95A.7060305@trash.net>
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

Patrick McHardy wrote:

>>I now actually like the idea that the old LOG target and old ULOG target
>>just continue to do what the used to do. 

> I fully agree. I already changed the default behaviour back to just use
> their own logging functions, nf_log backends can be used by specifying
> an extra flag. This isn't supported by userspace so far, so we are free
> to rip it out again.

IMO this is the best solution too, since the current way is not very 
transparent to the user.  Worse than that, ULOG even is stamped 
"deprecated" in kconfig of 2.6.15.y, so most people will just be able 
use the limited arguments of the LOG target.

-- 
Holger Eitzenberger <heitzenberger@astaro.com> | Kernel Developer
Astaro AG | www.astaro.com | Phone +49-721-25516-246 | Fax -200

Astaro Security Linux
- PC Magazine Best of the Year 2004/2005
- CRN Best of the Year 2005
- SC Magazine "Best Buy" & 5 star rating - October 2005, Best of the 
Year 2005
- Internet Professionell "Empfehlung der Redaktion" - November 2005
