From: "dais" <dais00@mails.tsinghua.edu.cn>
Subject: RE: hi,anyone know where ippool v2.0 goes.
Date: Thu, 3 Oct 2002 17:24:56 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000a01c26abe$bd10a3b0$0f966fa6@dais>
References: <20021003074643.GD9998@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Joakim Axelsson'" <gozem@aaricia.hemmet.chalmers.se>,
	<netfilter-devel@lists.netfilter.org>
In-Reply-To: <20021003074643.GD9998@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

got it.
thank you very much:-)

> -----Original Message-----
> From: netfilter-devel-admin@lists.netfilter.org 
> [mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf 
> Of Joakim Axelsson
> Sent: Thursday, October 03, 2002 3:47 PM
> To: dais; netfilter-devel@lists.netfilter.org
> Subject: Re: hi,anyone know where ippool v2.0 goes.
> 
> 
> 2002-10-03 08:53:26+0200, Joakim Axelsson 
> <gozem@aaricia.hemmet.chalmers.se> ->
> > 2002-10-03 13:57:22+0800, dais <dais@ccert.edu.cn> ->
> > > hi,
> > > 
> > >     i searched the list and find somebody rewrite ippool
> > > and aimed to add hash mode that is very useful in my opinion.
> > > but i can't find anything more.If nobody continues,i'll consider 
> > > to do that.any advices?
> > >     thx
> > >     Pluto.Dai
> > > 
> > 
> > Code is almost finished. Havn't had time to put the last things 
> > togther though.
> > 
> 
> You can find the code so far at: 
> http://aaricia.hemmet.chalmers.se/~gozem/ippool/
> 
> Please 
> understand that this code is HIGHLY under development. 
> However this code seams stable, but not finished on all 
> parts. Its NOT a patch so you have to have good knowlage 
> about how to install additional files and get them to work 
> with Makefiles etc. in kernel. Please do not ask me how to 
> install it. If you don't know you shouldn't be using this code (yet).
> 
> Also, the API between ippool mainframe and the ippool 
> pool-types are subject to change. So don't put in too much 
> work into writing your own pool-types unless preperad to 
> convert them fiting a new API.
> 
> Unfinished parts:
> * ippool -R and -S (restore and save) is not yet implemented.
> * Will move the looks from mainfram to each pooltype to 
> handle instead.
> * Add a few more pooltype: hash, timehash, nettree, 
> portbitmap, accounting,
>   limitbitmaps.
> * Also convert it more to not only handle IP, but handle skbs instead,
>   meaning a pool can contain anything matching a skb. eg. ipv4, ipv6,
>   tcp-ports. This is almost finished.
> 
> A side note. This is ippool 0.3, the ippool in netfilter cvs 
> is 0.1. When stable it will go 1.0
> 
> Have fun! :-)
> 
> -- 
> /Joakim Axelsson A.K.A Gozem@EFnet
> 
