From: Patrick McHardy <kaber@trash.net>
Subject: Re: DPRINTK -> pr_debug conversion
Date: Mon, 18 Jun 2007 14:12:19 +0200
Message-ID: <467676A3.60807@trash.net>
References: <Pine.LNX.4.64.0706091059550.14652@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706091059550.14652@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> I've get compile errors when replacing DPRINTK by pr_debug. That's 
> because variables, structs and internals changed over time, while the 
> dprintks did not. (net/netfilter/xt_helper.c for example. Turn the #if 0 
> into #if 1 and see.)


I know, it happens from time to time, we try to fix them as they get
noticed. Anyways, just a conversion that doesn't introduce new errors
is fine :)
