From: Patrick McHardy <kaber@trash.net>
Subject: Re: load balacing with https home banking
Date: Thu, 14 Dec 2006 11:47:03 +0100
Message-ID: <45812BA7.3000809@trash.net>
References: <BAY103-DAV25AE1C31A08B7725D1CACB2D60@phx.gbl>	<4580827A.7090708@trash.net>
	<BAY103-DAV11AB3769A4A2BB8625C42AB2D50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-DAV11AB3769A4A2BB8625C42AB2D50@phx.gbl>
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

Marco Berizzi wrote:
> Patrick McHardy wrote:
> 
>>Different TOS values might still break the thing, for it should work
> 
> for
> 
>>HTTP/HTTPS.
> 
> 
> Just for ask: why different TOS values should break?

Cached routes are keyed on (src,dst,iif,oif,mark,tos).
Different tos values cause new routing lookups which
might result in a different path.
