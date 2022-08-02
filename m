Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A296C00144
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 02:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbiHBCQS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 22:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiHBCQQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 22:16:16 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01985474E0
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 19:16:14 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:47668.974574158
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-180.167.241.60 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 14FF92800A5;
        Tue,  2 Aug 2022 10:16:13 +0800 (CST)
X-189-SAVE-TO-SEND: +wenxu@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id ebbb1dc1cf344ce89a8275e28d428ae1 for wenxu@chinatelecom.cn;
        Tue, 02 Aug 2022 10:16:13 CST
X-Transaction-ID: ebbb1dc1cf344ce89a8275e28d428ae1
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Date:   Tue, 2 Aug 2022 10:16:12 +0800
From:   "wenxu@chinatelecom.cn" <wenxu@chinatelecom.cn>
To:     wenxu <wenxu@chinatelecom.cn>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Re: [PATCH nf-next] netfilter: nf_flow_table: delay teardown the offload flow until fin packet recv from both direction
References: <1658810716-106274-1-git-send-email-wenxu@chinatelecom.cn>, 
        <YuepHPfKs6UtI3TF@salvia>, 
        <202208020950236233262@chinatelecom.cn>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.2.23.121[cn]
Mime-Version: 1.0
Message-ID: <202208021016120385278@chinatelecom.cn>
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cgo+CgoKCj4KCgoKPkhpLAoKCgo+IAoKCgo+T24gVHVlLCBKdWwgMjYsIDIwMjIgYXQgMTI6NDU6
MTZBTSAtMDQwMCwgd2VueHVAY2hpbmF0ZWxlY29tLmNuIHdyb3RlOgoKCgo+PiBGcm9tOiB3ZW54
dSA8d2VueHVAY2hpbmF0ZWxlY29tLmNuPgoKCgo+PiAKCgoKPj4gQSBmaW4gcGFja2V0IHJlY2Vp
dmUgbm90IGFsd2F5cyBtZWFucyB0aGUgdGNwIGNvbm5lY3Rpb24gdGVhcmRvd24uCgoKCj4+IEZv
ciB0Y3AgaGFsZiBjbG9zZSBjYXNlLCBvbmx5IHRoZSBjbGllbnQgc2h1dGRvd24gdGhlIGNvbm5l
Y3Rpb24KCgoKPj4gYW5kIHRoZSBzZXJ2ZXIgc3RpbGwgY2FuIHNlbmRtc2cgdG8gdGhlIGNsaWVu
dC4gVGhlIGNvbm5lY3Rpb24KCgoKPj4gY2FuIHN0aWxsIGJlIG9mZmxvYWRlZCB1bnRpbCB0aGUg
c2VydmVyIHNodXRkb3duIHRoZSBjb25uZWN0aW9uLgoKCgo+PiAKCgoKPj4gU2lnbmVkLW9mZi1i
eTogd2VueHUgPHdlbnh1QGNoaW5hdGVsZWNvbS5jbj4KCgoKPj4gLS0tCgoKCj4+wqAgaW5jbHVk
ZS9uZXQvbmV0ZmlsdGVyL25mX2Zsb3dfdGFibGUuaCB8wqAgMyArKy0KCgoKPj7CoCBuZXQvbmV0
ZmlsdGVyL25mX2Zsb3dfdGFibGVfaXAuY8KgwqDCoMKgwqAgfCAxNCArKysrKysrKysrLS0tLQoK
Cgo+PsKgIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkK
CgoKPj4gCgoKCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvbmZfZmxvd190
YWJsZS5oIGIvaW5jbHVkZS9uZXQvbmV0ZmlsdGVyL25mX2Zsb3dfdGFibGUuaAoKCgo+PiBpbmRl
eCBkNTMyNmM0Li4wYzQ4NjRkIDEwMDY0NAoKCgo+PiAtLS0gYS9pbmNsdWRlL25ldC9uZXRmaWx0
ZXIvbmZfZmxvd190YWJsZS5oCgoKCj4+ICsrKyBiL2luY2x1ZGUvbmV0L25ldGZpbHRlci9uZl9m
bG93X3RhYmxlLmgKCgoKPj4gQEAgLTEyOSw3ICsxMjksOCBAQCBzdHJ1Y3QgZmxvd19vZmZsb2Fk
X3R1cGxlIHsKCgoKPj7CoCAvKiBBbGwgbWVtYmVycyBhYm92ZSBhcmUga2V5cyBmb3IgbG9va3Vw
cywgc2VlIGZsb3dfb2ZmbG9hZF9oYXNoKCkuICovCgoKCj4+wqAgc3RydWN0IHsgfSBfX2hhc2g7
CgoKCj4+wqAgCgoKCj4+IC0gdTggZGlyOjIsIAoKCgo+PiArIHU4IGRpcjoxLAoKCgo+PiArIGZp
bjoxLAoKCgo+PsKgIHhtaXRfdHlwZTozLAoKCgo+PsKgIGVuY2FwX251bToyLAoKCgo+PsKgIGlu
X3ZsYW5faW5ncmVzczoyOwoKCgo+PiBkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9uZl9mbG93
X3RhYmxlX2lwLmMgYi9uZXQvbmV0ZmlsdGVyL25mX2Zsb3dfdGFibGVfaXAuYwoKCgo+PiBpbmRl
eCBiMzUwZmU5Li5jMTkxODYxIDEwMDY0NAoKCgo+PiAtLS0gYS9uZXQvbmV0ZmlsdGVyL25mX2Zs
b3dfdGFibGVfaXAuYwoKCgo+PiArKysgYi9uZXQvbmV0ZmlsdGVyL25mX2Zsb3dfdGFibGVfaXAu
YwoKCgo+PiBAQCAtMTksNyArMTksOCBAQAoKCgo+PsKgICNpbmNsdWRlIDxsaW51eC91ZHAuaD4K
CgoKPj7CoCAKCgoKPj7CoCBzdGF0aWMgaW50IG5mX2Zsb3dfc3RhdGVfY2hlY2soc3RydWN0IGZs
b3dfb2ZmbG9hZCAqZmxvdywgaW50IHByb3RvLAoKCgo+PiAtwqDCoMKgwqDCoMKgwqAgc3RydWN0
IHNrX2J1ZmYgKnNrYiwgdW5zaWduZWQgaW50IHRob2ZmKQoKCgo+PiArwqDCoMKgwqDCoMKgwqAg
c3RydWN0IHNrX2J1ZmYgKnNrYiwgdW5zaWduZWQgaW50IHRob2ZmLAoKCgo+PiArwqDCoMKgwqDC
oMKgwqAgZW51bSBmbG93X29mZmxvYWRfdHVwbGVfZGlyIGRpcikKCgoKPj7CoCB7CgoKCj4+wqAg
c3RydWN0IHRjcGhkciAqdGNwaDsKCgoKPj7CoCAKCgoKPj4gQEAgLTI3LDkgKzI4LDE0IEBAIHN0
YXRpYyBpbnQgbmZfZmxvd19zdGF0ZV9jaGVjayhzdHJ1Y3QgZmxvd19vZmZsb2FkICpmbG93LCBp
bnQgcHJvdG8sCgoKCj4+wqAgcmV0dXJuIDA7CgoKCj4+wqAgCgoKCj4+wqAgdGNwaCA9ICh2b2lk
ICopKHNrYl9uZXR3b3JrX2hlYWRlcihza2IpICsgdGhvZmYpOwoKCgo+PiAtIGlmICh1bmxpa2Vs
eSh0Y3BoLT5maW4gfHwgdGNwaC0+cnN0KSkgewoKCgo+PiArIGlmICh1bmxpa2VseSh0Y3BoLT5y
c3QpKSB7CgoKCj4+wqAgZmxvd19vZmZsb2FkX3RlYXJkb3duKGZsb3cpOwoKCgo+PsKgIHJldHVy
biAtMTsKCgoKPj4gKyB9IGVsc2UgaWYgKHVubGlrZWx5KHRjcGgtPmZpbikpIHsKCgoKPj4gKyBm
bG93LT50dXBsZWhhc2hbZGlyXS50dXBsZS5maW4gPSAxOwoKCgo+PiArIGlmIChmbG93LT50dXBs
ZWhhc2hbIWRpcl0udHVwbGUuZmluID09IDEpCgoKCj4+ICsgZmxvd19vZmZsb2FkX3RlYXJkb3du
KGZsb3cpOwoKCgo+IAoKCgo+PiBNYXliZSBhZGQgYSBuZXcgZmxhZyB0byBlbnVtIG5mX2Zsb3df
ZmxhZ3MgaW5zdGVhZD8KCgoKPj4KCgoKTWF5YmUgdHdvIGZsYWdzIG5lZWQgZm9yIHRoaXM6wqAg
TkZfRkxPV19GSU5fT1JJR0lOLCBORl9GTE9XX1JFTFBZPwoKCgoKCgo=

