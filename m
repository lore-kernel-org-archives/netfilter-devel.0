From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nfnetlink_log: allow to attach
 conntrack
Date: Wed, 26 Aug 2015 21:05:53 +0200
Message-ID: <20150826190553.GA18429@salvia>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50907 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbbHZS7r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 14:59:47 -0400
Content-Disposition: inline
In-Reply-To: <20150824231520.GC20038@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 25, 2015 at 08:15:20AM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch enables to include the conntrack information together
> with the packet that is sent to user-space via NFLOG, then a
> user-space program can acquire NATed information by this NFULA_CT
> attribute.
>=20
> Including the conntrack information is optional, you can set it
> via NFULNL_CFG_F_CONNTRACK flag with the NFULA_CFG_FLAGS attribute
> like NFQUEUE.

No objections to this series, just several comments below on them.

> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  include/net/netfilter/nfnetlink_queue.h      |    4 +-
>  include/uapi/linux/netfilter/nfnetlink_log.h |    3 +
>  net/netfilter/Kconfig                        |    9 +-
>  net/netfilter/Makefile                       |    2 +
>  net/netfilter/nfnetlink_log.c                | 1123 ----------------=
---------
>  net/netfilter/nfnetlink_log_core.c           | 1135 ++++++++++++++++=
++++++++++
>  net/netfilter/nfnetlink_queue_ct.c           |    2 +-
>  7 files changed, 1148 insertions(+), 1130 deletions(-)
>  delete mode 100644 net/netfilter/nfnetlink_log.c
>  create mode 100644 net/netfilter/nfnetlink_log_core.c
>=20
> diff --git a/include/net/netfilter/nfnetlink_queue.h b/include/net/ne=
tfilter/nfnetlink_queue.h
> index f94942b..05315ab 100644
> --- a/include/net/netfilter/nfnetlink_queue.h
> +++ b/include/net/netfilter/nfnetlink_queue.h
> @@ -6,7 +6,7 @@
>  struct nf_conn;
> =20
>  #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
> -struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
> +struct nf_conn *nfqnl_ct_get(const struct sk_buff *entskb, size_t *s=
ize,
>  			     enum ip_conntrack_info *ctinfo);
>  struct nf_conn *nfqnl_ct_parse(const struct sk_buff *skb,
>  			       const struct nlattr *attr,
> @@ -20,7 +20,7 @@ int nfqnl_attach_expect(struct nf_conn *ct, const s=
truct nlattr *attr,
>  			u32 portid, u32 report);
>  #else
>  inline struct nf_conn *
> -nfqnl_ct_get(struct sk_buff *entskb, size_t *size, enum ip_conntrack=
_info *ctinfo)
> +nfqnl_ct_get(const struct sk_buff *entskb, size_t *size, enum ip_con=
ntrack_info *ctinfo)
>  {
>  	return NULL;
>  }
> diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/u=
api/linux/netfilter/nfnetlink_log.h
> index 90c2c95..081e7f9 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_log.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_log.h
> @@ -51,6 +51,8 @@ enum nfulnl_attr_type {
>  	NFULA_HWTYPE,			/* hardware type */
>  	NFULA_HWHEADER,			/* hardware header */
>  	NFULA_HWLEN,			/* hardware header length */
> +	NFULA_CT,			/* nf_conntrack_netlink.h */
> +	NFULA_CT_INFO,			/* enum ip_conntrack_info */
> =20
>  	__NFULA_MAX
>  };
> @@ -93,5 +95,6 @@ enum nfulnl_attr_config {
> =20
>  #define NFULNL_CFG_F_SEQ	0x0001
>  #define NFULNL_CFG_F_SEQ_GLOBAL	0x0002
> +#define NFULNL_CFG_F_CONNTRACK	0x0004
> =20
>  #endif /* _NFNETLINK_LOG_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 3e1b4ab..b3db079 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -363,12 +363,13 @@ config NF_CT_NETLINK_HELPER
>  	  If unsure, say `N'.
> =20
>  config NETFILTER_NETLINK_QUEUE_CT
> -        bool "NFQUEUE integration with Connection Tracking"
> +        bool "NFQUEUE/NFLOG integration with Connection Tracking"
>          default n
> -        depends on NETFILTER_NETLINK_QUEUE
> +        depends on NETFILTER_NETLINK_QUEUE || NETFILTER_NETLINK_LOG
>  	help
> -	  If this option is enabled, NFQUEUE can include Connection Trackin=
g
> -	  information together with the packet is the enqueued via NFNETLIN=
K.
> +	  If this option is enabled, NFQUEUE and/or NFLOG can include
> +	  Connection Tracking information together with the packet is
> +	  enqueued, logged via NFNETLINK.

You better add another Kconfig for _LOG.

>  config NF_NAT
>  	tristate
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 70d026d..3657898 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -13,6 +13,8 @@ obj-$(CONFIG_NETFILTER_NETLINK_ACCT) +=3D nfnetlink=
_acct.o
>  nfnetlink_queue-y :=3D nfnetlink_queue_core.o
>  nfnetlink_queue-$(CONFIG_NETFILTER_NETLINK_QUEUE_CT) +=3D nfnetlink_=
queue_ct.o
>  obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) +=3D nfnetlink_queue.o
> +nfnetlink_log-y :=3D nfnetlink_log_core.o
> +nfnetlink_log-$(CONFIG_NETFILTER_NETLINK_QUEUE_CT) +=3D nfnetlink_qu=
eue_ct.o
>  obj-$(CONFIG_NETFILTER_NETLINK_LOG) +=3D nfnetlink_log.o
> =20
>  # connection tracking
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_=
log.c
> deleted file mode 100644
> index 4670821..0000000
> --- a/net/netfilter/nfnetlink_log.c
> +++ /dev/null

Could you use -M option when generating patches?

       -M[<n>], --find-renames[=3D<n>]
           Detect renames. If n is specified, it is a
           threshold on the similarity index (i.e.
           amount of addition/deletions compared to
           the file=E2=80=99s size). For example, -M90% means
           git should consider a delete/add pair to be
           a rename if more than 90% of the file
           hasn=E2=80=99t changed.

It would be good if your first patch renamed the file, then you make
the changes in a follow up patch.

The idea is to make it easier for people to review your changes.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
