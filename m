From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Iptables 1.3.1 still not very fast.
Date: Sat, 2 Apr 2005 11:10:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504021048050.29334@filer.marasystems.com>
References: <89b63d049739b257@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert de Bath <list-netfilter@debath.co.uk>
In-Reply-To: <89b63d049739b257@mayday.cix.co.uk>
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

On Fri, 1 Apr 2005, Robert de Bath wrote:

> My problem is that I think that libiptc looks evil and I really don't
> want to dive into messing with that code. So how can I help to make
> libiptc run as fast as I'd like it to?

First step is to get a profile on where the time is spent...

   gperf/OProfile/FunctionCheck

Regards
Henrik
