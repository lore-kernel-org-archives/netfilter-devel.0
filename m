From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: [PATCH 2/2] ipt_hashlimit.c: sleeping function called from
 invalid context
Date: Tue, 1 Feb 2005 10:07:46 -0500 (EST)
Message-ID: <8329.142.169.215.10.1107270466.squirrel@142.169.215.10>
References: <41F86557.2000208@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <41F86557.2000208@cookinglinux.org>
To: netfilter-devel@lists.netfilter.org
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

On Wed, January 26, 2005 10:51 pm, Samuel Jean said:
> --- net/ipv4/netfilter/ipt_hashlimit.c.orig  2005-01-26 22:35:43.000000=
000
> -0500
> +++ net/ipv4/netfilter/ipt_hashlimit.c 2005-01-26 22:36:14.000000000 -0=
500
> @@ -570,7 +570,7 @@ static void *dl_seq_start(struct seq_fil
>     if (*pos >=3D htable->cfg.size)
>        return NULL;
>
> -  bucket =3D kmalloc(sizeof(unsigned int), GFP_KERNEL);
> +  bucket =3D kmalloc(sizeof(unsigned int), GFP_ATOMIC);
>     if (!bucket)
>        return ERR_PTR(-ENOMEM);

I've also wondered about it this morning.. Couldn't we just let kmalloc
sleeps, and once we got the memory, we lock ?
