From: "Li, Philip" <philip.li@intel.com>
Subject: RE: [kbuild-all] [nf:master 1/9] arch/x86/tools/insn_decoder_test:
 warning: ffffffff817c07c3:	0f ff e9 ud0 %ecx, %ebp
Date: Mon, 12 Feb 2018 14:38:37 +0000
Message-ID: <831EE4E5E37DCC428EB295A351E662494C9BD796@shsmsx102.ccr.corp.intel.com>
References: <201802071027.gHIvqB29%fengguang.wu@intel.com>
 <20180212133547.GD3443@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Linux Memory Management List <linux-mm@kvack.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"kbuild-all@01.org" <kbuild-all@01.org>, Andrew Morton
	<akpm@linux-foundation.org>, Pablo Neira Ayuso <pablo@netfilter.org>
To: Michal Hocko <mhocko@kernel.org>, "Wu, Fengguang" <fengguang.wu@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20180212133547.GD3443@dhcp22.suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-Id: netfilter-devel.vger.kernel.org

> On Wed 07-02-18 10:16:31, Wu Fengguang wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git ma=
ster
> > head:   b408c5b04f82fe4e20bceb8e4f219453d4f21f02
> > commit: 0537250fdc6c876ed4cbbe874c739aebef493ee2 [1/9] netfilter: x_tab=
les:
> make allocation less aggressive
> > config: x86_64-rhel-7.2 (attached as .config)
> > compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> > reproduce:
> >         git checkout 0537250fdc6c876ed4cbbe874c739aebef493ee2
> >         # save the attached .config to linux build tree
> >         make ARCH=3Dx86_64
> >
> > All warnings (new ones prefixed by >>):
> >
> >    arch/x86/tools/insn_decoder_test: warning: Found an x86 instruction =
decoder
> bug, please report this.
> >    arch/x86/tools/insn_decoder_test: warning: ffffffff817aed81:	0f ff c=
3
> 	ud0    %ebx,%eax
>=20
> I really fail to see how the above patch could have made any difference.
> I am even not sure what the actual bug is, to be honest.
sorry for the noise, this is a false positive after we upgrade to gcc7.3. W=
e have
blacklisted this warning in test farm, and kernel side has started the fix =
to handle
this. Kindly ignore this report.

>=20
> --
> Michal Hocko
> SUSE Labs
> _______________________________________________
> kbuild-all mailing list
> kbuild-all@lists.01.org
> https://lists.01.org/mailman/listinfo/kbuild-all

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
