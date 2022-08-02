Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC42AC19F2B
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 03:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiHBDlt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 23:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbiHBDls (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 23:41:48 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DCF163E1
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 20:41:46 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:59512.1918909347
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-180.167.241.60 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id A19302800AD;
        Tue,  2 Aug 2022 11:41:42 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id b1deabe1b10a48c2a5eecc7f36e4970b for pablo@netfilter.org;
        Tue, 02 Aug 2022 11:41:43 CST
X-Transaction-ID: b1deabe1b10a48c2a5eecc7f36e4970b
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Date:   Tue, 2 Aug 2022 11:41:42 +0800
From:   "wenxu@chinatelecom.cn" <wenxu@chinatelecom.cn>
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Re: [PATCH nf-next v2 1/3] nf_flow_table_offload: offload the vlan encap in the flowtable
References: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>, 
        <Yuerh8IrTVa35dIs@salvia>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.2.23.121[cn]
Mime-Version: 1.0
Message-ID: <2022080211414160970821@chinatelecom.cn>
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CgoKCgoKCj5PbiBUaHUsIE1heSAyNiwgMjAyMiBhdCAwMjo1NzozMEFNIC0wNDAwLCB3ZW54dUBj
aGluYXRlbGVjb20uY24gd3JvdGU6CgoKCj5bLi4uXQoKCgo+PiBkaWZmIC0tZ2l0IGEvbmV0L25l
dGZpbHRlci9uZl9mbG93X3RhYmxlX2lwLmMgYi9uZXQvbmV0ZmlsdGVyL25mX2Zsb3dfdGFibGVf
aXAuYwoKCgo+PiBpbmRleCBiMzUwZmU5Li41ZGE2NTFkIDEwMDY0NAoKCgo+PiAtLS0gYS9uZXQv
bmV0ZmlsdGVyL25mX2Zsb3dfdGFibGVfaXAuYwoKCgo+PiArKysgYi9uZXQvbmV0ZmlsdGVyL25m
X2Zsb3dfdGFibGVfaXAuYwoKCgo+PiBAQCAtMjkxLDYgKzI5MSwyMyBAQCBzdGF0aWMgYm9vbCBu
Zl9mbG93X3NrYl9lbmNhcF9wcm90b2NvbChjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBfX2Jl
MTYgcHJvdG8sCgoKCj4+wqAgCXJldHVybiBmYWxzZTsKCgoKPj7CoCB9CgoKCj4+wqAgCgoKCj4+
ICtzdGF0aWMgdm9pZCBuZl9mbG93X2VuY2FwX3B1c2goc3RydWN0IHNrX2J1ZmYgKnNrYiwKCgoK
Pj4gKwkJCcKgwqDCoMKgwqDCoCBzdHJ1Y3QgZmxvd19vZmZsb2FkX3R1cGxlX3JoYXNoICp0dXBs
ZWhhc2gpCgoKCj4+ICt7CgoKCj4+ICsJaW50IGk7CgoKCj4+ICsKCgoKPj4gKwlmb3IgKGkgPSAw
OyBpIDwgdHVwbGVoYXNoLT50dXBsZS5lbmNhcF9udW07IGkrKykgewoKCgo+PiArCQlzd2l0Y2gg
KHR1cGxlaGFzaC0+dHVwbGUuZW5jYXBbaV0ucHJvdG8pIHsKCgoKPj4gKwkJY2FzZSBodG9ucyhF
VEhfUF84MDIxUSk6CgoKCj4+ICsJCWNhc2UgaHRvbnMoRVRIX1BfODAyMUFEKToKCgoKPj4gKwkJ
CXNrYl92bGFuX3B1c2goc2tiLAoKCgo+CgoKCj5OaXQ6IHNrYl92bGFuX3B1c2goKSBtaWdodCBm
YWlsLgoKCgo+CgoKCj4+ICsJCQkJwqDCoMKgwqDCoCB0dXBsZWhhc2gtPnR1cGxlLmVuY2FwW2ld
LnByb3RvLAoKCgo+PiArCQkJCcKgwqDCoMKgwqAgdHVwbGVoYXNoLT50dXBsZS5lbmNhcFtpXS5p
ZCk7CgoKCj4+ICsJCQlicmVhazsKCgoKPj4gKwkJfQoKCgo+PiArCX0KCgoKPj4gK30KCgoKPgoK
Cgo+SWYgSSB1bmRlcnN0YW5kIGNvcnJlY3RseSwgdGhlIGdvYWwgb2YgdGhpcyBwYXRjaHNldCBp
cyB0byBtb3ZlIHRoZQoKCgo+ZXhpc3RpbmcgdmxhbiBhbmQgcHBwIHN1cHBvcnQgdG8gdXNlIHRo
ZSBYTUlUX0RJUkVDVCBwYXRoPwoKCgo+CgoKCj5TbyB0aGlzIGFscmVhZHkgd29ya3MgYnV0IHlv
dSB3b3VsZCBwcmVmZXIgdG8gbm90IHVzZSBYTUlUX05FSUdIPwoKCgo+CgoKCj5UaGUgc2NlbmFy
aW9zIHlvdSBkZXNjcmliZSBhbHJlYWR5IHdvcmsgZmluZSB3aXRoIHRoZSBleGlzdGluZwoKCgo+
Y29kZWJhc2U/IEkgYW0gYXNzdW1pbmcgJ2V0aCcgcHJvdmlkZXMgSW50ZXJuZXQgYWNjZXNzPyBZ
b3UgcmVmZXIgdG8KCgoKPnRoaXMgaW4gdGhlIHBhdGNoIGRlc2NyaXB0aW9uOgoKVGhlIGV0aCBp
cyB0aGUgbG93ZXIgZGV2aWNlIG9mIHRoZSBicmlkZ2UuCiAgICAgICAgICAgICAgICAgICAgIHJv
dXRlcgogICAgICAgICAgICAgICAgIHwtLS0tLS0tLS0tLS18ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgCiAgIGV0aDAtLT5icjAgICAgICAgICAgICAgICBldGgtaW50ZXJuZXQKCldpdGhvdXQg
dGhpcyBwYXRjaCB0aGUgcGFja2V0IGNvbWUgZnJvbSBldGgtaW50ZXJuZXQgd2lsbAphbHdheXMg
c2VuZCB0aHJvdWdoIHRoZSByb3V0ZXIgaW50ZXJmYWNlIGJyMCB3aXRoIFhNSVRfTkVJR0guCgpX
aXRoIHRoaXMgcGF0Y2ggdGhlIHBhY2tldCBjb21lIGZyb20gZXRoLWludGVybmV0IHdpbGwgc2Vu
ZCB0aHJvdWdoCmV0aDAgZGlyZWN0bHkgd2l0aCBYTUlUX0RJUkVDVCh3aXRoIHZsYW4gdGFnIGlm
IG5lZWQpLiAKU28gaXQgY2FuIHRvdGFsbHkgYnlwYXNzIHRoZSBicmlkZ2UgcHJvY2VzcyBmb3Ig
aW5ncmVzcyBwYWNrZXQuCgoKPgoKCgo+IGJyMC4xMDAtLT5icjAodmxhbiBmaWx0ZXIgZW5hYmxl
KS0tPmV0aAoKCgo+IGJyMCh2bGFuIGZpbHRlciBlbmFibGUpLS0+ZXRoCgoKCj4gYnIwKHZsYW4g
ZmlsdGVyIGRpc2FibGUpLS0+ZXRoLjEwMC0tPmV0aAoKCgo+CgoK

