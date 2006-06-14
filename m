From: Patrick McHardy <kaber@trash.net>
Subject: Re: Concurrency issues with the iptables userspace
	program	andexitcodes
Date: Wed, 14 Jun 2006 16:05:10 +0200
Message-ID: <44901796.6040000@trash.net>
References: <1149153349.28481.15.camel@localhost.localdomain>	
	<447F1227.7050900@trash.net>	
	<Pine.LNX.4.61.0606012200260.27621@ask.diku.dk>	
	<447F5204.4080505@trash.net>
	<1149771143.28481.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Dangaard Brouer <hawk@comx.dk>
In-Reply-To: <1149771143.28481.87.camel@localhost.localdomain>
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

Jesper Dangaard Brouer wrote:
> For example something like the following patch?
> 
> I have tracked down where the "Resource temporarily unavailable" occurs
> in libiptc.c, and marked it with a comment... if you can use it for any
> thing.

Seems like you forgot to attach the patch :)
