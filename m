From: "bunty " <bunty123_4@rediffmail.com>
Subject: How to assign priorities to same hook number  in 2 modules?
Date: 9 Jan 2005 18:46:51 -0000
Message-ID: <20050109184651.19984.qmail@webmail45.rediffmail.com>
Reply-To: bunty  <bunty123_4@rediffmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

  =0AHello,=0A      I have written 2 netfilter kernel modules with struct n=
f_hook_ops nfho1 in one module =0Aand struct nf_hook_ops nfho2 in another. =
Now what i want is to execute Module 1 first and then =0AModule 2. How can =
i do that? Structure is initialised as=0A              nfho1.hook     =3D h=
ook_func1;=0A              nfho1.hooknum  =3D NF_IP_LOCAL_OUT;=0A          =
    nfho1.pf       =3D PF_INET;=0A              nfho1.priority =3D NF_IP_PR=
I_FIRST;=0A              nf_register_hook(&nfho1);=0A=0A	      nfho2.hook  =
   =3D hook_func2;=0A              nfho2.hooknum  =3D NF_IP_LOCAL_OUT;=0A  =
            nfho2.pf       =3D PF_INET;=0A              nfho2.priority =3D =
NF_IP_PRI_FIRST;=0A              nf_register_hook(&nfho2);=0Aregards,=0Apar=
ag.
