From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH, RFC] possible use of freed skbuff in netfilter.c
Date: Wed, 30 Apr 2003 18:24:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304301824.40887.bdschuym@pandora.be>
References: <200304251957.18012.bdschuym@pandora.be> <20030429145129.GG684@naboo.intranet.astaro.de> <20030429.235444.26991098.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>, laforge@netfilter.org
In-Reply-To: <20030429.235444.26991098.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 30 April 2003 08:54, David S. Miller wrote:
>    I'm fine with this fix, please apply (if it isn't already).
>
> Applied.  Should we be putting this fix into 2.4.x as well?

No, this is only related to 2.5.

--=20
cheers,
Bart
