From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: [BUG] ipt_SAME rule can't be deleted
Date: Mon, 6 Dec 2004 15:59:45 -0500 (EST)
Message-ID: <51066.142.169.215.10.1102366785.squirrel@142.169.215.10>
References: <20041204150223.GA10247@dfbbb.opencjk.org>
	<Pine.LNX.4.61.0412060821280.10926@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0412060821280.10926@filer.marasystems.com>
To: "Henrik Nordstrom" <hno@marasystems.com>
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

On Mon, December 6, 2004 2:34 am, Henrik Nordstrom said:

>          u_int32_t *iparray;
>
> If I am right the same problem applies to -m limit and any other extens=
ion
> storing private kernel side stuff within it's info data..
>

If I am right too,
This wouldn't happen if we moved u_int32_t *iparray at end of structure.
Then, registering the target plugin that way :

    .size            =3D IPT_ALIGN(sizeof(struct ipt_same_info)),
    .userspacesize   =3D offsetof(struct ipt_same_info, iparray),

Would fix this inconveniant.


> Regards
> Henrik
>
Best regards,

Samuel
CookingLinux TM
