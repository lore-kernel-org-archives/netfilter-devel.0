From: "Martin Bene" <martin.bene@icomedias.com>
Subject: problem with iplimit - proposed solution
Date: Tue, 19 Nov 2002 14:18:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4D618F6493CE064A844A5D496733D6670314C0@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C28FCE.20683872"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C28FCE.20683872
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Nov 2002, Romp (romp@siil.net) wrote:
>> On Sat, 2 Nov 2002, Harald Welte wrote:
>>> =
http://lists.netfilter.org/pipermail/netfilter/2002-January/030405.html
>>
>> romp: does this patch fix your problem?
>>
>No difference. (2.4.20pre8 + patch-o-matic-20020825 + the-1-line-patch)
>I can still go over the limit by retransmiting the initial syn.

Doesn't really surprise me - the "gone" part certainly isn't the real
problem:

=3D=3D> Make 3rd connection, successfull
13:33:16 src=3D192.168.42.80:4268 dst=3D192.168.11.31:22 gone
13:33:16 src=3D192.168.42.80:4267 dst=3D192.168.11.31:22 established
13:33:16 src=3D192.168.42.80:4266 dst=3D192.168.11.31:22 established
13:33:16 src=3D192.168.42.80 mask=3D255.255.255.255 connections=3D2 =
limit=3D2
match=3Dno

When a connection goes through in spite of the iplimit rule, it's =
because the
iplimit code doesn't add the new connection - notice the missing "new" =
line
for the connect.=20

This happens when the new connection has the same source port as the
previously denied connection; having the identical src/spt - dst/dpt
combination both as an old (gone) and a new connection doesn't work.

Looking at ipt_iplimit.c it's pretty obvious what happens: if a =
connection is
found in the table, adding it as new is disabled, regardless of the =
state of
the found connection. The new connection mustn't be ignored unless it's =
in a
valid state in the table (neither gone nor TCP_CONNTRACK_TIME_WAIT =
state).

The attached patch fixes the problem for me. Warning: when touching =
kernel
source I definitely DON'T know what I'm doing.

Hope this helps someone,

Martin

------_=_NextPart_001_01C28FCE.20683872
Content-Type: application/octet-stream;
	name="iplimit.patch"
Content-Transfer-Encoding: base64
Content-Description: iplimit.patch
Content-Disposition: attachment;
	filename="iplimit.patch"

LS0tIGlwdF9pcGxpbWl0LmMub2xkCVR1ZSBOb3YgMTkgMTM6NTU6MDcgMjAwMgorKysgaXB0X2lw
bGltaXQuYwlUdWUgTm92IDE5IDE0OjAxOjQxIDIwMDIKQEAgLTY3LDEzICs2NywxNSBAQAogCS8q
IGNoZWNrIHRoZSBzYXZlZCBjb25uZWN0aW9ucyAqLwogCWZvciAobGggPSBoYXNoLT5uZXh0OyBs
aCAhPSBoYXNoOyBsaCA9IGxoLT5uZXh0KSB7CiAJCWNvbm4gPSBsaXN0X2VudHJ5KGxoLHN0cnVj
dCBpcHRfaXBsaW1pdF9jb25uLGxpc3QpOwotCQlpZiAoMCA9PSBtZW1jbXAoJmNvbm4tPnR1cGxl
LCZ0dXBsZSxzaXplb2YodHVwbGUpKSkgeworCQlmb3VuZCA9IGlwX2Nvbm50cmFja19maW5kX2dl
dCgmY29ubi0+dHVwbGUsY3QpOworCQlpZiAoMCA9PSBtZW1jbXAoJmNvbm4tPnR1cGxlLCZ0dXBs
ZSxzaXplb2YodHVwbGUpKSAmJiAKKyAgICAgICAgICAgICAgICAgICAgZm91bmQgIT0gTlVMTCAm
JgorCQkgICAgZm91bmQtPmN0cmFjay0+cHJvdG8udGNwLnN0YXRlICE9IFRDUF9DT05OVFJBQ0tf
VElNRV9XQUlUKSB7CiAJCQkvKiBKdXN0IHRvIGJlIHN1cmUgd2UgaGF2ZSBpdCBvbmx5IG9uY2Ug
aW4gdGhlIGxpc3QuCiAJCQkgICBXZSBzaG91bGQnbnQgc2VlIHR1cGxlcyB0d2ljZSB1bmxlc3Mg
c29tZW9uZSBob29rcyB0aGlzCiAJCQkgICBpbnRvIGEgdGFibGUgd2l0aG91dCAiLXAgdGNwIC0t
c3luIiAqLwogCQkJYWRkaXQgPSAwOwogCQl9Ci0JCWZvdW5kID0gaXBfY29ubnRyYWNrX2ZpbmRf
Z2V0KCZjb25uLT50dXBsZSxjdCk7CiAjaWYgREVCVUcKIAkJcHJpbnRrKCJpcHRfaXBsaW1pdCBb
JWRdOiBzcmM9JXUuJXUuJXUuJXU6JWQgZHN0PSV1LiV1LiV1LiV1OiVkICVzXG4iLAogCQkgICAg
ICAgaXB0X2lwaGFzaChhZGRyICYgbWFzayksCg==

------_=_NextPart_001_01C28FCE.20683872--
