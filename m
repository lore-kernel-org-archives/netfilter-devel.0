From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Thu, 27 May 2004 12:33:54 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405271232190.11108-100000@filer.marasystems.com>
References: <40B33E37.4070807@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40B33E37.4070807@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 25 May 2004, Pablo Neira wrote:

> if we use atomic operations *_bit for status field in ip_conntrack, we 
> only use 24 bits of that unsigned long, this issue lets us keep 
> compatibility with some special platforms which only support atomic 
> operations of that size.

Correct. This is also documented int the Kernel API IIRC.

It can be noted however that out of those 24 bits conntrac only uses a 
few, leaving plenty of bits for expansion usage without having to increase 
the size of ip_conntrack.

Regards
Henrik
