From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] ipt_ROUTE for kernel 2.6.21.5
Date: Wed, 29 Aug 2007 13:55:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708291355230.24730@fbirervta.pbzchgretzou.qr>
References: <2cb453e80707300742i66b81b95pde18e37a6db046d5@mail.gmail.com>
	<Pine.LNX.4.64.0707301644360.26373@fbirervta.pbzchgretzou.qr>
	<46ADF9FA.4000901@trash.net>
	<Pine.LNX.4.64.0707301649000.26373@fbirervta.pbzchgretzou.qr>
	<46ADFACE.5040304@trash.net>
	<Pine.LNX.4.64.0707301709370.4354@bizon.gios.gov.pl>
	<46AE0501.3080107@trash.net>
	<Pine.LNX.4.64.0708291318130.4125@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ludovic <ludovic.mailinglist@gmail.com>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708291318130.4125@bizon.gios.gov.pl>
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


On Aug 29 2007 13:23, Krzysztof Oledzki wrote:
>
>> Just FYI: One more reason for removing it is that its broken wrt.
>> IPsec handling
>
> Could you explain it a bit? What is wrong and maybe some clue how it should be
> fixed?

ip_direct_send does not do IPSEC IIRC.


	Jan
-- 
