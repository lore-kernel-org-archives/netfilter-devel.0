From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Fri, 08 Apr 2005 14:46:13 +0200
Message-ID: <42567D15.8090102@eurodev.net>
References: <424747D5.8060500@eurodev.net>	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>	<4254265F.6080607@eurodev.net>	<42554200.3020405@ufomechanic.net>	<42555F99.8010201@ufomechanic.net>	<42564BA6.3040702@ufomechanic.net>	<42564FAA.2050302@eurodev.net>	<425658A8.6050200@ufomechanic.net>	<42565AB4.5000803@eurodev.net>
	<42567910.4090601@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42567910.4090601@ufomechanic.net>
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

Amin Azez wrote:
> Thanks for the patches Pablo, they seemed to do the trick.
> ctnl_del_conntrack has been expanded to 3 args, should I be using 
> CTA_UNSPEC or CTA_ORIG or CTA_STATUS as the 3rd arg on line 118 of 
> ctnltest.c?

+int ctnl_del_conntrack(struct ctnl_handle *cth,
+                      struct ip_conntrack_tuple *tuple,
+                      enum ctattr_type_t t)

The 3rd arguments says if you're referring to CTA_ORIG or CTA_RPLY. So 
you can kill conntracks based on the direction.

This stuff is under development so nobody can't assure that the API will 
change in future.

> ctnl_del_conntrack(cth, NFA_DATA(cb[CTA_ORIG]),XXXXX);
> 
> For the record, to help those who follow, to get libctnetlink and 
> libnfnetlink working, here are the instructions.
> 
> 1) unpack the pristine kernel sources of 2.6.11
> 2) apply pablos patches from 
> http://people.netfilter.org/pablo/patches/nfnetlink-conntrack-0.50-2.6.11/
> 3) build and install your kernel & modules with all the right NF options 
> enabled
> 4) unpack a recent libctnetlink from 
> ftp://ftp.netfilter.org/pub/libctnetlink/snapshot/
> 5) run:
>   automake-1.4
>   autoconf
> 6) unpack a recent libnfnetlink from 
> ftp://ftp.netfilter.org/pub/libnfnetlink/snapshot/
> make a symlink from libnfnetlink-2005xxxx to libnfnetlink so that 
> libctnetlink can find it
> 7) run:
>   automake-1.4
>   autoconf
> 8) inside the libctnetlink dir
> ./configure
> make
> make install
> 9) inside the libnfnetlink dir
> ./configure
> make
> make install

Thanks, people surely would appreciate this to save time.

> Attached is my candidate patch for ctnltest.c which can be compiled with:

fix ctnl_del_conntrack, CTA_UNSPEC isn't ok as 3rd param.

--
Pablo
