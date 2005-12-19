From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] pptp conntrack broken when non-modular
Date: Mon, 19 Dec 2005 10:28:19 +0100
Message-ID: <43A67D33.70005@trash.net>
References: <20051218194848.GA1038@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20051218194848.GA1038@linuxace.com>
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

Phil Oester wrote:
> The GRE protocol helper of PPTP does not get properly registered
> when it is built in, because ip_nat_proto_gre_init runs prior to
> ip_nat_init, so ip_nat_protos is unitialized when ip_nat_proto_gre_init
> tries to register protocol 47.
> 
> Changing ip_nat_protocol_register to unconditionally register solves
> half the problem.  But then when ip_nat_init does run, it overwrites
> the registration with ip_nat_unknown_protocol.  So the second
> part of the fix is to change ip_nat_init not to overwrite previously
> registered protos.

I think the correct fix is to change the initialisation order so
the NAT core comes before protocol helpers. I'm going to look into
this.
