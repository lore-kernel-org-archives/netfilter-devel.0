From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Iptables 1.3.1 still not very fast.
Date: Sun, 3 Apr 2005 23:11:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504032310260.16488@filer.marasystems.com>
References: <89b63d049739b257@mayday.cix.co.uk>
	<20050402124038.0201.LARK@linux.net.cn>
	<ade359ba902d15c6@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert de Bath <list-netfilter@debath.co.uk>
In-Reply-To: <ade359ba902d15c6@mayday.cix.co.uk>
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

On Sat, 2 Apr 2005, Robert de Bath wrote:

> So you actually need two hashtables for the example 'blacklist' one in
> each mode.  For an IP packet a single lookup is needed on the ip-address
> hash but upto 30 lookups would be needed on the net-address hash.

For networks/ranges hash tables is the wrong kind of data structure. Trees 
are much more appropriate for this form of data.

Regards
Henrik
