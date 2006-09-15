From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_LOG split MAC
Date: Fri, 15 Sep 2006 06:26:58 +0200
Message-ID: <450A2B92.7020604@trash.net>
References: <edsbl9$eq$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Danny Rathjens <gmane@rathjens.org>
In-Reply-To: <edsbl9$eq$1@sea.gmane.org>
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

Danny Rathjens wrote:
> Is a patch like this sensible?
> with the log messages currently looking like:
>  IN=eth0 OUT= MAC=00:c0:49:5f:9a:0d:00:00:c5:66:00:28:08:00
> SRC=72.234.128.92 DST=72.1.142.189  ...
> it's hard to tell what the source or destination MAC address is.
> 
> I just split the MAC header in half, but now that I am reading more about
> variable length MAC addresses I don't think that is the right way to do it.
> 
> Just spitting out the raw header seems pretty efficient, too.  Perhaps that
> is by design for efficienecy as opposed to laziness? :)

I don't think so :) We can't change it however since that would most
likely break lots of existing log file parsers.
