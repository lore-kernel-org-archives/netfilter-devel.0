From: Herve Eychenne <rv@wallfire.org>
Subject: Re: SNAT from multiple interfaces with the same IP?
Date: Sun, 4 Dec 2005 16:37:29 +0100
Message-ID: <20051204153729.GA5617@eychenne.org>
References: <4392E148.7010102@gmx.net> <43930BEF.9000602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <43930BEF.9000602@trash.net>
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

On Sun, Dec 04, 2005 at 04:31:59PM +0100, Patrick McHardy wrote:

> I don't see why it wouldn't work, but you can't use -i in POSTROUTING
> directly,

BTW, I've always wondered why exactly...

> you need to mark the packets or just SNAT unconditionally.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
