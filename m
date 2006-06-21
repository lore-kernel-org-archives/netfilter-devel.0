From: <pneira@us.es>
Subject: Re: [CONNTRACKD]: Fix segfault
Date: Wed, 21 Jun 2006 23:49:05 +0200
Message-ID: <f3789a8e1eabc.4499daf1@us.es>
References: <Pine.LNX.4.64.0606201514360.8549@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Language: es
In-Reply-To: <Pine.LNX.4.64.0606201514360.8549@bizon.gios.gov.pl>
Content-Disposition: inline
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



----- Mensaje original -----
De: Krzysztof Oledzki <olenf@ans.pl>
Fecha: Martes, Junio 20, 2006 3:40 pm
Asunto: [CONNTRACKD]: Fix segfault
A: Pablo Neira Ayuso <pablo@netfilter.org>
CC: netfilter-devel@lists.netfilter.org

> Hello,
> 
> Attached (trivial) patch fixes segfault in conntrackd caused by 
> wrong 
> "usage" calls.

Thanks, I'm going to include it in 0.8.2 that will be released soon.
