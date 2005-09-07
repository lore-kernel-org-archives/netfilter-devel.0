From: Oscar Mateo <omateo@gmail.com>
Subject: Re: unable to apply PPTP patches
Date: Wed, 7 Sep 2005 12:07:00 +0200
Message-ID: <a8a372c050907030777d05bbe@mail.gmail.com>
References: <57F9959B46E0FA4D8BA88AEDFBE582907512@pxtbenexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Gary W. Smith" <gary@primeexalia.com>
In-Reply-To: <57F9959B46E0FA4D8BA88AEDFBE582907512@pxtbenexd01.pxt.primeexalia.com>
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

Ouch!, that was goood news, but now I cannot find a pom-ng snapshot in
the ftp server older than May 1st and the cvs server doesn=B4t allow me
to login. Can you send me that working pom-ng?
Thanks very much for your help!

On 9/6/05, Gary W. Smith <gary@primeexalia.com> wrote:
> April 4th or April 10th (not sure which one) copy worked fine with
> 2.6.9. I've been using this on several servers for some time.
>=20
> Not sure about the newer versions.  There has been much talk in the
> netfilter users group regarding the newest version not compipling.
>=20
> Hope that helps.
>=20
> Gary
>=20
> -----Original Message-----
> From: netfilter-devel-bounces@lists.netfilter.org
> [mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Oscar
> Mateo
> Sent: Tuesday, September 06, 2005 9:02 AM
> To: netfilter-devel@lists.netfilter.org
> Subject: unable to apply PPTP patches
>=20
> Hi all,
>=20
> As suggested somewhere in the netfilter list, I'm moving this
> "question/help request" from the netfilter to the netfilter-developer
> list:
>=20
> I have been trying to apply the pptp patches (pom-ng-20050905,
> iptables-1.3.3) to the kernel source (kernels 2.6.9.x, 2.6.11.x and
> 2.6.12.x) and I have found the same error that populates the August
> 2005 netfilter Archives:
>=20
> - If I only apply the pptp/gre patches I get
> `__ip_conntrack_expect_find' undefined (when compiling either in the
> kernel or as a module).
> - If I try to apply nfnetlink and ctnetlink patches, ctnetlink is
> rejected (6 rejects out of 48 hunks).
> - If I force the ctnetlink patch, I get `__ip_conntrack_hash_insert'
> undeclared.
>=20
> Did someone get the patch working with kernels >=3D 2.6?
> Does anyone have any ideas how to deal with this problem?
>=20
> Thanks in advance for your help ^_^
> Oscar
>=20
>
