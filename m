From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [IPTABLES PATCH] chain name should not start with '!'
Date: Fri, 03 Jun 2005 18:24:24 +0900 (JST)
Message-ID: <200506030924.j539OO3p007280@toshiba.co.jp>
References: <200506030803.j5383iXf006561@toshiba.co.jp>
	<42A015D0.8080300@eurodev.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Jun__3_18:24:24_2005_234)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <42A015D0.8080300@eurodev.net>
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

----Next_Part(Fri_Jun__3_18:24:24_2005_234)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Good point. Here you are,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

From: Pablo Neira <pablo@eurodev.net>
Date: Fri, 03 Jun 2005 10:33:20 +0200

> Hi Yasuyuki,
> 
> Yasuyuki KOZAKAI wrote:
> > This patch fixes the bug allows to create the chain with name "!".
> > 
> > Regards,
> > 
> > -----------------------------------------------------------------
> > Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
> > 
> > 
> > ------------------------------------------------------------------------
> > 
> > Index: iptables.c
> > ===================================================================
> > --- iptables.c	(revision 3951)
> > +++ iptables.c	(working copy)
> 
> please, could you send the same fix for ip6tables.c? it's got the same 
> problem.
> 
> Thanks,
> Pablo

----Next_Part(Fri_Jun__3_18:24:24_2005_234)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ip6tables.patch"

Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 3951)
+++ ip6tables.c	(working copy)
@@ -1822,10 +1822,10 @@
 			break;
 
 		case 'N':
-			if (optarg && *optarg == '-')
+			if (optarg && (*optarg == '-' || *optarg == '!'))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
-					   "with `-'\n");
+					   "with `%c'\n", *optarg);
 			if (find_target(optarg, TRY_LOAD))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "

----Next_Part(Fri_Jun__3_18:24:24_2005_234)----
