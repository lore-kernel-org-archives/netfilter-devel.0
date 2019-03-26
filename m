Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2740CC10F05
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D531E20700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="doUPSJr8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732800AbfCZU5s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:57:48 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21044 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU5s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:57:48 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633857; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=E9Qz1e5pApwzLbjD/7B0cxDWxPHUXxXqmQqn82aaOgHSSPfYa/BwAUR0MLsWstUMthiaD//3s5BZC6u5EuIJJtgAZZwTpnv0luLmqw27oPHu5DPXA9r1tnIBKcEyCgK66qnrHOk6kdTI/qDfNnPzfQG42PGUmpSMnAljK8wQLN0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633857; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=sVTUDP1D/Xg9En8NKjz9zg6WRIOmBBfHMtuk9ue6A3I=; 
        b=QbpnTq2ok+rtWZFm3wDES/pUsjaEX9EU3gtGY7CyJrWFFLZQ3DPamryXqWxhZj0vMlt1Tiqj7b0zXB8b6LzAgHsb/oAx3uOFVyJO3RCbTo97fITyBYTPD5GAaaB5/FAibhXU9xsOnyVJb94LbgP1zxQf+WXSdgAUZEVDWCRxpxo=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633857;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=13391; bh=sVTUDP1D/Xg9En8NKjz9zg6WRIOmBBfHMtuk9ue6A3I=;
        b=doUPSJr8hKliL+0YQpEGIGg1XLdvlaHt1t0D3GBV1xy2TTd2Chss5WlOnewQhr41
        DzNSoj0hJW37R946teBfK5WxzLnyvZJOkEUVAZ27O+WB98b8tRPi/S5l8J6rist/4qT
        1ox/z0e4aayHUKz27RXbT+8u3aIuU3y2ARXHCxOY=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553633856195782.1851203181355; Tue, 26 Mar 2019 13:57:36 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-3-fbl@sysclose.org>
Subject: [PATCH net-next 2/8] netfilter: add API to manage NAT helpers.
Date:   Tue, 26 Mar 2019 17:57:09 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326205715.22288-1-fbl@sysclose.org>
References: <20190326205715.22288-1-fbl@sysclose.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The API allows a conntrack helper to indicate its corresponding
NAT helper which then can be loaded and reference counted.

Signed-off-by: Flavio Leitner <fbl@sysclose.org>
---
 include/net/netfilter/nf_conntrack_helper.h |  19 +++-
 net/netfilter/nf_conntrack_amanda.c         |   2 +
 net/netfilter/nf_conntrack_ftp.c            |   6 +-
 net/netfilter/nf_conntrack_helper.c         | 108 +++++++++++++++++++-
 net/netfilter/nf_conntrack_irc.c            |   3 +-
 net/netfilter/nf_conntrack_sane.c           |   4 +-
 net/netfilter/nf_conntrack_sip.c            |  12 ++-
 net/netfilter/nf_conntrack_tftp.c           |   6 +-
 8 files changed, 147 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netf=
ilter/nf_conntrack_helper.h
index e86fadf7e7c5..0d36d6bfb522 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -58,6 +58,8 @@ struct nf_conntrack_helper {
 =09unsigned int queue_num;
 =09/* length of userspace private data stored in nf_conn_help->data */
 =09u16 data_len;
+=09/* name of NAT helper module */
+=09char nat_mod_name[NF_CT_HELPER_NAME_LEN];
 };
=20
 /* Must be kept in sync with the classes defined by helpers */
@@ -98,7 +100,8 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helpe=
r,
 =09=09=09=09   enum ip_conntrack_info ctinfo),
 =09=09       int (*from_nlattr)(struct nlattr *attr,
 =09=09=09=09=09  struct nf_conn *ct),
-=09=09       struct module *module);
+=09=09       struct module *module,
+=09=09       const char *nat_mod_name);
=20
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
@@ -157,4 +160,18 @@ nf_ct_helper_expectfn_find_by_symbol(const void *symbo=
l);
 extern struct hlist_head *nf_ct_helper_hash;
 extern unsigned int nf_ct_helper_hsize;
=20
+struct nf_conntrack_helper_nat {
+=09struct list_head list;
+=09char name[NF_CT_HELPER_NAME_LEN];
+=09struct module *module;=09=09/* pointer to self */
+};
+
+void nf_ct_helper_nat_init(struct nf_conntrack_helper_nat *nat,
+=09=09=09   const char *name, struct module *module);
+
+void nf_conntrack_helper_nat_register(struct nf_conntrack_helper_nat *nat)=
;
+void nf_conntrack_helper_nat_unregister(struct nf_conntrack_helper_nat *na=
t);
+int nf_conntrack_helper_nat_try_module_get(const char *name, u16 l3num,
+=09=09=09=09=09   u8 protonum);
+void nf_conntrack_helper_nat_put(struct nf_conntrack_helper *helper);
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntra=
ck_amanda.c
index f2681ec5b5f6..b5d255897d9e 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -186,6 +186,7 @@ static struct nf_conntrack_helper amanda_helper[2] __re=
ad_mostly =3D {
 =09=09.tuple.src.u.udp.port=09=3D cpu_to_be16(10080),
 =09=09.tuple.dst.protonum=09=3D IPPROTO_UDP,
 =09=09.expect_policy=09=09=3D &amanda_exp_policy,
+=09=09.nat_mod_name=09=09=3D NF_CT_NAT_HELPER_MOD_NAME("amanda"),
 =09},
 =09{
 =09=09.name=09=09=09=3D "amanda",
@@ -195,6 +196,7 @@ static struct nf_conntrack_helper amanda_helper[2] __re=
ad_mostly =3D {
 =09=09.tuple.src.u.udp.port=09=3D cpu_to_be16(10080),
 =09=09.tuple.dst.protonum=09=3D IPPROTO_UDP,
 =09=09.expect_policy=09=09=3D &amanda_exp_policy,
+=09=09.nat_mod_name=09=09=3D NF_CT_NAT_HELPER_MOD_NAME("amanda"),
 =09},
 };
=20
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_=
ftp.c
index a11c304fb771..fec9bb462071 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -590,10 +590,12 @@ static int __init nf_conntrack_ftp_init(void)
 =09for (i =3D 0; i < ports_c; i++) {
 =09=09nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP, "ftp",
 =09=09=09=09  FTP_PORT, ports[i], ports[i], &ftp_exp_policy,
-=09=09=09=09  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE);
+=09=09=09=09  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("ftp"));
 =09=09nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP, "ftp",
 =09=09=09=09  FTP_PORT, ports[i], ports[i], &ftp_exp_policy,
-=09=09=09=09  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE);
+=09=09=09=09  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("ftp"));
 =09}
=20
 =09ret =3D nf_conntrack_helpers_register(ftp, ports_c * 2);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntra=
ck_helper.c
index 274baf1dab87..883a8d438503 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -42,6 +42,9 @@ module_param_named(nf_conntrack_helper, nf_ct_auto_assign=
_helper, bool, 0644);
 MODULE_PARM_DESC(nf_conntrack_helper,
 =09=09 "Enable automatic conntrack helper assignment (default 0)");
=20
+static struct list_head nf_ct_nat_helpers __read_mostly;
+static DEFINE_SPINLOCK(nf_ct_nat_helpers_lock);
+
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
 static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
@@ -130,6 +133,75 @@ void nf_conntrack_helper_put(struct nf_conntrack_helpe=
r *helper)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
=20
+static struct nf_conntrack_helper_nat *
+nf_conntrack_helper_nat_find(const char *name)
+{
+=09struct nf_conntrack_helper_nat *cur;
+=09bool found =3D false;
+
+=09list_for_each_entry_rcu(cur, &nf_ct_nat_helpers, list) {
+=09=09if (!strcmp(cur->name, name)) {
+=09=09=09found =3D true;
+=09=09=09break;
+=09=09}
+=09}
+=09return found ? cur : NULL;
+}
+
+int
+nf_conntrack_helper_nat_try_module_get(const char *name, u16 l3num, u8 pro=
tonum)
+{
+=09struct nf_conntrack_helper *h;
+=09struct nf_conntrack_helper_nat *nat;
+=09char mod_name[NF_CT_HELPER_NAME_LEN];
+=09int ret =3D 0;
+
+=09rcu_read_lock();
+=09h =3D __nf_conntrack_helper_find(name, l3num, protonum);
+=09if (h =3D=3D NULL) {
+=09=09rcu_read_unlock();
+=09=09return -EINVAL;
+=09}
+
+=09if (!strlen(h->nat_mod_name)) {
+=09=09rcu_read_unlock();
+=09=09return -EOPNOTSUPP;
+=09}
+
+=09nat =3D nf_conntrack_helper_nat_find(h->nat_mod_name);
+=09if (nat =3D=3D NULL) {
+=09=09snprintf(mod_name, sizeof(mod_name), "%s", h->nat_mod_name);
+=09=09rcu_read_unlock();
+=09=09ret =3D request_module(mod_name);
+=09=09if (ret !=3D 0)
+=09=09=09return ret;
+
+=09=09rcu_read_lock();
+=09=09nat =3D nf_conntrack_helper_nat_find(mod_name);
+=09=09if (nat =3D=3D NULL) {
+=09=09=09rcu_read_unlock();
+=09=09=09return -EINVAL;
+=09=09}
+=09}
+
+=09if (!try_module_get(nat->module))
+=09=09ret =3D -EINVAL;
+
+=09rcu_read_unlock();
+=09return ret;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_nat_try_module_get);
+
+void nf_conntrack_helper_nat_put(struct nf_conntrack_helper *helper)
+{
+=09struct nf_conntrack_helper_nat *nat;
+
+=09nat =3D nf_conntrack_helper_nat_find(helper->nat_mod_name);
+=09BUG_ON(nat =3D=3D NULL);
+=09module_put(nat->module);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_nat_put);
+
 struct nf_conn_help *
 nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 {
@@ -420,7 +492,8 @@ void nf_ct_helper_init(struct nf_conntrack_helper *help=
er,
 =09=09=09=09   enum ip_conntrack_info ctinfo),
 =09=09       int (*from_nlattr)(struct nlattr *attr,
 =09=09=09=09=09  struct nf_conn *ct),
-=09=09       struct module *module)
+=09=09       struct module *module,
+=09=09       const char *nat_mod_name)
 {
 =09helper->tuple.src.l3num =3D l3num;
 =09helper->tuple.dst.protonum =3D protonum;
@@ -430,6 +503,10 @@ void nf_ct_helper_init(struct nf_conntrack_helper *hel=
per,
 =09helper->help =3D help;
 =09helper->from_nlattr =3D from_nlattr;
 =09helper->me =3D module;
+=09helper->nat_mod_name[0] =3D '\0';
+=09if (nat_mod_name)
+=09=09snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
+=09=09=09 "%s", nat_mod_name);
=20
 =09if (spec_port =3D=3D default_port)
 =09=09snprintf(helper->name, sizeof(helper->name), "%s", name);
@@ -466,6 +543,34 @@ void nf_conntrack_helpers_unregister(struct nf_conntra=
ck_helper *helper,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
=20
+void nf_conntrack_helper_nat_register(struct nf_conntrack_helper_nat *nat)
+{
+=09BUG_ON(nat->module =3D=3D NULL);
+
+=09spin_lock(&nf_ct_nat_helpers_lock);
+=09list_add_rcu(&nat->list, &nf_ct_nat_helpers);
+=09spin_unlock(&nf_ct_nat_helpers_lock);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_nat_register);
+
+void nf_conntrack_helper_nat_unregister(struct nf_conntrack_helper_nat *na=
t)
+{
+=09BUG_ON(nat->module =3D=3D NULL);
+
+=09spin_lock(&nf_ct_nat_helpers_lock);
+=09list_del_rcu(&nat->list);
+=09spin_unlock(&nf_ct_nat_helpers_lock);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_nat_unregister);
+
+void nf_ct_helper_nat_init(struct nf_conntrack_helper_nat *nat,
+=09=09=09   const char *name, struct module *module)
+{
+=09nat->module =3D module;
+=09snprintf(nat->name, sizeof(nat->name), "%s", name);
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_nat_init);
+
 static const struct nf_ct_ext_type helper_extend =3D {
 =09.len=09=3D sizeof(struct nf_conn_help),
 =09.align=09=3D __alignof__(struct nf_conn_help),
@@ -493,6 +598,7 @@ int nf_conntrack_helper_init(void)
 =09=09goto out_extend;
 =09}
=20
+=09INIT_LIST_HEAD(&nf_ct_nat_helpers);
 =09return 0;
 out_extend:
 =09kvfree(nf_ct_helper_hash);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_=
irc.c
index 4099f4d79bae..659aa2cb5493 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -261,7 +261,8 @@ static int __init nf_conntrack_irc_init(void)
 =09for (i =3D 0; i < ports_c; i++) {
 =09=09nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, "irc",
 =09=09=09=09  IRC_PORT, ports[i], i, &irc_exp_policy,
-=09=09=09=09  0, help, NULL, THIS_MODULE);
+=09=09=09=09  0, help, NULL, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("irc"));
 =09}
=20
 =09ret =3D nf_conntrack_helpers_register(&irc[0], ports_c);
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack=
_sane.c
index 5072ff96ab33..b08724b8754c 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -198,11 +198,11 @@ static int __init nf_conntrack_sane_init(void)
 =09=09nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP, "sane",
 =09=09=09=09  SANE_PORT, ports[i], ports[i],
 =09=09=09=09  &sane_exp_policy, 0, help, NULL,
-=09=09=09=09  THIS_MODULE);
+=09=09=09=09  THIS_MODULE, NULL);
 =09=09nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP, "sane",
 =09=09=09=09  SANE_PORT, ports[i], ports[i],
 =09=09=09=09  &sane_exp_policy, 0, help, NULL,
-=09=09=09=09  THIS_MODULE);
+=09=09=09=09  THIS_MODULE, NULL);
 =09}
=20
 =09ret =3D nf_conntrack_helpers_register(sane, ports_c * 2);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_=
sip.c
index f067c6b50857..0d4fca4a329f 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1677,19 +1677,23 @@ static int __init nf_conntrack_sip_init(void)
 =09=09nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP, "sip",
 =09=09=09=09  SIP_PORT, ports[i], i, sip_exp_policy,
 =09=09=09=09  SIP_EXPECT_MAX, sip_help_udp,
-=09=09=09=09  NULL, THIS_MODULE);
+=09=09=09=09  NULL, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("sip"));
 =09=09nf_ct_helper_init(&sip[4 * i + 1], AF_INET, IPPROTO_TCP, "sip",
 =09=09=09=09  SIP_PORT, ports[i], i, sip_exp_policy,
 =09=09=09=09  SIP_EXPECT_MAX, sip_help_tcp,
-=09=09=09=09  NULL, THIS_MODULE);
+=09=09=09=09  NULL, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("sip"));
 =09=09nf_ct_helper_init(&sip[4 * i + 2], AF_INET6, IPPROTO_UDP, "sip",
 =09=09=09=09  SIP_PORT, ports[i], i, sip_exp_policy,
 =09=09=09=09  SIP_EXPECT_MAX, sip_help_udp,
-=09=09=09=09  NULL, THIS_MODULE);
+=09=09=09=09  NULL, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("sip"));
 =09=09nf_ct_helper_init(&sip[4 * i + 3], AF_INET6, IPPROTO_TCP, "sip",
 =09=09=09=09  SIP_PORT, ports[i], i, sip_exp_policy,
 =09=09=09=09  SIP_EXPECT_MAX, sip_help_tcp,
-=09=09=09=09  NULL, THIS_MODULE);
+=09=09=09=09  NULL, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("sip"));
 =09}
=20
 =09ret =3D nf_conntrack_helpers_register(sip, ports_c * 4);
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack=
_tftp.c
index 548b673b3625..e1fbf892db70 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -121,10 +121,12 @@ static int __init nf_conntrack_tftp_init(void)
 =09for (i =3D 0; i < ports_c; i++) {
 =09=09nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP, "tftp",
 =09=09=09=09  TFTP_PORT, ports[i], i, &tftp_exp_policy,
-=09=09=09=09  0, tftp_help, NULL, THIS_MODULE);
+=09=09=09=09  0, tftp_help, NULL, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("tftp"));
 =09=09nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP, "tftp",
 =09=09=09=09  TFTP_PORT, ports[i], i, &tftp_exp_policy,
-=09=09=09=09  0, tftp_help, NULL, THIS_MODULE);
+=09=09=09=09  0, tftp_help, NULL, THIS_MODULE,
+=09=09=09=09  NF_CT_NAT_HELPER_MOD_NAME("tftp"));
 =09}
=20
 =09ret =3D nf_conntrack_helpers_register(tftp, ports_c * 2);
--=20
2.20.1



