From: "Kevin Baradon" <kevin.baradon@gmail.com>
Subject: Re : [2.6.21-rc{3,4} problem]: missing dependency on NF_NAT
Date: Sun, 18 Mar 2007 13:43:13 +0100
Message-ID: <bd87e7590703180543p75c46b8fk44a0df061d21a17@mail.gmail.com>
References: <bd87e7590703170738q2363274fx120630d5d4e3279@mail.gmail.com>
	 <45FC0226.2010305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	"Netfilter Development Mailinglist"
	<netfilter-devel@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752414AbXCRMnQ@vger.kernel.org>
In-Reply-To: <45FC0226.2010305@trash.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

2007/3/17, Patrick McHardy <kaber@trash.net>:
> Kevin Baradon wrote:
> > Compiling kernel 2.6.21-rc3 gives me the following errors :
> >
> >  LD      .tmp_vmlinux1
> > net/built-in.o: dans la fonction =AB nfnetlink_parse_nat_proto =BB:
> > nf_conntrack_netlink.c:(.text+0x28db9): r=E9f=E9rence ind=E9finie v=
ers =AB
> > nf_nat_proto_find_get =BB
> > [...]
> >
> > Also occurs with 2.6.21-rc4.
> > Setting CONFIG_NF_NAT to 'y' fixes problem.
>
>
> Thanks, I queued this patch, which should fix it.

Yes, it works for me.
Thanks.

>
