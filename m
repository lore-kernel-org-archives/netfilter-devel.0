From: Alexander Pazdnikov <sasha@cnit.ustu.ru>
Subject: Patch for libiptc
Date: Mon, 25 Nov 2002 09:23:17 +0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211250422.gAP4Mu4F016168@garrick.ustu.ru>
Reply-To: sasha@cnit.ustu.ru
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_TU64T4IF0KP3KE5T3HEN"
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


--------------Boundary-00=_TU64T4IF0KP3KE5T3HEN
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8bit

	Hello.
  Patch for function is_same() in libiptc4.c (in libiptc6.c all ok)

Best Wishes
Alexander Pazdnikov


--------------Boundary-00=_TU64T4IF0KP3KE5T3HEN
Content-Type: text/x-diff;
  charset="koi8-r";
  name="libiptc4.c.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="libiptc4.c.patch"

KioqIC91c3Ivc3JjL3JlZGhhdC9CVUlMRC9pcHRhYmxlcy0xLjIuNS9saWJpcHRjL2xpYmlwNHRj
LmMJRnJpIEphbiAgNSAyMDoyMjo1OSAyMDAxCi0tLSAvdXNyL3NyYy9yZWRoYXQvQlVJTEQvUEFU
Q0hFRC9pcHRhYmxlcy0xLjIuNS9saWJpcHRjL2xpYmlwNHRjLmMJV2VkIE5vdiAyMCAyMTozMzoz
MCAyMDAyCioqKioqKioqKioqKioqKiBpc19zYW1lKGNvbnN0IFNUUlVDVF9FTlRSWSAqYSwgY29u
c3QgU1RSCioqKiAxOTEsMjAxICoqKioKICAKICAJLyogQWx3YXlzIGNvbXBhcmUgaGVhZCBzdHJ1
Y3R1cmVzOiBpZ25vcmUgbWFzayBoZXJlLiAqLwogIAlpZiAoYS0+aXAuc3JjLnNfYWRkciAhPSBi
LT5pcC5zcmMuc19hZGRyCiAgCSAgICB8fCBhLT5pcC5kc3Quc19hZGRyICE9IGItPmlwLmRzdC5z
X2FkZHIKICAJICAgIHx8IGEtPmlwLnNtc2suc19hZGRyICE9IGItPmlwLnNtc2suc19hZGRyCi0g
CSAgICB8fCBhLT5pcC5zbXNrLnNfYWRkciAhPSBiLT5pcC5zbXNrLnNfYWRkcgogIAkgICAgfHwg
YS0+aXAucHJvdG8gIT0gYi0+aXAucHJvdG8KICAJICAgIHx8IGEtPmlwLmZsYWdzICE9IGItPmlw
LmZsYWdzCiAgCSAgICB8fCBhLT5pcC5pbnZmbGFncyAhPSBiLT5pcC5pbnZmbGFncykKICAJCXJl
dHVybiAwOwogIAotLS0gMTkxLDIwMSAtLS0tCiAgCiAgCS8qIEFsd2F5cyBjb21wYXJlIGhlYWQg
c3RydWN0dXJlczogaWdub3JlIG1hc2sgaGVyZS4gKi8KICAJaWYgKGEtPmlwLnNyYy5zX2FkZHIg
IT0gYi0+aXAuc3JjLnNfYWRkcgogIAkgICAgfHwgYS0+aXAuZHN0LnNfYWRkciAhPSBiLT5pcC5k
c3Quc19hZGRyCiAgCSAgICB8fCBhLT5pcC5zbXNrLnNfYWRkciAhPSBiLT5pcC5zbXNrLnNfYWRk
cgorIAkgICAgfHwgYS0+aXAuZG1zay5zX2FkZHIgIT0gYi0+aXAuZG1zay5zX2FkZHIKICAJICAg
IHx8IGEtPmlwLnByb3RvICE9IGItPmlwLnByb3RvCiAgCSAgICB8fCBhLT5pcC5mbGFncyAhPSBi
LT5pcC5mbGFncwogIAkgICAgfHwgYS0+aXAuaW52ZmxhZ3MgIT0gYi0+aXAuaW52ZmxhZ3MpCiAg
CQlyZXR1cm4gMDsKICAK

--------------Boundary-00=_TU64T4IF0KP3KE5T3HEN--
