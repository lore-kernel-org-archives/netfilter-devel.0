From: "Allain Yoann" <Yoann.Allain@thomson.net>
Subject: [PATCH] IPSec decrypted transport mode packets goes through LOCAL_IN
Date: Wed, 4 May 2005 11:07:02 +0200
Message-ID: <9C1918067C3BC14C9C351C206D8A843737301D@rennsmail03.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C55088.A299A942"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.

------_=_NextPart_001_01C55088.A299A942
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Hi all,

Since I didn't get any responses from last week messages, I've done a
bit of hacking in the kernel in order to make transport mode decrypted
packets go through the NF_IP_LOCAL_IN hook after decryption.

This permits to do some filtering upon plain text packets to prevent
privileged users to extend their privileges to others services than
those wanted by the server:


+--------------+
+-----------+
|		   |						|
|
|    server	   |						|
client	|
|		   |	IPSec channel only for ftp	|
|
|   ftp    =
<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> telnet	|
|		 | |		transport mode		|
|
|   telnet <-+ |						|
|
+--------------+
+-----------+


In this example, a client can attack the telnet server (DOS type attack)
by using the IPSec SA established for FTP.

With the patch, I've attached in this mail, the packets that got
decrypted go through the INPUT hook again and, this way, can filtered in
order to prevent this issue.

The patch is very simple, and I'm actually testing it. But I think there
are some issues with it since it seems no one proposed an equivalent
before.=20
Can anyone tell me the problem(s) it could generate...?=20

Thanks in advance for your responseS ;)

Yoann


------_=_NextPart_001_01C55088.A299A942
Content-Type: application/octet-stream;
	name="patch-2.6.11.4-ipsec-transport-nf_hook-again"
Content-Transfer-Encoding: base64
Content-Description: patch-2.6.11.4-ipsec-transport-nf_hook-again
Content-Disposition: attachment;
	filename="patch-2.6.11.4-ipsec-transport-nf_hook-again"

ZGlmZiAtdXJOIGxpbnV4LTIuNi4xMS40Lm9yaWcvbmV0L2lwdjQveGZybTRfaW5wdXQuYyBsaW51
eC0yLjYuMTEuNC5uZXcvbmV0L2lwdjQveGZybTRfaW5wdXQuYwotLS0gbGludXgtMi42LjExLjQu
b3JpZy9uZXQvaXB2NC94ZnJtNF9pbnB1dC5jCTIwMDUtMDMtMTUgMTk6MDk6MDAuMDAwMDAwMDAw
IC0wNTAwCisrKyBsaW51eC0yLjYuMTEuNC5uZXcvbmV0L2lwdjQveGZybTRfaW5wdXQuYwkyMDA1
LTA1LTAzIDA5OjA5OjI3LjE4MDAwMDAwMCAtMDQwMApAQCAtMTQsNiArMTQsNyBAQAogI2luY2x1
ZGUgPG5ldC9pbmV0X2Vjbi5oPgogI2luY2x1ZGUgPG5ldC9pcC5oPgogI2luY2x1ZGUgPG5ldC94
ZnJtLmg+CisjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjQuaD4KIAogaW50IHhmcm00X3Jj
dihzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogewpAQCAtNDUsNiArNDYsMTQgQEAKIAlyZXR1cm4geGZy
bV9wYXJzZV9zcGkoc2tiLCBuZXh0aGRyLCBzcGksIHNlcSk7CiB9CiAKK3N0YXRpYyBpbmxpbmUg
aW50ICB4ZnJtNF9yY3ZfZW5jYXBfZmluaXNoKHN0cnVjdCBza19idWZmICpza2IpeworICAgICAg
ICBpbnQgaWhsID0gc2tiLT5uaC5pcGgtPmlobCo0OworICAKKwlfX3NrYl9wdWxsKHNrYiwgaWhs
KTsgLyogcHVsbCBiYWNrICovCisJLyogcmV0dXJuIHRvIG5vcm1hbCBmbG93ICovCisJcmV0dXJu
IC1za2ItPm5oLmlwaC0+cHJvdG9jb2w7Cit9CisKIGludCB4ZnJtNF9yY3ZfZW5jYXAoc3RydWN0
IHNrX2J1ZmYgKnNrYiwgX191MTYgZW5jYXBfdHlwZSkKIHsKIAlpbnQgZXJyOwpAQCAtMTQ1LDcg
KzE1NCwxMCBAQAogCQluZXRpZl9yeChza2IpOwogCQlyZXR1cm4gMDsKIAl9IGVsc2UgewotCQly
ZXR1cm4gLXNrYi0+bmguaXBoLT5wcm90b2NvbDsKKwkgICAgICAgIC8qIGNhbGwgYmFjayB0aGUg
aG9vayB0byBpbnNwZWN0IHRoZSBwYWNrZXQgYWdhaW4gKi8KKwkgICAgICAgIF9fc2tiX3B1c2go
c2tiLCBpaGwpOyAvKiBwdXNoIGJhY2sgKi8KKwkJcmV0dXJuIE5GX0hPT0soUEZfSU5FVCwgTkZf
SVBfTE9DQUxfSU4sIHNrYiwgc2tiLT5kZXYsIE5VTEwsCisJCQkgICAgICAgeGZybTRfcmN2X2Vu
Y2FwX2ZpbmlzaCk7CiAJfQogCiBkcm9wX3VubG9jazoK

------_=_NextPart_001_01C55088.A299A942--
