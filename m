From: "Patrick" <patrick_@freenet.de>
Subject: Re: string match patch
Date: Tue, 13 Jul 2004 11:24:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <006c01c468bb$324f7e20$0200a8c0@milchreis>
References: <Pine.LNX.4.44.0407130248130.24937-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Damnit :D that fixed it. Thank you :-)

regards
Patrick

----- Original Message -----
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "Patrick" <patrick_@freenet.de>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Tuesday, July 13, 2004 2:51 AM
Subject: Re: string match patch


> On Tue, 13 Jul 2004, Henrik Nordstrom wrote:
>
> > On Tue, 13 Jul 2004, Patrick wrote:
> >
> > > yes I know that I am supposed to have new menu entries .. but as I
said the
> > > patch pretends to be applied correctly and also the header files are
copied
> > > .. I am using most recent version of pom-ng, thus
> > > "patch-o-matic-ng-20040621"
> > > I also tried the old stable version of patch-o-matic-20031219 .. which
did
> > > not work either :|
> >
> > Seems to be some bug in the pom-ng runme script..
>
> Err.. False alarm. I was looking in the wrong tree after running runme.
> runme seems to work just fine here.
>
> Make sure you have CONFIG_EXPERIMENTAL enabled. ipt_string is marked as an
> experimental extension and won't show up in the config menu unless
> CONFIG_EXPERIMENTAL is enabled in your kernel config.
>
> Regards
> Henrik
>
>
>
