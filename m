From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_u32 kernel 20070620_2
Date: Wed, 20 Jun 2007 14:25:59 +0200
Message-ID: <46791CD7.2060206@trash.net>
References: <Pine.LNX.4.64.0706200037570.5731@fbirervta.pbzchgretzou.qr>
	<4678F9E3.7050002@netfilter.org>
	<Pine.LNX.4.64.0706201209310.5731@fbirervta.pbzchgretzou.qr>
	<467909FF.5060904@netfilter.org>
	<Pine.LNX.4.64.0706201257490.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706201257490.5731@fbirervta.pbzchgretzou.qr>
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
> Along comes... xt_u32, a revamped ipt_u32 from POM-NG,


Looks good, I'll apply it later if Pablo doesn't have more comments.

> +MODULE_AUTHOR("Don Cohen <don@isis.cs3-inc.com>");


This should really be your name I guess. You wrote this version
and Don hasn't been active for years. I can change that before
applying.
