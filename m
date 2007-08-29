From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH] ipt_ROUTE for kernel 2.6.21.5
Date: Wed, 29 Aug 2007 14:12:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708291402360.17880@bizon.gios.gov.pl>
References: <2cb453e80707300742i66b81b95pde18e37a6db046d5@mail.gmail.com>
	<Pine.LNX.4.64.0707301644360.26373@fbirervta.pbzchgretzou.qr>
	<46ADF9FA.4000901@trash.net>
	<Pine.LNX.4.64.0707301649000.26373@fbirervta.pbzchgretzou.qr>
	<46ADFACE.5040304@trash.net>
	<Pine.LNX.4.64.0707301709370.4354@bizon.gios.gov.pl>
	<46AE0501.3080107@trash.net>
	<Pine.LNX.4.64.0708291318130.4125@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0708291355230.24730@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1008100498-1188389538=:17880"
Cc: Ludovic <ludovic.mailinglist@gmail.com>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708291355230.24730@fbirervta.pbzchgretzou.qr>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1008100498-1188389538=:17880
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 29 Aug 2007, Jan Engelhardt wrote:

>
> On Aug 29 2007 13:23, Krzysztof Oledzki wrote:
>>
>>> Just FYI: One more reason for removing it is that its broken wrt.
>>> IPsec handling
>>
>> Could you explain it a bit? What is wrong and maybe some clue how it sho=
uld be
>> fixed?
>
> ip_direct_send does not do IPSEC IIRC.

Neither ip_finish_output2 which is a place from this code comes from.=20
Anyway, I found that indeed ip_finish_output, which calls=20
ip_finish_output2, contains xfrm code:

#if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
         /* Policy lookup after SNAT yielded a new policy */
         if (skb->dst->xfrm !=3D NULL) {
                 IPCB(skb)->flags |=3D IPSKB_REROUTED;
                 return dst_output(skb);
         }
#endif

Is that all?

So, how it should work with ROUTE? I assume that teed packets shouldn't=20
go via xfrm, neither directly (--gw, --oif) routed packets if there is no=
=20
tee, right?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1008100498-1188389538=:17880--
