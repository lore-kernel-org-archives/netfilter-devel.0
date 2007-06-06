From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Wed, 06 Jun 2007 18:06:38 +0200
Message-ID: <4666DB8E.1070205@trash.net>
References: <200706061718.l56HIjv08406@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706061718.l56HIjv08406@server1.secure-linux-server.com>
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

Amin Azez wrote:
> So is it necessary to resubmit the kernel patch with the un-necessary matches turned into explanatory comments?


I'd call them useless comments, so please no :) No, seriously,
I don't want to start that, people copy too much useless comments
around already. I don't want every match to state that skb is
never NULL and that its only called for AF_INET packets since
it only registered for AF_INET.

Please just remove them.
