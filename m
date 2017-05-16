From: "Gao Feng" <gfree.wind@vip.163.com>
Subject: Re:Re: [PATCH nf v2] ebtables: arpreply: Add the standard target
 sanity check
Date: Tue, 16 May 2017 17:53:51 +0800 (CST)
Message-ID: <3fccf479.15f41.15c10ad983a.Coremail.gfree.wind@vip.163.com>
References: <1494898218-97426-1-git-send-email-gfree.wind@vip.163.com>
 <20170516082400.GA11114@salvia> <20170516094324.GA18427@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64
Cc: stephen@networkplumber.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m173-177.vip.163.com ([123.58.177.173]:40120 "EHLO
        m173-177.vip.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdEPKAS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 06:00:18 -0400
In-Reply-To: <20170516094324.GA18427@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

CkF0IDIwMTctMDUtMTYgMTc6NDM6MjQsICJQYWJsbyBOZWlyYSBBeXVzbyIgPHBhYmxvQG5ldGZp
bHRlci5vcmc+IHdyb3RlOgo+T24gVHVlLCBNYXkgMTYsIDIwMTcgYXQgMTA6MjQ6MDBBTSArMDIw
MCwgUGFibG8gTmVpcmEgQXl1c28gd3JvdGU6Cj4+IE9uIFR1ZSwgTWF5IDE2LCAyMDE3IGF0IDA5
OjMwOjE4QU0gKzA4MDAsIGdmcmVlLndpbmRAdmlwLjE2My5jb20gd3JvdGU6Cj4+ID4gRnJvbTog
R2FvIEZlbmcgPGdmcmVlLndpbmRAdmlwLjE2My5jb20+Cj4+ID4gCj4+ID4gVGhlIGluZm8tPnRh
cmdldCBpcyBmcm9tIHVzZXJzcGFjZSBhbmQgaXQgd291bGQgYmUgdXNlZCBkaXJlY3RseS4KPj4g
PiBTbyB3ZSBuZWVkIHRvIGFkZCB0aGUgc2FuaXR5IGNoZWNrIHRvIG1ha2Ugc3VyZSBpdCBpcyBh
IHZhbGlkIHN0YW5kYXJkCj4+ID4gdGFyZ2V0LCBhbHRob3VnaCB0aGUgZWJ0YWJsZXMgdG9vbCBo
YXMgYWxyZWFkeSBjaGVja2VkIGl0LiBLZXJuZWwgbmVlZAo+PiA+IHRvIGNoZWNrIGFueXRoaW5n
IGZyb20gdXNlcnNwYWNlLgo+PiA+IAo+PiA+IElmIHRoZSB0YXJnZXQgd2FzIHNldCBhcyBhbiBl
dmlsIHZhbHVlLCBpdCB3b3VsZCBicmVhayB0aGUgZWJ0YWJsZXMKPj4gPiBhbmQgY2F1c2UgYSBw
YW5pYy4gQmVjYXVzZSB0aGUgbm9uLXN0YW5kYXJkIHRhcmdldCBpcyB0cmVhdGVkIGFzIG9uZQo+
PiA+IG9mZnNldC4KPj4gPiAKPj4gPiBOb3cgYWRkIG9uZSBoZWxwZXIgZnVuY3Rpb24gZWJ0X2lu
dmFsaWRfdGFyZ2V0LCBhbmQgd2Ugd291bGQgcmVwbGFjZQo+PiA+IHRoZSBtYWNybyBJTlZBTElE
X1RBUkdFVCBsYXRlci4KPj4gCj4+IEFwcGxpZWQsIHRoYW5rcy4KPj4gCj4+IFRoZXJlIGlzIGEg
ZmV3IGJ1bmNoIG9mIHNwb3RzIHRoYXQgY2FuIHVzZSB0aGlzIGluZGVlZC4gRm9sbG93IHVwIHdp
dGgKPj4gYSBwYXRjaCBmb3IgbmYtbmV4dCBvbmNlIG1lcmdlIHdpbmRvdyBvcGVucyB1cC4KCkkg
d291bGQgcGF5IHNvbWUgYXR0ZW50aW9uIHdoZW4gbmYgaXMgbWVyZ2VkIGludG8gbmYtbmV4dC4K
Cj4KPlBsZWFzZSwgdXNlOgo+Cj5uZXRmaWx0ZXI6IC4uLgo+Cj5hcyB5b3UgaW5pdGlhbCBwYXRj
aCBzdWJqZWN0IG5leHQgdGltZS4uLgoKT0suIEkgdGhvdWdodCB0aGUgZWJ0YWJsZXMgY29kZXMg
c2hvdWxkIHVzZSBwcmVmaXggImVidGFibGVzOiAiLCBhbmQgSSBjaGVja2VkIGl0IHdpdGggZ2l0
IGxvZy4KVGhlcmUgd2VyZSBzb21lIGNvbW1pdHMgd2hpY2ggdXNlcyAiZWJ0YWJsZXMiIGFzIHBy
ZWZpeC4KCkNvdWxkIEkgYXNzdW1lIGJvdGggb2YgZWJ0YWJsZXMgYW5kIGFycHRhYmxlcyB1c2Vz
IHRoZSBuZXRmaWx0ZXIgYXMgcHJlZml4PwoKUmVnYXJkcwpGZW5nCgoK
