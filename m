From: Ilguiz Latypov <ilguiz@nit.ca>
Subject: Re: PPTP connection tracking
Date: Mon, 2 Dec 2002 22:02:50 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212022159080.16692-200000@localhost.localdomain>
References: <Pine.LNX.4.44.0212022036040.16274-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1179364329-1038884570=:16692"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: philipc@snapgear.com
In-Reply-To: <Pine.LNX.4.44.0212022036040.16274-100000@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--8323328-1179364329-1038884570=:16692
Content-Type: TEXT/PLAIN; charset=US-ASCII


I changed pptpctrl.c to issue pseudo-unique Call ID's for every incoming
TCP connection.  Each connection spawns a process.

Is this modification reasonable?  I will submit it to pptpd maintainer as
well.

--
Ilguiz Latypov
Net Integration Technologies, Inc

tel. +1 (514) 281 9191 x 117

On Mon, 2 Dec 2002, Ilguiz Latypov wrote:

> The error message is produced by the run time error in encaps_gre() where
> the write() function is called to send a GRE packet.  I wonder if that
> issue is related to the one you mentioned in the bottom of your message.


--8323328-1179364329-1038884570=:16692
Content-Type: TEXT/plain; name="pptpd.txt"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0212022202500.16692@localhost.localdomain>
Content-Description: 
Content-Disposition: attachment; filename="pptpd.txt"

SW5kZXg6IGN0cmxwYWNrZXQuYw0KPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
UkNTIGZpbGU6IC9ob21lL2N2cy93dnBhY2thZ2VzL3BwdHBkL2N0cmxwYWNr
ZXQuYyx2DQpyZXRyaWV2aW5nIHJldmlzaW9uIDEuMS4xLjINCmRpZmYgLXUg
LXIxLjEuMS4yIGN0cmxwYWNrZXQuYw0KLS0tIGN0cmxwYWNrZXQuYwk0IEp1
biAyMDAxIDE4OjA5OjM0IC0wMDAwCTEuMS4xLjINCisrKyBjdHJscGFja2V0
LmMJMjkgTm92IDIwMDIgMjI6MzE6NDEgLTAwMDANCkBAIC0yNSw2ICsyNSw4
IEBADQogI2luY2x1ZGUgPHVuaXN0ZC5oPg0KICNpbmNsdWRlIDxzdHJpbmcu
aD4NCiAjaW5jbHVkZSA8ZXJybm8uaD4NCisjaW5jbHVkZSA8c3lzL3RpbWUu
aD4NCisjaW5jbHVkZSA8dGltZS5oPg0KIA0KICNpbmNsdWRlICJwcHRwZGVm
cy5oIg0KICNpbmNsdWRlICJwcHRwY3RybC5oIg0KQEAgLTYzMCw2ICs2MzIs
MTggQEANCiB1X2ludDE2X3QgZ2V0Y2FsbCgpDQogew0KIAlzdGF0aWMgdV9p
bnQxNl90IGkgPSAwOw0KKw0KKwkvKiBTdGFydCB3aXRoIGEgcmFuZG9tIENh
bGwgSUQuICBUaGlzIGlzIHRvIGFsbG9jYXRlIHVuaXF1ZSBDYWxsIElEJ3Mg
DQorCSAqIGFjcm9zcyBtdWx0aXBsZSBUQ1AgUFBUUCBjb25uZWN0aW9ucy4g
IEluIHRoaXMgd2F5IHJlbW90ZSBjbGllbnRzIA0KKwkgKiBtYXNxdWVyYWRl
ZCBieSBhIGZpcmV3YWxsIHdpbGwgcHV0IHVuaXF1ZSBwZWVyIGNhbGwgSUQn
cyBpbnRvDQorCSAqIEdSRSBwYWNrZXRzIHRoYXQgd2lsbCBoYXZlIHRoZSBz
YW1lIHNvdXJjZSBJUCBhZGRyZXNzIG9mIHRoZSANCisJICogZmlyZXdhbGwu
ICovDQorCWlmICghaSkgew0KKwkJc3RydWN0IHRpbWV2YWwgdHY7DQorCQlp
ZiAoZ2V0dGltZW9mZGF5KCZ0diwgTlVMTCkgPT0gMCkgew0KKwkJCWkgPSAo
KHR2LnR2X3NlYyAmIDB4MEZGRikgPDwgNCkgKyAodHYudHZfdXNlYyA+PiAx
Nik7DQorCQl9DQorCX0NCiANCiAJaWYoIV9wYWNfaW5pdCkgew0KIAkJX3Bh
Y19jYWxsX2lkID0gaHRvbnMoLTEpOw0K
--8323328-1179364329-1038884570=:16692--
