From: Venkata Narayana <mesg2nari@yahoo.com>
Subject: Re: REDIRECT changes DST address of the packet
Date: Sun, 24 Jul 2005 21:54:09 -0700 (PDT)
Message-ID: <20050725045409.35744.qmail@web60823.mail.yahoo.com>
References: <Pine.LNX.4.61.0506301308290.3095@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0506301308290.3095@yvahk01.tjqt.qr>
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

Hi,

Thanks,
I am able to get the original dst address when I am
using tcp connection.
How can I get with UDP???
I my case of UDP we bind to single
fd and all packets irrespective of original
destination get delivered to same fd.

Thanks,
Venkat.


--- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> >Hello,
> > 
> >My question is if I use REDIRECT action in
> >NAT PREROUTING table  is it going to change the tcp
> >packet DST address.
> > 
> >If I lose original DST address, how can I persist
> >that value in that packet.
> 
> You can't really with PREROUTING (except of course,
> said getsockopt() call)
> If you want to transparently redirect packets, you
> might want to use ROUTE or 
> TPROXY, depending on what you really want.
> 
> 
> 
> Jan Engelhardt                                      
>                         
> --                                                  
>                          
> | Gesellschaft fuer Wissenschaftliche
> Datenverarbeitung Goettingen,
> | Am Fassberg, 37077 Goettingen, www.gwdg.de
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
