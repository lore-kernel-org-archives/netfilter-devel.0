From: "Toshihiro Sonoda" <toshihiro@jp.fujitsu.com>
Subject: Re: about ROUTE target
Date: Thu, 19 Sep 2002 01:12:38 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <031b01c25f2e$35ddd520$fb01a8c0@monday>
References: <002f01c25e5e$46745100$ecf8a8c0@monday> <1032346636.2377.4.camel@descartes>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Cc: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-15?Q?C=E9dric_de_Launois?= <delaunoi@info.ucl.ac.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Launois.

In the following case, while ipt_ROUTE action, which is
the ipt_route_target(), is processing, another netfiter action is called.
Is it able to call one netfiter action during processing another one?

ROUTE action is called when PRE_ROUTING rule is matched, after
that, in the PRE_ROUTING action, OUTPUT and POST_ROUTING
is called. so, nf_hook_slow() is nested.

Is that ok??

thanks for your advice.


> > I confirmed that ipt_route_target(), which is in "ipt_ROUTE.c", hook function
> > in the ROUTE target was called in the router's linux kernel,
> > and ipgre_tunnel_xmit() in gre's tunneling device(ip_gre.c) was called.
> >
> > But, the at the IPTUNNLE_XMIT() called in the ipgre_tunnel_xmit(), linux
> > was freezed.
> >
> > Do I mistake how to use the ROUTE target ?
>
> It seems you found a bug. I'll take a look to this problem as soon as
> possible. Thanks for having reported this bug.
>
> Cédric de Launois
>
>
>
>
