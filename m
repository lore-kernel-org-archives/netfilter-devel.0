From: Henrik Nordstrom <hno@marasystems.com>
Subject: [patch] pom-ng version check confusion
Date: Fri, 27 Feb 2004 10:21:25 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402271011310.21531-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1494554675-1077873685=:21531"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

---1463811839-1494554675-1077873685=:21531
Content-Type: TEXT/PLAIN; charset=US-ASCII

The pom-ng version check failed if the difference was not in the last 
version number, i.e. 2.4.25 < 2.6.0 test failed.

The attached patch simplifies the version check so it works 
somewhat better.

There is still room for improvement. The returned weight is not sufficient
for determining the best match if there is multiple subversions. Should be
acceptable if the weight is multiplied by a factor 1000 of the version
depth I think.

Regards
Henrik

---1463811839-1494554675-1077873685=:21531
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="pomng-versioncheck.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0402271021250.21531@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename="pomng-versioncheck.patch"

LS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNDAyMjYvTmV0ZmlsdGVyX1BPTS5w
bQlTdW4gRmViIDIyIDIzOjAwOjA0IDIwMDQNCisrKyBwYXRjaC1vLW1hdGlj
LW5nL05ldGZpbHRlcl9QT00ucG0JRnJpIEZlYiAyNyAxMDowMjozMiAyMDA0
DQpAQCAtMTQ5LDE2ICsxNDksMTAgQEANCiAJZm9yZWFjaCAkdmVyICgwLi4k
bWluKSB7DQogCQluZXh0IGlmICR2ZXIxWyR2ZXJdID09ICR2ZXIyWyR2ZXJd
Ow0KIAkJZXZhbCAiXCRyZXMgPSAkdmVyMVskdmVyXSAkb3AgJHZlcjJbJHZl
cl0iOw0KLQkJaWYgKCEkcmVzKSB7DQotCQkJcmV0dXJuICRyZXM7DQotCQl9
DQorCQlyZXR1cm4gKCRyZXMgPyAoJHZlcisyKSA6IDApOw0KIAl9DQotCWlm
ICgkdmVyMVskbWluXSA9PSAkdmVyMlskbWluXSkgew0KLQkJZXZhbCAiXCRy
ZXMgPSAkdmVyMVskbWluXSAkb3AgJHZlcjJbJG1pbl0iOw0KLQl9IGVsc2Ug
ew0KLQkJJHJlcyA9IDE7DQotCX0NCi0JcmV0dXJuICgkcmVzID8gKCRtaW4r
MikgOiAwKTsNCisJZXZhbCAiXCRyZXMgPSAkdmVyMVskbWluXSAkb3AgJHZl
cjJbJG1pbl0iOw0KKwlyZXR1cm4gKCAkcmVzID8gKCRtaW4rMikgOiAwKTsN
CiB9DQogDQogIyBkbyB3ZSBoYXZlIEtjb25maWcgLyBDb25maWcuaW4gYXBw
bGljYWJsZSBmb3Iga2VybmVsID8NCg==
---1463811839-1494554675-1077873685=:21531--
