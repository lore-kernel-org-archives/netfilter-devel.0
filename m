From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: New API / POM modules to merge....
Date: Wed, 10 Nov 2004 00:46:27 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411100042200.10593@filer.marasystems.com>
References: <20041108134743.217B817BE5@grasshopper.anduras.de>
	<418FD708.3030302@anduras.de>
	<Pine.LNX.4.61.0411082226010.21933@filer.marasystems.com>
	<4190E80C.8020106@anduras.de>
	<Pine.LNX.4.61.0411092003470.7243@filer.marasystems.com>
	<41913C78.6050109@anduras.de>
	<Pine.LNX.4.61.0411092358200.10593@filer.marasystems.com>
	<41914FB6.4050502@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41914FB6.4050502@trash.net>
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

On Wed, 10 Nov 2004, Patrick McHardy wrote:

> I think there is another reason. I simply can't see any reason
> to actually use it. Of course I might be missing something.

There is a couple of valid reasons such as to counter-measure ISP 
restrictions on link usage where the ISP enforces a single computer use 
policy by filtering on "normal" TTLs and thereby blocking users trying to 
share the link using a masquerading router (aka "broadband router"), but 
generally playing with the ttl in this manner is nonsense and there is 
other ways around such restrictions should it be needed.

Regards
Henrik
