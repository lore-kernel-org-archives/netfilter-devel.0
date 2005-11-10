From: Vlad Drukker <vlad@storewiz.com>
Subject: [PATCH] ip_conntrack_proto_tcp
Date: Thu, 10 Nov 2005 17:48:50 +0200
Message-ID: <1131637730.14044.12.camel@quant>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-rw0q9dhhzxScsnvmFjY8"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: coreteam@netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-rw0q9dhhzxScsnvmFjY8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi there,

Attached patch for ip_conntrack to account TCP sessions started with SYN
+PUSH flags. Looks weird, but some HW vendors do TCP their own way. 

Let's earn some points from RFC 1025.

Cheers,
Vlad.

--=-rw0q9dhhzxScsnvmFjY8
Content-Disposition: attachment; filename=SYN_PUSH.patch
Content-Type: text/x-patch; name=SYN_PUSH.patch; charset=us-ascii
Content-Transfer-Encoding: base64

W05FVEZJTFRFUl0gaXBfY29ubnRyYWNrIFNZTiBQVVNIIHBhdGNoDQoJDQpTb21lIFFsb2dpYyBp
U0NTSSBIQkEgaGFyZHdhcmUgbGlrZSBRTEE0MDEwIHVwIHRvIGZpcm13YXJlIDMuMC4wLjQNCmlu
aXRpYXRlcyBUQ1Agd2l0aCBTWU4gYW5kIFBVU0ggZmxhZ3Mgc2V0Lg0KTGludXggVENQL0lQIHN0
YWNrIHdvcmtzIGZpbmUgd2l0aCB0aGF0Lg0KTWFrZSBpcF9jb25udHJhY2sgZG8gdGhlIHNhbWUu
DQoNClNpZ25lZC1vZmYtYnk6IFZsYWQgRHJ1a2tlciA8dmxhZEBzdG9yZXdpei5jb20+DQotLS0N
CmNvbW1pdCBjMDJkZDU1MTgzZTVmODMzMGRhOTZmYjgyMjkxYTc2NDkyYjZlN2M0DQp0cmVlIDBh
Y2E2YjM4MzZlZWY5N2JmYzU1MmVkMDA4ODNjZThmNzNjM2U1ZjkNCnBhcmVudCA0MDdjZjkyOGUx
OWQ4Y2Q4YmI5MTE2MGRhNmZkN2E5MDBiMWU0NzA1DQphdXRob3IgPHZsYWRAc3RvcmV3aXouY29t
PiBUaHUsIDEwIE5vdiAyMDA1IDE3OjA3OjI1ICswMjAwDQpjb21taXR0ZXIgPHZsYWRAc3RvcmV3
aXouY29tPiBUaHUsIDEwIE5vdiAyMDA1IDE3OjA3OjI1ICswMjAwDQoNCiBuZXQvaXB2NC9uZXRm
aWx0ZXIvaXBfY29ubnRyYWNrX3Byb3RvX3RjcC5jIHwgICAgMSArDQogMSBmaWxlcyBjaGFuZ2Vk
LCAxIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvaXB2
NC9uZXRmaWx0ZXIvaXBfY29ubnRyYWNrX3Byb3RvX3RjcC5jIGIvbmV0L2lwdjQvbmV0ZmlsdGVy
L2lwX2Nvbm50cmFja19wcm90b190Y3AuYw0KLS0tIGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nv
bm50cmFja19wcm90b190Y3AuYw0KKysrIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFj
a19wcm90b190Y3AuYw0KQEAgLTgxMyw2ICs4MTMsNyBAQCBzdGF0aWMgdTggdGNwX3ZhbGlkX2Zs
YWdzWyhUSF9GSU58VEhfU1lODQogew0KIAlbVEhfU1lOXQkJCT0gMSwNCiAJW1RIX1NZTnxUSF9B
Q0tdCQkJPSAxLA0KKwlbVEhfU1lOfFRIX1BVU0hdCQk9IDEsDQogCVtUSF9TWU58VEhfQUNLfFRI
X1BVU0hdCQk9IDEsDQogCVtUSF9SU1RdCQkJPSAxLA0KIAlbVEhfUlNUfFRIX0FDS10JCQk9IDEs
DQo=


--=-rw0q9dhhzxScsnvmFjY8--
