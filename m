From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Multiple Address specification or match
Date: Fri, 1 Oct 2004 12:39:45 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0410011238520.12730@filer.marasystems.com>
References: <003301c4a6cc$069e3fb0$2201010a@bluereef.local>
	<Pine.LNX.4.61.0409301336380.29461@filer.marasystems.com>
	<015601c4a792$6890f250$2201010a@bluereef.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, Swapnil Nagle <swapsn@rediffmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Temp02 <temp02@bluereef.com.au>
In-Reply-To: <015601c4a792$6890f250$2201010a@bluereef.local>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 1 Oct 2004, Temp02 wrote:

> iptables -m iprange 10.0.0.0-10.255.255.255 -m iprange
> 172.16.0.0-172.16.255.255
>
> is this an easy to add switch somewhere?

Should work fine, except that it will then be a AND (both ranges must 
match) so it does not make much sense..

Regards
Henrik
