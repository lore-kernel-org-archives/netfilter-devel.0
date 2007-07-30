From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_ROUTE for kernel 2.6.21.5
Date: Mon, 30 Jul 2007 17:34:25 +0200
Message-ID: <46AE0501.3080107@trash.net>
References: <2cb453e80707300742i66b81b95pde18e37a6db046d5@mail.gmail.com>
	<Pine.LNX.4.64.0707301644360.26373@fbirervta.pbzchgretzou.qr>
	<46ADF9FA.4000901@trash.net>
	<Pine.LNX.4.64.0707301649000.26373@fbirervta.pbzchgretzou.qr>
	<46ADFACE.5040304@trash.net>
	<Pine.LNX.4.64.0707301709370.4354@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Ludovic <ludovic.mailinglist@gmail.com>,
	netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707301709370.4354@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> 1. ROUTE has a very usefull option --tee. AFAIK it is not possible to do
> it other way.


Thats true. Not sure in what practical situation it is used though.

> 2. Policy routing based on fwmark is not always an option if you use
> marks for other purposes.


Maybe (trying to avoid getting into discussion about too small mark
values again :)).

> So, if it is going to be removed from pom-ng I would like to keep it in
> my external pomng-repository.


Please go ahead.

Just FYI: One more reason for removing it is that its broken wrt.
IPsec handling and the duplicated functions from ip_output are out
of sync (and I think there were a few smaller problems as well).
If there really is a need for something like the tee functionality
I'm not opposed to considering merging a clean patch without these
problems for that.
