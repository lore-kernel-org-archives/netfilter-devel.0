From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: Fix ip_conntrack_core arguments to macros
Date: Sat, 12 Jul 2003 12:40:47 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0307121230550.30873-200000@gw.localnet>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811840-44299512-1058006447=:30873"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
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

---1463811840-44299512-1058006447=:30873
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Harald,
this patch fixes some places in ip_conntrack where LIST_FIND and
LIST_DELETE are passed functions with their arguments (like
LIST_FIND(ip_conntrack_hash[hash_conntrack(...)], ...). The argument is
expanded twice, this leads to two calls to hash_conntrack.

Dump of assembler code for function __ip_conntrack_find:
0x000004c0 <__ip_conntrack_find+0>:     push   %ebp
0x000004c1 <__ip_conntrack_find+1>:     mov    %esp,%ebp
0x000004c3 <__ip_conntrack_find+3>:     push   %edi
0x000004c4 <__ip_conntrack_find+4>:     push   %esi
0x000004c5 <__ip_conntrack_find+5>:     mov    0xc(%ebp),%edi
0x000004c8 <__ip_conntrack_find+8>:     mov    0x8(%ebp),%esi
0x000004cb <__ip_conntrack_find+11>:    push   %ebx
0x000004cc <__ip_conntrack_find+12>:    push   %esi
0x000004cd <__ip_conntrack_find+13>:    call   0x80 <hash_conntrack>
0x000004d2 <__ip_conntrack_find+18>:    mov    0x0,%edx
0x000004d8 <__ip_conntrack_find+24>:    pop    %ecx
0x000004d9 <__ip_conntrack_find+25>:    lea    (%edx,%eax,8),%ebx
0x000004dc <__ip_conntrack_find+28>:    lea    0x0(%esi,1),%esi
0x000004e0 <__ip_conntrack_find+32>:    mov    (%ebx),%ebx
0x000004e2 <__ip_conntrack_find+34>:    push   %esi
0x000004e3 <__ip_conntrack_find+35>:    call   0x80 <hash_conntrack>
...

Best regards,
Patrick


BTW: nice talk yesterday, i've seen the slides before but it still was
alot more interesting to here it directly from you. Sorry i didn't showed
up anymore, i had to get some sleep fast after getting up at 7 in the
morning (and drinking too much beer) ;) Are you still at linuxtag ?

---1463811840-44299512-1058006447=:30873
Content-Type: TEXT/plain; name="linux-2.4.21-ip_conntrack-macro-args.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0307121240470.30873@gw.localnet>
Content-Description: 
Content-Disposition: attachment; filename="linux-2.4.21-ip_conntrack-macro-args.diff"

IyBUaGlzIGlzIGEgQml0S2VlcGVyIGdlbmVyYXRlZCBwYXRjaCBmb3IgdGhl
IGZvbGxvd2luZyBwcm9qZWN0Og0KIyBQcm9qZWN0IE5hbWU6IExpbnV4IGtl
cm5lbCB0cmVlDQojIFRoaXMgcGF0Y2ggZm9ybWF0IGlzIGludGVuZGVkIGZv
ciBHTlUgcGF0Y2ggY29tbWFuZCB2ZXJzaW9uIDIuNSBvciBoaWdoZXIuDQoj
IFRoaXMgcGF0Y2ggaW5jbHVkZXMgdGhlIGZvbGxvd2luZyBkZWx0YXM6DQoj
CSAgICAgICAgICAgQ2hhbmdlU2V0CTEuMTIxMSAgLT4gMS4xMjEyIA0KIwlu
ZXQvaXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRyYWNrX2NvcmUuYwkxLjE5ICAg
IC0+IDEuMjAgICANCiMNCiMgVGhlIGZvbGxvd2luZyBpcyB0aGUgQml0S2Vl
cGVyIENoYW5nZVNldCBMb2cNCiMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCiMgMDMvMDcvMTIJa2FiZXJAdHJhc2gu
bmV0CQkxLjEyMTINCiMgW05FVEZJTFRFUl06IERvbid0IHVzZSBoYXNoX2Nv
bm50cmFjayBpbiBtYWNyb3MuDQojIA0KIyBEaXNhc3NlbWJseSBvZiBfX2lw
X2Nvbm50cmFja19maW5kIHNob3dzIGhhc2hfY29ubnRyYWNrIGlzIGNhbGxl
ZCB0d2ljZQ0KIyBiZWNhdXNlIHRoZSBwYXJhbWV0ZXIgdG8gTElTVF9GSU5E
IGlzIGV2YWx1YXRlZCB0d2ljZS4gU2FtZSBnb2VzIGZvcg0KIyBMSVNUX0RF
TEVURSB3aGVuIENPTkZJR19ORVRGSUxURVJfREVCVUcgaXMgZGVmaW5lZC4N
CiMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0NCiMNCmRpZmYgLU5ydSBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25u
dHJhY2tfY29yZS5jIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFj
a19jb3JlLmMNCi0tLSBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJh
Y2tfY29yZS5jCVNhdCBKdWwgMTIgMDQ6NTY6NTYgMjAwMw0KKysrIGIvbmV0
L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19jb3JlLmMJU2F0IEp1bCAx
MiAwNDo1Njo1NiAyMDAzDQpAQCAtMjkwLDE0ICsyOTAsMTUgQEANCiBzdGF0
aWMgdm9pZA0KIGNsZWFuX2Zyb21fbGlzdHMoc3RydWN0IGlwX2Nvbm50cmFj
ayAqY3QpDQogew0KKwl1bnNpZ25lZCBpbnQgaG8sIGhyOw0KKwkNCiAJREVC
VUdQKCJjbGVhbl9mcm9tX2xpc3RzKCVwKVxuIiwgY3QpOw0KIAlNVVNUX0JF
X1dSSVRFX0xPQ0tFRCgmaXBfY29ubnRyYWNrX2xvY2spOw0KLQlMSVNUX0RF
TEVURSgmaXBfY29ubnRyYWNrX2hhc2gNCi0JCSAgICBbaGFzaF9jb25udHJh
Y2soJmN0LT50dXBsZWhhc2hbSVBfQ1RfRElSX09SSUdJTkFMXS50dXBsZSld
LA0KLQkJICAgICZjdC0+dHVwbGVoYXNoW0lQX0NUX0RJUl9PUklHSU5BTF0p
Ow0KLQlMSVNUX0RFTEVURSgmaXBfY29ubnRyYWNrX2hhc2gNCi0JCSAgICBb
aGFzaF9jb25udHJhY2soJmN0LT50dXBsZWhhc2hbSVBfQ1RfRElSX1JFUExZ
XS50dXBsZSldLA0KLQkJICAgICZjdC0+dHVwbGVoYXNoW0lQX0NUX0RJUl9S
RVBMWV0pOw0KKw0KKwlobyA9IGhhc2hfY29ubnRyYWNrKCZjdC0+dHVwbGVo
YXNoW0lQX0NUX0RJUl9PUklHSU5BTF0udHVwbGUpOw0KKwlociA9IGhhc2hf
Y29ubnRyYWNrKCZjdC0+dHVwbGVoYXNoW0lQX0NUX0RJUl9SRVBMWV0udHVw
bGUpOw0KKwlMSVNUX0RFTEVURSgmaXBfY29ubnRyYWNrX2hhc2hbaG9dLCAm
Y3QtPnR1cGxlaGFzaFtJUF9DVF9ESVJfT1JJR0lOQUxdKTsNCisJTElTVF9E
RUxFVEUoJmlwX2Nvbm50cmFja19oYXNoW2hyXSwgJmN0LT50dXBsZWhhc2hb
SVBfQ1RfRElSX1JFUExZXSk7DQogDQogCS8qIERlc3Ryb3kgYWxsIHVuLWVz
dGFibGlzaGVkLCBwZW5kaW5nIGV4cGVjdGF0aW9ucyAqLw0KIAlyZW1vdmVf
ZXhwZWN0YXRpb25zKGN0KTsNCkBAIC0zNjksOSArMzcwLDEwIEBADQogCQkg
ICAgY29uc3Qgc3RydWN0IGlwX2Nvbm50cmFjayAqaWdub3JlZF9jb25udHJh
Y2spDQogew0KIAlzdHJ1Y3QgaXBfY29ubnRyYWNrX3R1cGxlX2hhc2ggKmg7
DQorCXVuc2lnbmVkIGludCBoYXNoID0gaGFzaF9jb25udHJhY2sodHVwbGUp
Ow0KIA0KIAlNVVNUX0JFX1JFQURfTE9DS0VEKCZpcF9jb25udHJhY2tfbG9j
ayk7DQotCWggPSBMSVNUX0ZJTkQoJmlwX2Nvbm50cmFja19oYXNoW2hhc2hf
Y29ubnRyYWNrKHR1cGxlKV0sDQorCWggPSBMSVNUX0ZJTkQoJmlwX2Nvbm50
cmFja19oYXNoW2hhc2hdLA0KIAkJICAgICAgY29ubnRyYWNrX3R1cGxlX2Nt
cCwNCiAJCSAgICAgIHN0cnVjdCBpcF9jb25udHJhY2tfdHVwbGVfaGFzaCAq
LA0KIAkJICAgICAgdHVwbGUsIGlnbm9yZWRfY29ubnRyYWNrKTsNCg==
---1463811840-44299512-1058006447=:30873--
