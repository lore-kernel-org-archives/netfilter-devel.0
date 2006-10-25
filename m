From: "mael\.boutin\@laposte\.net" <mael.boutin@laposte.net>
Subject: RE: Problem using connection tracking
Date: Wed, 25 Oct 2006 08:59:45 +0200
Message-ID: <J7OJFL$F301B5312B6CDE02A8FDA375D7646BB5@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	kaber <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "anisha\.chandrasekaran" <anisha.chandrasekaran@wipro.com>
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

Firstly, thanks for your answers. The problem was that i wanted to use th=
e new connection tracking system (layer 3 indepedent) and receive events.=
 Now it is working, the problem was related to the kernel version (2.6.15=
.6) which does not integrate ctnetlink for nf_conntrack.

I managed to use mipl2.0.1 (the patch for mipl2.0.2 on 2.6.16 kernel seem=
s to work also with mipl2.0.1) on a 2.6.16 kernel so the problem is resol=
ved.

Once again thanks for your help,

Ma=EBl


> 
> Hello Patrick,
>     The conntrack package might not have been built properly. That is
> wen it says invalid parameters. I was trying to cross compile the
> backage for arm architecture and it reported the same error for me.
> 
> But I tried with PC compilation it did work fine. If you are compiling
> for i386 then,
> 1. Ensure the kernel in > 2.6.14 version.
> 2. run configure command with the proper kernel path specified.
> 3. Then run a make and make install.
> 4. 1-3 should be first done for libnfnetlink package, then for
> libnetfilter-conntrack package and then for conntrack package. This
> should be the order of build as the packages have some dependency with
> each other.
> 
> If you have been following steps 1-4 then I guess the conntrack
> executable must work.
> 
> 
>  Regards,
> 
> Anisha Chandrasekaran
> Email : anisha.chandrasekaran@wipro.com 
>  
>         
> 
> -----Original Message-----
> From: netfilter-devel-bounces@lists.netfilter.org
> [mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
> Patrick McHardy
> Sent: Monday, October 23, 2006 9:55 PM
> To: mael.boutin
> Cc: netfilter-devel
> Subject: Re: Problem using connection tracking
> 
> mael.boutin wrote:
> > Hi,
> >
> > First excuse me for my poor english ...
> >
> > I'm having problems using conntrack. Everything was ok while i
> > was using the old ip_conntrack. However, now i need to use it
> > with IPv6.
> >
> > The problem i'm facing is with the new connection tracking
> > system, i can't receive any conntrack events neither IPv4 nor
> > IPv6.
> >
> > Moreover, the conntrack application is not working :
> > - conntrack -L returns invalid parameters
> > - conntrack -E dumps nothing
> >
> > I think it is a problem related with the configuration of the
> > kernel (attached).
> >
> > I'm using a 2.6.15.6 Linux Kernel and i can't go to a newer
> > kernel.
> 
> ctnetlink support for nf_conntrack was added in 2.6.16.
> 
> 
> 
> 
> The information contained in this electronic message and any attachment=
s to this message are intended for the exclusive use of the addressee(s) =
and may contain proprietary, confidential or privileged information. If y=
ou are not the intended recipient, you should not disseminate, distribute=
 or copy this e-mail. Please notify the sender immediately and destroy al=
l copies of this message and any attachments.
> 
> WARNING: Computer viruses can be transmitted via email. The recipient s=
hould check this email and any attachments for the presence of viruses. T=
he company accepts no liability for any damage caused by any virus transm=
itted by this email.
> 
> www.wipro.com
> =0A=0AAcc=E9dez au courrier =E9lectronique de La Poste 
sur www.laposte.net ou sur 3615 LAPOSTENET (0,34=80 TTC /mn) 
1 Giga de stockage gratuit =96 Antispam et antivirus int=E9gr=E9s 
=0A
