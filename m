From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xx_nat_proto_gre: gre_key returns wrong pointer
Date: Fri, 27 Apr 2007 13:21:07 +0200
Message-ID: <4631DCA3.4020701@trash.net>
References: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>	<462DFD1D.1060706@trash.net>
	<101c01c78829$24a70230$061010ac@intranet.dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <101c01c78829$24a70230$061010ac@intranet.dti2.net>
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

Jorge Boncompte [DTI2] wrote:
>    Hi, Patrick take a look at this patch when you have time please. I
> tested it and behaves correctly, I can run one and only one GRE tunnel
> though a NATing box and PPTP still works too, if you try with a second
> tunnel from different host by the fact of not modifying the tuple it does
> not work as the comment in get_unique_tuple says.

> +++ linux-2.6.21/net/ipv4/netfilter/ip_nat_proto_gre.c 2007-04-26
> 19:01:02.000000000 +0200
> @@ -70,6 +70,11 @@
>  __be16 *keyptr;
>  unsigned int min, i, range_size;
> 
> + /* If there is no master conntrack we are not PPTP,
> +    do not change tuples */
> + if (!conntrack->master)
> +  return 0;
> +


Thats a good idea, I thought it would be more complicated to
determine the kind of connection in get_unique_tuple() since
it doesn't get to see the packet.

Please sign off on the patch so I can apply it.
