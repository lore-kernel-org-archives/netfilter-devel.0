From: Ranjeet Shetye <ranjeet.shetye2@zultys.com>
Subject: Re: examples on flow rate monitoring and token bucket filter
Date: 30 Jan 2003 13:16:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1043928984.567.11.camel@ranjeet-linux-1>
References: <Pine.LNX.4.44.0301301018140.6884-100000@yen.isi.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0301301018140.6884-100000@yen.isi.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-01-30 at 19:20, Xuan Chen wrote:
> Hi,
> 
> Could somebody give me some reference on how to extend netfilter/iptables 
> to monitor incoming flow rate? Also, how to implement a token bucket 
> filters with netfilter/iptables? Thaks.
> 
> Cheers,
> -chen
> 
> -- 
> Xuan Chen
> USC/ISI
> 
> 

Hi Chen,

Nice to see someone from USC/ISI.

Are you by any chance looking to do something similar to
"extensions/libipt_limit.c" in "iptables-1.2.7a" ? It contains
flow-tracking by packet count and it also contains a limit-burst which
should solve your token bucket requirement.

There's also an "extensions/libipt_iplimit.c" which I believe tracks
packets by IP addresses and enforces limits.

HTH

-- 
Ranjeet Shetye
Senior Software Engineer
Zultys Technologies
Ranjeet dot Shetye2 at Zultys dot com
http://www.zultys.com/

The views, opinions, and judgements expressed in this message are solely
those of
the author. The message contents have not been reviewed or approved by
Zultys.
