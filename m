From: "Fulvio Ricciardi" <fulvio.ricciardi@zeroshell.net>
Subject: Re: ipt_time module doesn't work
Date: Sat, 02 Dec 2006 14:11:09 +0100
Message-ID: <45717b6d.2e1.4709.4420592@webmailh2.aruba.it>
Reply-To: fulvio.ricciardi@zeroshell.net
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
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


> On Sat, 2 Dec 2006, Fulvio Ricciardi wrote:

> > I noticed ipt_time doesn't work with the kernels
> > 2.6.18.2 and 2.6.19.
> > The error messages is the following:
> >
> > iptables -A INPUT -mtime
> > iptables: Unknown error 4294967295
> >
> > Is it possible to solve the problem? will time extention
> > be broken for ever?
> >
> > Thanks you in advance for  your replies.
> > Best Regards
> 
> Strange, it _should_ work, and it works for me:
> 
> root@fw1:~#  iptables -A INPUT -mtime
> root@fw1:~# iptables -L INPUT
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
>             0    --  anywhere             anywhere        
>    TIME on all  days
> root@fw1:~# uname -r
> 2.6.18.1
> 
> Where did you get ipt_time from?
patch-o-matic-ng-20061129.tar.bz2  no longer contain
ipt_time patch. The latest one that contain it is
patch-o-matic-ng-20060706.tar.bz2.
I noticed iptables-1.3.6 already contains it but kernel has
not ipt_time included.
Am I wrong?
Regards


--------------------------------------------------------------------
Fulvio Ricciardi
web: http://www.zeroshell.net/eng/
skype: zeroshellnet
Phone: +3908321835630
