From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: CONNMARK behaviour
Date: Fri, 15 Apr 2005 10:06:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504151002410.19084@filer.marasystems.com>
References: <200504141447.19432.adrian.turcu@gmvinteractive.com>
	<Pine.LNX.4.61.0504150220340.3687@filer.marasystems.com>
	<200504150900.07990.adrian.turcu@gmvinteractive.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Adrian Turcu <adrian.turcu@gmvinteractive.com>
In-Reply-To: <200504150900.07990.adrian.turcu@gmvinteractive.com>
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

On Fri, 15 Apr 2005, Adrian Turcu wrote:

> So, if the above is correct, instead of using the combination --set-mark (by
> MARK) then --save-mark (by CONNMARK), one can use --set-mark and
> --restore-mark (both by CONNMARK) in this very order to save the mark for the
> connection packet? Am I correct assuming this?

Yes. Any sequence which sets both the packet mark and the connection mark 
is fine.

   CONNMARK --set-mark
   CONNMARK --restore-mark
or
   CONNMARK --set-mark
   MARK --set-mark
or
   MARK --set-mark
   CONNMARK --save-mark

Regards
Henrik
