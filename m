From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Wed, 13 Dec 2006 10:17:02 +0100
Message-ID: <457FC50E.70009@trash.net>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>	<457E6997.1050001@trash.net>	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>	<457FBBFD.6060009@trash.net>
	<44824.195.55.244.106.1166001170.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: linux@arcoscom.com
In-Reply-To: <44824.195.55.244.106.1166001170.squirrel@www.arcoscom.com>
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

ArcosCom Linux User wrote:
> Then, the actual and updated and maintained substitute for ROUTE is using
> CONNMARK and/or MARK and then add filters/rules to routes table with ip.
> Am I in the truth?


That has always been the better way. The route target is a hack, I'm
don't know why it exists at all.
