From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_ROUTE for kernel 2.6.21.5
Date: Mon, 30 Jul 2007 21:44:14 +0200
Message-ID: <46AE3F8E.7090908@trash.net>
References: <2cb453e80707300742i66b81b95pde18e37a6db046d5@mail.gmail.com>
	<Pine.LNX.4.64.0707301644360.26373@fbirervta.pbzchgretzou.qr>
	<46ADF9FA.4000901@trash.net>
	<Pine.LNX.4.64.0707301649000.26373@fbirervta.pbzchgretzou.qr>
	<46ADFACE.5040304@trash.net>
	<Pine.LNX.4.64.0707301709370.4354@bizon.gios.gov.pl>
	<46AE0501.3080107@trash.net> <20070730163946.GA8438@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Ludovic <ludovic.mailinglist@gmail.com>,
	netfilter-devel@lists.netfilter.org
To: Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070730163946.GA8438@oknodo.bof.de>
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

Patrick Schaaf wrote:
>>>1. ROUTE has a very usefull option --tee. AFAIK it is not possible to do
>>>it other way.
>>
>>Thats true. Not sure in what practical situation it is used though.
> 
> 
> iptables -A INPUT -p tcp --dport 25 -j ROUTE --tee --gw lawful.inspection.box
> 
> In other words: network traffic taps.


Yeah, I was already thinking of that, but bonding allows to do
that on a per-device base. Not sure if that helps ..

> If the feature is removed from POM, I'll probably be forced by
> colleagues to maintain it in some other form. Sigh.

Krzysztof expressed interest in maintaining it ..
