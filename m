From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: New API / POM modules to merge....
Date: Wed, 10 Nov 2004 00:07:03 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411092358200.10593@filer.marasystems.com>
References: <20041108134743.217B817BE5@grasshopper.anduras.de>
	<418FD708.3030302@anduras.de>
	<Pine.LNX.4.61.0411082226010.21933@filer.marasystems.com>
	<4190E80C.8020106@anduras.de>
	<Pine.LNX.4.61.0411092003470.7243@filer.marasystems.com>
	<41913C78.6050109@anduras.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <41913C78.6050109@anduras.de>
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

On Tue, 9 Nov 2004, Sven Anders wrote:

> But does a possible misconfiguration justify this?

In case of TTL yes, or at least that is the general concensus among all 
the netfilter developers.

I hope you understand why increases of the IP TTL is very dangerous to IP 
networking. If you want to compare with something else then a reasonable 
comparisation is a mail relay removing all Received lines while forwarding 
the messages, this is about as dangerous for much the same reasons.

The tool is there, but you need to work a little harder to get access to 
it. From experience it is known that if such tools are available in 
mainline then users who do not have a clue what they are doing will use it 
without understanding the implications or limitations of how such tool can 
be safely used.

Regards
Henrik
