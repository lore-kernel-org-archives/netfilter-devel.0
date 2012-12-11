From: "Vitaly E. Lavrov" <lve@guap.ru>
Subject: [PATCH] xt_hashlimit fix BUG()
Date: Tue, 11 Dec 2012 23:32:21 +0400
Message-ID: <50C78A45.4040901@guap.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060202020706090806030003"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.guap.ru ([91.151.188.3]:14143 "EHLO mail.guap.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab2LKTcX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:32:23 -0500
Received: from [10.150.100.7] (95-161-253-150.broadband.spb.TiERA.org [95.161.253.150])
	(user=lve@guap.ru mech=CRAM-MD5 bits=0)
	by mail.guap.ru (8.14.4/8.14.4) with ESMTP id qBBJWLuH024075
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Dec 2012 23:32:21 +0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060202020706090806030003
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The following patch fixes a bug in xt_hashlimit.
Bug appears at the end of work the networks namespace, provided that the 
tables (filter/mangle/raw) have rule  with xt_hashlimit.
The error occurs because the __net_exit hashlimit_net_exit() is executed 
before the tables are cleared.
Change this order of calls is impossible, since tables must be 
registered earlier than extensions.
Bug exists in all versions of the kernel since 2.6.35

Cleaning tables before completing the network namespace can be used as a 
workaround.

Idea of the patch that if the files are deleted from the directory 
/proc/net/ip[6]t_hashlimit/" procedure XXXXX, then a flag is set "clean".
If cleaning the tables occurs later and the flag "clean" is set, then 
the delete files is skipped.

Patch for kernel 3.4.22

Signed-off-by: Vitaly Lavrov lve@guap.ru

---
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2195eb0..5416185 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -46,6 +46,7 @@ struct hashlimit_net {
         struct hlist_head       htables;
         struct proc_dir_entry   *ipt_hashlimit;
         struct proc_dir_entry   *ip6t_hashlimit;
+       int                     clean;
  };

  static int hashlimit_net_id;
@@ -319,7 +320,8 @@ static void htable_destroy(struct 
xt_hashlimit_htable *hinfo)
                 parent = hashlimit_net->ipt_hashlimit;
         else
                 parent = hashlimit_net->ip6t_hashlimit;
-       remove_proc_entry(hinfo->pde->name, parent);
+       if(!hashlimit_net->clean)
+               remove_proc_entry(hinfo->pde->name, parent);
         htable_selective_cleanup(hinfo, select_all);
         vfree(hinfo);
  }
@@ -784,6 +786,7 @@ static int __net_init hashlimit_net_init(struct net 
*net)
  {
         struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);

+       hashlimit_net->clean = 0;
         INIT_HLIST_HEAD(&hashlimit_net->htables);
         return hashlimit_proc_net_init(net);
  }
@@ -791,8 +794,19 @@ static int __net_init hashlimit_net_init(struct net 
*net)
  static void __net_exit hashlimit_net_exit(struct net *net)
  {
         struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
+       struct xt_hashlimit_htable *hinfo;
+       struct hlist_node *pos;
+       struct proc_dir_entry *pde;
+
+       mutex_lock(&hashlimit_mutex);
+       hashlimit_net->clean = 1;
+       pde = hashlimit_net->ipt_hashlimit;
+       if(!pde) pde = hashlimit_net->ip6t_hashlimit;
+       hlist_for_each_entry(hinfo, pos, &hashlimit_net->htables, node) {
+               remove_proc_entry(hinfo->pde->name,pde);
+       }
+       mutex_unlock(&hashlimit_mutex);

-       BUG_ON(!hlist_empty(&hashlimit_net->htables));
         hashlimit_proc_net_exit(net);
  }
--

--------------060202020706090806030003
Content-Type: text/plain; charset=UTF-8;
 name="xt_hashlimit.c.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="xt_hashlimit.c.patch"

ZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIveHRfaGFzaGxpbWl0LmMgYi9uZXQvbmV0Zmls
dGVyL3h0X2hhc2hsaW1pdC5jCmluZGV4IDIxOTVlYjAuLjU0MTYxODUgMTAwNjQ0Ci0tLSBh
L25ldC9uZXRmaWx0ZXIveHRfaGFzaGxpbWl0LmMKKysrIGIvbmV0L25ldGZpbHRlci94dF9o
YXNobGltaXQuYwpAQCAtNDYsNiArNDYsNyBAQCBzdHJ1Y3QgaGFzaGxpbWl0X25ldCB7CiAJ
c3RydWN0IGhsaXN0X2hlYWQJaHRhYmxlczsKIAlzdHJ1Y3QgcHJvY19kaXJfZW50cnkJKmlw
dF9oYXNobGltaXQ7CiAJc3RydWN0IHByb2NfZGlyX2VudHJ5CSppcDZ0X2hhc2hsaW1pdDsK
KwlpbnQJCQljbGVhbjsKIH07CiAKIHN0YXRpYyBpbnQgaGFzaGxpbWl0X25ldF9pZDsKQEAg
LTMxOSw3ICszMjAsOCBAQCBzdGF0aWMgdm9pZCBodGFibGVfZGVzdHJveShzdHJ1Y3QgeHRf
aGFzaGxpbWl0X2h0YWJsZSAqaGluZm8pCiAJCXBhcmVudCA9IGhhc2hsaW1pdF9uZXQtPmlw
dF9oYXNobGltaXQ7CiAJZWxzZQogCQlwYXJlbnQgPSBoYXNobGltaXRfbmV0LT5pcDZ0X2hh
c2hsaW1pdDsKLQlyZW1vdmVfcHJvY19lbnRyeShoaW5mby0+cGRlLT5uYW1lLCBwYXJlbnQp
OworCWlmKCFoYXNobGltaXRfbmV0LT5jbGVhbikKKwkJcmVtb3ZlX3Byb2NfZW50cnkoaGlu
Zm8tPnBkZS0+bmFtZSwgcGFyZW50KTsKIAlodGFibGVfc2VsZWN0aXZlX2NsZWFudXAoaGlu
Zm8sIHNlbGVjdF9hbGwpOwogCXZmcmVlKGhpbmZvKTsKIH0KQEAgLTc4NCw2ICs3ODYsNyBA
QCBzdGF0aWMgaW50IF9fbmV0X2luaXQgaGFzaGxpbWl0X25ldF9pbml0KHN0cnVjdCBuZXQg
Km5ldCkKIHsKIAlzdHJ1Y3QgaGFzaGxpbWl0X25ldCAqaGFzaGxpbWl0X25ldCA9IGhhc2hs
aW1pdF9wZXJuZXQobmV0KTsKIAorCWhhc2hsaW1pdF9uZXQtPmNsZWFuID0gMDsKIAlJTklU
X0hMSVNUX0hFQUQoJmhhc2hsaW1pdF9uZXQtPmh0YWJsZXMpOwogCXJldHVybiBoYXNobGlt
aXRfcHJvY19uZXRfaW5pdChuZXQpOwogfQpAQCAtNzkxLDggKzc5NCwxOSBAQCBzdGF0aWMg
aW50IF9fbmV0X2luaXQgaGFzaGxpbWl0X25ldF9pbml0KHN0cnVjdCBuZXQgKm5ldCkKIHN0
YXRpYyB2b2lkIF9fbmV0X2V4aXQgaGFzaGxpbWl0X25ldF9leGl0KHN0cnVjdCBuZXQgKm5l
dCkKIHsKIAlzdHJ1Y3QgaGFzaGxpbWl0X25ldCAqaGFzaGxpbWl0X25ldCA9IGhhc2hsaW1p
dF9wZXJuZXQobmV0KTsKKwlzdHJ1Y3QgeHRfaGFzaGxpbWl0X2h0YWJsZSAqaGluZm87CisJ
c3RydWN0IGhsaXN0X25vZGUgKnBvczsKKwlzdHJ1Y3QgcHJvY19kaXJfZW50cnkgKnBkZTsK
KworCW11dGV4X2xvY2soJmhhc2hsaW1pdF9tdXRleCk7CisJaGFzaGxpbWl0X25ldC0+Y2xl
YW4gPSAxOworCXBkZSA9IGhhc2hsaW1pdF9uZXQtPmlwdF9oYXNobGltaXQ7CisJaWYoIXBk
ZSkgcGRlID0gaGFzaGxpbWl0X25ldC0+aXA2dF9oYXNobGltaXQ7CisJaGxpc3RfZm9yX2Vh
Y2hfZW50cnkoaGluZm8sIHBvcywgJmhhc2hsaW1pdF9uZXQtPmh0YWJsZXMsIG5vZGUpIHsK
KwkJcmVtb3ZlX3Byb2NfZW50cnkoaGluZm8tPnBkZS0+bmFtZSxwZGUpOworCX0KKwltdXRl
eF91bmxvY2soJmhhc2hsaW1pdF9tdXRleCk7CiAKLQlCVUdfT04oIWhsaXN0X2VtcHR5KCZo
YXNobGltaXRfbmV0LT5odGFibGVzKSk7CiAJaGFzaGxpbWl0X3Byb2NfbmV0X2V4aXQobmV0
KTsKIH0KIAo=
--------------060202020706090806030003--
