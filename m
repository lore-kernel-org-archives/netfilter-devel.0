From: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: nf-log error
Date: Thu, 4 Mar 2004 10:30:56 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0403041018260.17674@alpha.zarz.agh.edu.pl>
References: <20040229151700.GA26747@pcw.home.local>
 <Pine.LNX.4.44.0402291720220.27254-100000@filer.marasystems.com>
 <20040229172703.GI15558@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040229172703.GI15558@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi
I try to applay patch-o-matic-ng snap-20040304 on linux-2.6.4-rc2 kernel
by "./runme base", and I found some errors :)

Can any one fix this?

1) expect-optimize gaot 7 error, all is OK when I canged definition
FROM:
--- ../linux-2.6.3-old/net/
+++ net/
TO:
--- linux-2.6.3-old/net
+++ linux-2.6.3/net/

2) nf-log
thesame problem was on 2.6.3.
here are *.rej file
[ipt_LOG.c.rej]
***************
*** 415,426 ****
  {
  	if (ipt_register_target(&ipt_log_reg))
  		return -EINVAL;
  
  	return 0;
  }
  
  static void __exit fini(void)
  {
  	ipt_unregister_target(&ipt_log_reg);
  }
  
--- 448,463 ----
  {
  	if (ipt_register_target(&ipt_log_reg))
  		return -EINVAL;
+ 	if (nflog)
+ 		nf_log_register(PF_INET, &ipt_logfn);
  
  	return 0;
  }
  
  static void __exit fini(void)
  {
+ 	if (nflog)
+ 		nf_log_unregister(PF_INET, &ipt_logfn);
  	ipt_unregister_target(&ipt_log_reg);
  }
  
[ip6t_LOG.c.rej]
***************
*** 422,432 ****
  
  static int __init init(void)
  {
  	return ipt_register_target(&ipt_log_reg);
  }
  
  static void __exit fini(void)
  {
  	ipt_unregister_target(&ipt_log_reg);
  }
  
--- 455,470 ----
  
  static int __init init(void)
  {
+ 	if (nflog)
+ 		nf_log_register(PF_INET, &ipt_logfn);
  	return ipt_register_target(&ipt_log_reg);
  }
  
  static void __exit fini(void)
  {
+ 	if (nflog)
+ 		nf_log_unregister(PF_INET, &ipt_logfn);
+ 
  	ipt_unregister_target(&ipt_log_reg);
  }
  
-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
