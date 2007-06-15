From: "pankaj jain" <jainp1979@gmail.com>
Subject: Re: ebtables v/s arptables
Date: Fri, 15 Jun 2007 12:38:37 +0530
Message-ID: <d41814cf0706150008i1d18a65fn8cede7957b764939@mail.gmail.com>
References: <d41814cf0706130120x5609dfc2o285a07ceda1ba21b@mail.gmail.com>
	<1181755998.2976.1.camel@localhost.localdomain>
	<d41814cf0706140125i52cef5a6u6e73ab3395290e35@mail.gmail.com>
	<1181837804.2972.16.camel@localhost.localdomain>
	<d41814cf0706142221u735ff9a8v1b1debf802c3f400@mail.gmail.com>
	<Pine.LNX.4.64.0706150833230.27797@fbirervta.pbzchgretzou.qr>
	<d41814cf0706142341m427b0c56p6ade6d2f3925cd15@mail.gmail.com>
	<467237E5.9020400@netsyncro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "=?ISO-8859-1?Q?C._Bergstr=F6m?=" <cbergstrom@netsyncro.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467237E5.9020400@netsyncro.com>
Content-Disposition: inline
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

On 6/15/07, "C. Bergstr=F6m" <cbergstrom@netsyncro.com> wrote:
> pankaj jain wrote:
> >
> > On 6/15/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >>
> >> On Jun 15 2007 10:51, pankaj jain wrote:
> >> >
> >> > Hi Bart,
> >> > Do I have to create a bridge to use "arpreply --arpreply-mac <MAC
> >> > address>" as a target.
> >> > I am asking this because I was not getting arp responses from the
> >> > machine where I inserted the ebtable rule but did not create a bridg=
e.
> >>
> >> Of course. Ebtables works ONLY with bridges. So you create
> >> your regular eth0 or whatever, give it its ip address, and
> >> create a br0 device that binds eth0, but do not give br0
> >> any address. (That's how one preferably does it if you only
> >> need arpreply.)
> >>
> >> And don't top post.
> >>
> >>
> > Hi Jan,
> > I am sorry I did not get the meaning of last line "And don't top post."
> >
> > I would also want to know is there any theoretical limit on number of
> > iptable , ebtable, arptable rules we can set?
> >
> I'm just a lurker, but this link may help.
>
> http://linux.sgms-centre.com/misc/netiquette.php#toppost
>
> Good luck
>
> ./C

Thanks for the Reference.
I think I have got the netiquettes now :)

--=20
Thanks
Pankaj Jain
