From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: Re: ip6t_ROUTE target
Date: Mon, 19 May 2003 14:46:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030519124603.GA27460@sch.bme.hu>
References: <20030516221652.3d86c00a.xraz@rwxr-xr-x.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Frank 'xraz' Fricke" <xraz@rwxr-xr-x.de>
Content-Disposition: inline
In-Reply-To: <20030516221652.3d86c00a.xraz@rwxr-xr-x.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Frank 'xraz' Fricke ............................ (2003. m=E1jus 16.)

Hi Frank,

> This was my first netfilter/kernel-work an was all done from
> scratch - maybe it's alls wrong, but it really seem to do it's
> job.
But the id of the file says libip6t_REJECT ;)
> It's not working as a module because it uses rt6_lookup wich is not
> exported - but i found it suitable for this case.
Probably it could be exported ... (in the future).
Until that we should set the mod.count to -1. ;)

As I know - the new modules should be added to 2.5.x. You have the old
Configure.help format instead of Kconfig.
You do not use the C99 initializers in the structures.

Could you update your patches?

Thank you in advance,

	kisza

--=20
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /----------------------------------------------->
