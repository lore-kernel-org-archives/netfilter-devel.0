From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Can it realize that redirect  on  Brige?!
Date: Mon, 19 May 2003 20:13:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305192013.24058.bdschuym@pandora.be>
References: <000d01c31dbc$67773a70$5b01aa0a@Dec0y>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="gb2312"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Dec0y" <anti_decoy@sina.com>,
	"netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <000d01c31dbc$67773a70$5b01aa0a@Dec0y>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 19 May 2003 06:09, Dec0y wrote:
> Can it realize that redirect  on  Brige?!
<snip>
> and When I add a policy as follow:
>=20
> iptables -t nat -A PREROUTING -j REDIRECT --to  1080
> my kernel panic!

redirecting on a bridge should normally not be a problem. I'm assuming yo=
u are=20
using bridge-nf?
What kernel are you using? Can you give a trace on that oops? Is this spe=
cific=20
to port 1080?

--=20
cheers,
Bart
