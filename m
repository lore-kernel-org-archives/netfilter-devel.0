From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: connbytes & 64bit counters
Date: Sat, 21 Jul 2007 18:38:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707211834420.21737@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
	<Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
	<4565AAC7.8050702@trash.net> <45660CD5.1090405@netfilter.org>
	<4566B6B6.4060808@trash.net>
	<Pine.LNX.4.64.0612250252060.27316@bizon.gios.gov.pl>
	<45A4EBC8.60304@trash.net>
	<Pine.LNX.4.64.0701151141410.13986@bizon.gios.gov.pl>
	<45AB919A.4030100@trash.net>
	<Pine.LNX.4.64.0707202350290.4877@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707210038370.7261@bizon.gios.gov.pl>
	<46A18926.6040402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Krzysztof Oledzki <olenf@ans.pl>, Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A18926.6040402@trash.net>
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

On Jul 21 2007 06:18, Patrick McHardy wrote:
>
>(considering distributors that waste 16 bytes per conntrack for a feature
>pratically *nobody* uses,
>
>Opinions are welcome.

Break compatibility -- if there are any users (you assume there are none),
they will surely turn up.


	Jan
-- 
