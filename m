From: Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH PATCH net-next 07/18] ceph: fix whitespace
Date: Wed, 25 Jul 2018 14:59:56 +0200
Message-ID: <CAOi1vP8C4-Sn1HAD5Cjo98je8g2M-BXeV97weJHUP-2_mYwM9A@mail.gmail.com>
References: <20180724192918.31165-1-sthemmin@microsoft.com> <20180724192918.31165-8-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org, lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org,
        jreuter-K7Hl1MveuGQ@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org,
        fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, alex.aring-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, stefan-OrPQZGeq07wqhVmZOOOmNx2eb7JE58TQ@public.gmane.org,
        kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org,
        johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org,
        xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org,
        Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org,
        marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org,
        anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-hams-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Ceph Development <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-decnet-user-5NWGOfrQmneRv+LV9MX5uuRhgaa4a2kL@public.gmane.org
To: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180724192918.31165-8-sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 24, 2018 at 9:31 PM Stephen Hemminger
<stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org> wrote:
>
> Remove blank lines at end of file and trailing whitespace.
>
> Signed-off-by: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
> ---
>  net/ceph/Kconfig      | 1 -
>  net/ceph/Makefile     | 1 -
>  net/ceph/auth_none.c  | 1 -
>  net/ceph/auth_none.h  | 1 -
>  net/ceph/auth_x.c     | 2 --
>  net/ceph/auth_x.h     | 1 -
>  net/ceph/mon_client.c | 2 +-
>  net/ceph/pagevec.c    | 1 -
>  8 files changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
> index f8cceb99e732..cd2d5b9301a1 100644
> --- a/net/ceph/Kconfig
> +++ b/net/ceph/Kconfig
> @@ -41,4 +41,3 @@ config CEPH_LIB_USE_DNS_RESOLVER
>           Documentation/networking/dns_resolver.txt
>
>           If unsure, say N.
> -
> diff --git a/net/ceph/Makefile b/net/ceph/Makefile
> index 12bf49772d24..db09defe27d0 100644
> --- a/net/ceph/Makefile
> +++ b/net/ceph/Makefile
> @@ -15,4 +15,3 @@ libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
>         auth_x.o \
>         ceph_fs.o ceph_strings.o ceph_hash.o \
>         pagevec.o snapshot.o string_table.o
> -
> diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
> index 41d2a0c72236..edb7042479ed 100644
> --- a/net/ceph/auth_none.c
> +++ b/net/ceph/auth_none.c
> @@ -142,4 +142,3 @@ int ceph_auth_none_init(struct ceph_auth_client *ac)
>         ac->ops = &ceph_auth_none_ops;
>         return 0;
>  }
> -
> diff --git a/net/ceph/auth_none.h b/net/ceph/auth_none.h
> index 860ed9875791..4158f064302e 100644
> --- a/net/ceph/auth_none.h
> +++ b/net/ceph/auth_none.h
> @@ -26,4 +26,3 @@ struct ceph_auth_none_info {
>  int ceph_auth_none_init(struct ceph_auth_client *ac);
>
>  #endif
> -
> diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
> index 2f4a1baf5f52..32c7f5c4b1a6 100644
> --- a/net/ceph/auth_x.c
> +++ b/net/ceph/auth_x.c
> @@ -823,5 +823,3 @@ int ceph_x_init(struct ceph_auth_client *ac)
>  out:
>         return ret;
>  }
> -
> -
> diff --git a/net/ceph/auth_x.h b/net/ceph/auth_x.h
> index 454cb54568af..a71c4c282b57 100644
> --- a/net/ceph/auth_x.h
> +++ b/net/ceph/auth_x.h
> @@ -52,4 +52,3 @@ struct ceph_x_info {
>  int ceph_x_init(struct ceph_auth_client *ac);
>
>  #endif
> -
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index d7a7a2330ef7..18deb3d889c4 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1249,7 +1249,7 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>                 if (monc->client->extra_mon_dispatch &&
>                     monc->client->extra_mon_dispatch(monc->client, msg) == 0)
>                         break;
> -
> +
>                 pr_err("received unknown message type %d %s\n", type,
>                        ceph_msg_type_name(type));
>         }
> diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
> index e560d3975f41..d3736f5bffec 100644
> --- a/net/ceph/pagevec.c
> +++ b/net/ceph/pagevec.c
> @@ -197,4 +197,3 @@ void ceph_zero_page_vector_range(int off, int len, struct page **pages)
>         }
>  }
>  EXPORT_SYMBOL(ceph_zero_page_vector_range);
> -

Applied.

Thanks,

                Ilya
