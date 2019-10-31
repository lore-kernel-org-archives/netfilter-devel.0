Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C8ACA9EC3
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 08:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E632086D
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 08:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="GcdSkF7+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfJaIhz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:37:55 -0400
Received: from mout.gmx.net ([212.227.17.22]:40535 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbfJaIhz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 04:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572511072;
        bh=nKApHGiVLYUIrld2W4fHVAwns9QPDrjD5Woy0BUQwWU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=GcdSkF7+2z825QfYgZrhvmKJ82TlcPsN2i9PSHDYcqnuuRnu+g4mOhxNUojdls6IB
         BNsaqwZmvBRWnL7QcTZP4r5nVIgxU8E8yyxxQ5FtvHs9w7y6Km3Eu1lkdUuXin+/8l
         q5/1LRJGkeN+WQ2t7+qx2F6VyhX3URyUkiv4lt40=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from pythagoras.local ([77.10.174.36]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MnJhU-1hj5hU1djg-00jJvT; Thu, 31
 Oct 2019 09:37:52 +0100
From:   Marvin Schmidt <marvin_schmidt@gmx.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Marvin Schmidt <marvin_schmidt@gmx.net>
Subject: [libnftnl PATCH 1/1] flowtable: Fix symbol export for clang
Date:   Thu, 31 Oct 2019 09:37:07 +0100
Message-Id: <20191031083706.6867-1-marvin_schmidt@gmx.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FrdWnMkWqy2aJDsW/DXe48O1aFoEHyrbIa+JpAb8hlseefl8Sbo
 yihVpGh0i+FTAm2BGcsCbEPdOl9En/YFQPvL3cosM6SPaVcmzwsZflouh4Jg/6XCX25OgvU
 PcjZNsN9vlwRY8yfButjjqsOJy5sOogwNTRg1lGT3t1jTbEM/6x8j4NBH4M9Pz7/V6Ofk7G
 UncYLxKJkTIX+bHD1JuBg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XHzxBozXB54=:qmsDrnvrEiJ93hPiPO2pZP
 dpSZq5KmgAtucWnn5I3suKCxXqtEfw6bL4uTfmnAam9MdJxjuzkWArimX9WAJ1z9fmQxJrGKi
 3KtzqNjkU20q1cI7kN0iuVKA1qVfkdDxGu/iIu2o8MMZ1k/AF7XlTaznS0pLUbxJsswreT+ff
 kYnRm8eUSxzAQlYKNP9SxI9FGc03O7deSV4l7IcRe05yOMh/BVa8R5wxgGNebQW/f6KJZfM0m
 /B5x0Noat6SumLbKhhEfScpvVS3UtY9Z9tS77z4meKMXfhNBLNKNqyoIH5KL0Pjo6doMKm/6g
 azACF8ESftCng4W2KCbnW15jMqWhcc8fSv8e2tio/YlQDDMphy2HHPFUuSXf66ecNSCID3gBR
 FOcZo4pB+9aXWBEc12t9sjRnLTwLwzFKjzQb5e8/zuWBbkyCo6ro4UPeV8qzr2bbFGYeq3nr+
 928Un4ZyFoioyYkOzBe/TMRgWfuvXY6PGpCCtJY7gOyYpp/4qync24tkwW5GI1v2hWP9nJAHM
 N19g7itxTgL/ARRsvrig6vvsKeC8urL7R/wtvUezKDx7To5W9Z7vGu9zSNhHE2QZaZkd/Fkip
 zDKWpvQPN6P2DRb1IRU7qLmq5pXuxnc3rKRE03soZVvMuAYgdUniqsXloTkxLZzkDXFLRcdCz
 WIZB4IfimEehdSxas+C3FnoS5o6aPzj4rkamfet4+ALg/qcoWJf8s4ezp0jq2RIk06u8nR+gL
 7ILmxQGSLkiieRs37ZEpbyBnk4J+oqHiD4xvW7/F366j2jmosStaGnMcZMftfI+hxsUyYh1fx
 o66tLslM0wX/99DMaYGgkGr0jMDm7+JQx9WIxl46PDnffivVj2+6Uw1k/WBDU9Gvo+Y/ybzXE
 kTPW0aezVunrnfEHxLGfRi3ykgjcLASxW4WhrSllJtZopyGIocPjMklHyPvCwQ0XOjtXay0n2
 VTPoyMKXpW9noZCMyxnN2Wrqzc70UIcB0DiCacVDOfggLVqczUZF6vtgxzW+4MHOsUPFsoQcg
 BSUFgsVU6kCoByJNP1slrNARHiZ9dE+fYhDlEfUGBmGjRVAQ9f4Rl+TQEHrJe0G4pCVCOdPuM
 BMYg2birlmYb7vaCMAS2JgghcFs+x8OlsAv55CosX+jre2Q5I/RNgUpJqSo4TQ5IuD/HMcE8D
 AlxkiYXmJaXKQX1gImVfVTXEsDeIgPbojy59Mq+TNFNQ9OsQbJ5rzks/J4fq5wx89KS/WRk8Z
 zVWMntkqlmhAYkHRD5+Wdi5yiWOM0yZt9kP2nXC6VHGNmtpTS4A97fkTuYjI=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

clang does not allow attribute declarations after definitions:

  flowtable.c:41:1: warning: attribute declaration must precede definition=
 [-Wignored-attributes]
  EXPORT_SYMBOL(nftnl_flowtable_alloc);
  ^
  ../include/utils.h:13:41: note: expanded from macro 'EXPORT_SYMBOL'
  #       define EXPORT_SYMBOL(x) typeof(x) (x) __visible;
                                                ^
  ../include/utils.h:12:35: note: expanded from macro '__visible'
  #       define __visible        __attribute__((visibility("default")))
                                                 ^
  flowtable.c:37:25: note: previous definition is here
  struct nftnl_flowtable *nftnl_flowtable_alloc(void)

Move attribute declarations before the symbol definitions just like
it's done in other source files

Signed-off-by: Marvin Schmidt <marvin_schmidt@gmx.net>
=2D--
:100644 100644 020f102 f9101e8 M	src/flowtable.c
 src/flowtable.c | 54 ++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/src/flowtable.c b/src/flowtable.c
index 020f102..f9101e8 100644
=2D-- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -34,12 +34,13 @@ struct nftnl_flowtable {
 	uint32_t		flags;
 };

+EXPORT_SYMBOL(nftnl_flowtable_alloc);
 struct nftnl_flowtable *nftnl_flowtable_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_flowtable));
 }
-EXPORT_SYMBOL(nftnl_flowtable_alloc);

+EXPORT_SYMBOL(nftnl_flowtable_free);
 void nftnl_flowtable_free(const struct nftnl_flowtable *c)
 {
 	int i;
@@ -56,14 +57,14 @@ void nftnl_flowtable_free(const struct nftnl_flowtable=
 *c)
 	}
 	xfree(c);
 }
-EXPORT_SYMBOL(nftnl_flowtable_free);

+EXPORT_SYMBOL(nftnl_flowtable_is_set);
 bool nftnl_flowtable_is_set(const struct nftnl_flowtable *c, uint16_t att=
r)
 {
 	return c->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_flowtable_is_set);

+EXPORT_SYMBOL(nftnl_flowtable_unset);
 void nftnl_flowtable_unset(struct nftnl_flowtable *c, uint16_t attr)
 {
 	int i;
@@ -95,7 +96,6 @@ void nftnl_flowtable_unset(struct nftnl_flowtable *c, ui=
nt16_t attr)

 	c->flags &=3D ~(1 << attr);
 }
-EXPORT_SYMBOL(nftnl_flowtable_unset);

 static uint32_t nftnl_flowtable_validate[NFTNL_FLOWTABLE_MAX + 1] =3D {
 	[NFTNL_FLOWTABLE_HOOKNUM]	=3D sizeof(uint32_t),
@@ -104,6 +104,7 @@ static uint32_t nftnl_flowtable_validate[NFTNL_FLOWTAB=
LE_MAX + 1] =3D {
 	[NFTNL_FLOWTABLE_FLAGS]		=3D sizeof(uint32_t),
 };

+EXPORT_SYMBOL(nftnl_flowtable_set_data);
 int nftnl_flowtable_set_data(struct nftnl_flowtable *c, uint16_t attr,
 			     const void *data, uint32_t data_len)
 {
@@ -169,32 +170,32 @@ int nftnl_flowtable_set_data(struct nftnl_flowtable =
*c, uint16_t attr,
 	c->flags |=3D (1 << attr);
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_flowtable_set_data);

+EXPORT_SYMBOL(nftnl_flowtable_set);
 void nftnl_flowtable_set(struct nftnl_flowtable *c, uint16_t attr, const =
void *data)
 {
 	nftnl_flowtable_set_data(c, attr, data, nftnl_flowtable_validate[attr]);
 }
-EXPORT_SYMBOL(nftnl_flowtable_set);

+EXPORT_SYMBOL(nftnl_flowtable_set_u32);
 void nftnl_flowtable_set_u32(struct nftnl_flowtable *c, uint16_t attr, ui=
nt32_t data)
 {
 	nftnl_flowtable_set_data(c, attr, &data, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nftnl_flowtable_set_u32);

+EXPORT_SYMBOL(nftnl_flowtable_set_s32);
 void nftnl_flowtable_set_s32(struct nftnl_flowtable *c, uint16_t attr, in=
t32_t data)
 {
 	nftnl_flowtable_set_data(c, attr, &data, sizeof(int32_t));
 }
-EXPORT_SYMBOL(nftnl_flowtable_set_s32);

+EXPORT_SYMBOL(nftnl_flowtable_set_str);
 int nftnl_flowtable_set_str(struct nftnl_flowtable *c, uint16_t attr, con=
st char *str)
 {
 	return nftnl_flowtable_set_data(c, attr, str, strlen(str) + 1);
 }
-EXPORT_SYMBOL(nftnl_flowtable_set_str);

+EXPORT_SYMBOL(nftnl_flowtable_get_data);
 const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c,
 				     uint16_t attr, uint32_t *data_len)
 {
@@ -228,21 +229,21 @@ const void *nftnl_flowtable_get_data(const struct nf=
tnl_flowtable *c,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_flowtable_get_data);

+EXPORT_SYMBOL(nftnl_flowtable_get);
 const void *nftnl_flowtable_get(const struct nftnl_flowtable *c, uint16_t=
 attr)
 {
 	uint32_t data_len;
 	return nftnl_flowtable_get_data(c, attr, &data_len);
 }
-EXPORT_SYMBOL(nftnl_flowtable_get);

+EXPORT_SYMBOL(nftnl_flowtable_get_str);
 const char *nftnl_flowtable_get_str(const struct nftnl_flowtable *c, uint=
16_t attr)
 {
 	return nftnl_flowtable_get(c, attr);
 }
-EXPORT_SYMBOL(nftnl_flowtable_get_str);

+EXPORT_SYMBOL(nftnl_flowtable_get_u32);
 uint32_t nftnl_flowtable_get_u32(const struct nftnl_flowtable *c, uint16_=
t attr)
 {
 	uint32_t data_len =3D 0;
@@ -252,8 +253,8 @@ uint32_t nftnl_flowtable_get_u32(const struct nftnl_fl=
owtable *c, uint16_t attr)

 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_flowtable_get_u32);

+EXPORT_SYMBOL(nftnl_flowtable_get_s32);
 int32_t nftnl_flowtable_get_s32(const struct nftnl_flowtable *c, uint16_t=
 attr)
 {
 	uint32_t data_len =3D 0;
@@ -263,8 +264,8 @@ int32_t nftnl_flowtable_get_s32(const struct nftnl_flo=
wtable *c, uint16_t attr)

 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_flowtable_get_s32);

+EXPORT_SYMBOL(nftnl_flowtable_nlmsg_build_payload);
 void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 					 const struct nftnl_flowtable *c)
 {
@@ -300,7 +301,6 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsgh=
dr *nlh,
 	if (c->flags & (1 << NFTNL_FLOWTABLE_SIZE))
 		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_SIZE, htonl(c->size));
 }
-EXPORT_SYMBOL(nftnl_flowtable_nlmsg_build_payload);

 static int nftnl_flowtable_parse_attr_cb(const struct nlattr *attr, void =
*data)
 {
@@ -418,6 +418,7 @@ static int nftnl_flowtable_parse_hook(struct nlattr *a=
ttr, struct nftnl_flowtabl
 	return 0;
 }

+EXPORT_SYMBOL(nftnl_flowtable_nlmsg_parse);
 int nftnl_flowtable_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_=
flowtable *c)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_MAX + 1] =3D {};
@@ -466,7 +467,6 @@ int nftnl_flowtable_nlmsg_parse(const struct nlmsghdr =
*nlh, struct nftnl_flowtab

 	return ret;
 }
-EXPORT_SYMBOL(nftnl_flowtable_nlmsg_parse);

 static const char *nftnl_hooknum2str(int family, int hooknum)
 {
@@ -519,14 +519,15 @@ static inline int nftnl_str2hooknum(int family, cons=
t char *hook)
 	return -1;
 }

+EXPORT_SYMBOL(nftnl_flowtable_parse);
 int nftnl_flowtable_parse(struct nftnl_flowtable *c, enum nftnl_parse_typ=
e type,
 			  const char *data, struct nftnl_parse_err *err)
 {
 	errno =3D EOPNOTSUPP;
 	return -1;
 }
-EXPORT_SYMBOL(nftnl_flowtable_parse);

+EXPORT_SYMBOL(nftnl_flowtable_parse_file);
 int nftnl_flowtable_parse_file(struct nftnl_flowtable *c,
 			       enum nftnl_parse_type type,
 			       FILE *fp, struct nftnl_parse_err *err)
@@ -534,7 +535,6 @@ int nftnl_flowtable_parse_file(struct nftnl_flowtable =
*c,
 	errno =3D EOPNOTSUPP;
 	return -1;
 }
-EXPORT_SYMBOL(nftnl_flowtable_parse_file);

 static int nftnl_flowtable_snprintf_default(char *buf, size_t size,
 					    const struct nftnl_flowtable *c)
@@ -590,6 +590,7 @@ static int nftnl_flowtable_cmd_snprintf(char *buf, siz=
e_t size,
 	return offset;
 }

+EXPORT_SYMBOL(nftnl_flowtable_snprintf);
 int nftnl_flowtable_snprintf(char *buf, size_t size, const struct nftnl_f=
lowtable *c,
 			 uint32_t type, uint32_t flags)
 {
@@ -599,7 +600,6 @@ int nftnl_flowtable_snprintf(char *buf, size_t size, c=
onst struct nftnl_flowtabl
 	return nftnl_flowtable_cmd_snprintf(buf, size, c, nftnl_flag2cmd(flags),
 					    type, flags);
 }
-EXPORT_SYMBOL(nftnl_flowtable_snprintf);

 static int nftnl_flowtable_do_snprintf(char *buf, size_t size, const void=
 *c,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
@@ -607,18 +607,19 @@ static int nftnl_flowtable_do_snprintf(char *buf, si=
ze_t size, const void *c,
 	return nftnl_flowtable_snprintf(buf, size, c, type, flags);
 }

+EXPORT_SYMBOL(nftnl_flowtable_fprintf);
 int nftnl_flowtable_fprintf(FILE *fp, const struct nftnl_flowtable *c,
 			    uint32_t type, uint32_t flags)
 {
 	return nftnl_fprintf(fp, c, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_flowtable_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_flowtable_fprintf);

 struct nftnl_flowtable_list {
 	struct list_head list;
 };

+EXPORT_SYMBOL(nftnl_flowtable_list_alloc);
 struct nftnl_flowtable_list *nftnl_flowtable_list_alloc(void)
 {
 	struct nftnl_flowtable_list *list;
@@ -631,8 +632,8 @@ struct nftnl_flowtable_list *nftnl_flowtable_list_allo=
c(void)

 	return list;
 }
-EXPORT_SYMBOL(nftnl_flowtable_list_alloc);

+EXPORT_SYMBOL(nftnl_flowtable_list_free);
 void nftnl_flowtable_list_free(struct nftnl_flowtable_list *list)
 {
 	struct nftnl_flowtable *s, *tmp;
@@ -643,34 +644,34 @@ void nftnl_flowtable_list_free(struct nftnl_flowtabl=
e_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nftnl_flowtable_list_free);

+EXPORT_SYMBOL(nftnl_flowtable_list_is_empty);
 int nftnl_flowtable_list_is_empty(const struct nftnl_flowtable_list *list=
)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nftnl_flowtable_list_is_empty);

+EXPORT_SYMBOL(nftnl_flowtable_list_add);
 void nftnl_flowtable_list_add(struct nftnl_flowtable *s,
 			      struct nftnl_flowtable_list *list)
 {
 	list_add(&s->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_flowtable_list_add);

+EXPORT_SYMBOL(nftnl_flowtable_list_add_tail);
 void nftnl_flowtable_list_add_tail(struct nftnl_flowtable *s,
 				   struct nftnl_flowtable_list *list)
 {
 	list_add_tail(&s->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_flowtable_list_add_tail);

+EXPORT_SYMBOL(nftnl_flowtable_list_del);
 void nftnl_flowtable_list_del(struct nftnl_flowtable *s)
 {
 	list_del(&s->head);
 }
-EXPORT_SYMBOL(nftnl_flowtable_list_del);

+EXPORT_SYMBOL(nftnl_flowtable_list_foreach);
 int nftnl_flowtable_list_foreach(struct nftnl_flowtable_list *flowtable_l=
ist,
 				 int (*cb)(struct nftnl_flowtable *t, void *data), void *data)
 {
@@ -684,4 +685,3 @@ int nftnl_flowtable_list_foreach(struct nftnl_flowtabl=
e_list *flowtable_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_flowtable_list_foreach);
=2D-
2.23.0

