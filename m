From: "Patrick" <patrick_@freenet.de>
Subject: Re: string match patch
Date: Tue, 13 Jul 2004 00:48:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002a01c46862$6e77df90$0200a8c0@milchreis>
References: <Pine.LNX.4.44.0407122348430.23090-100000@filer.marasystems.com>
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

Hello,

yes I know that I am supposed to have new menu entries .. but as I said the
patch pretends to be applied correctly and also the header files are copied
.. I am using most recent version of pom-ng, thus
"patch-o-matic-ng-20040621"
I also tried the old stable version of patch-o-matic-20031219 .. which did
not work either :|

Regards
Patrick
----- Original Message -----
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "Patrick" <patrick_@freenet.de>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Monday, July 12, 2004 11:51 PM
Subject: Re: string match patch


> On Mon, 12 Jul 2004, Patrick wrote:
>
> > after I patched it I noticed that I dont have any
> > new menu point nor do I have CONFIG_IP_NF_MATCH_STRING in my kernel
> > config .. the patch pretends to be applied correctly, which I can also
> > verify, because the header files are present.
>
> You SHOULD have a new menu entries for the string match..
>
>     dep_tristate '  String match support (EXPERIMENTAL)'
CONFIG_IP_NF_MATCH_STRING $CONFIG_IP_NF_IPTABLES
>
> If you do not, and or else do not have CONFIG_IP_NF_MATCH_STRING defined
> in your kernel configuration then the string match won't be build, and
> hence won't work.
>
> Which version of pom-ng are you using?
>
> Regards
> Henrik
>
>
>
