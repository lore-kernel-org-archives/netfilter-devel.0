From: Patrick McHardy <kaber@trash.net>
Subject: Re: New extension: CRYPT target
Date: Fri, 26 May 2006 20:25:34 +0200
Message-ID: <4477481E.2070000@trash.net>
References: <44708E68.9080508@speedy.com.ar>	<20060525161148.GA2376@ecstasy.ring2.lan>
	<44774516.5020406@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: <44774516.5020406@speedy.com.ar>
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

Gervasio Bernal wrote:
> I think the idea of encryption using Iptables is really great!

The thing I don't get: what advantages does it have over using
IPsec with manual keying (forgetting about the selector, once
nfmark is supported this point won't matter)?
