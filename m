From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] Passive OS fingerprint matching module update. Dynamic
 fingerprint loading.
Date: Mon, 22 Sep 2003 17:32:31 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030922173231.5bd6a7ae.johnpol@2ka.mipt.ru>
References: <20030922171921.009b2133.johnpol@2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Mon__22_Sep_2003_17:32:31_+0400_082aa610"
Cc: netfilter-devel@lists.netfilter.org, laforge@netfilter.org,
   quaker@ondraszek.eu.org, solt@dns.toxicfilms.tv
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20030922171921.009b2133.johnpol@2ka.mipt.ru>
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

--Multipart_Mon__22_Sep_2003_17:32:31_+0400_082aa610
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

> 
> All rules are added to linked list(with proper locking) without any
> check, if this rule already exists.

Attached patch fixes some locking problem when flushing rules.
Please apply on top of previous.
 
> 
> Any feedback is allways appreciated.
> 

Yep.

	Evgeniy Polyakov

--Multipart_Mon__22_Sep_2003_17:32:31_+0400_082aa610
Content-Type: application/octet-stream;
 name="osf.diff"
Content-Disposition: attachment;
 filename="osf.diff"
Content-Transfer-Encoding: base64

SW5kZXg6IGlwdF9vc2YuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09ClJDUyBmaWxlOiAvdXNyL2xvY2FsL2N2c3Jvb3Qv
b3NmL2lwdF9vc2YuYyx2CnJldHJpZXZpbmcgcmV2aXNpb24gMS4yCmRpZmYgLXUgLXIxLjIgaXB0
X29zZi5jCi0tLSBpcHRfb3NmLmMJMjIgU2VwIDIwMDMgMTM6Mjk6NTAgLTAwMDAJMS4yCisrKyBp
cHRfb3NmLmMJMjIgU2VwIDIwMDMgMTM6MzA6MzAgLTAwMDAKQEAgLTQ4Niw2ICs0ODYsNyBAQAog
CWlmIChjb3VudCA9PSBzdHJsZW4oT1NGRkxVU0gpICYmICFzdHJuY21wKGJ1ZmZlciwgT1NGRkxV
U0gsIHN0cmxlbihPU0ZGTFVTSCkpKQogCXsKIAkJaW50IGkgPSAwOworCQl3cml0ZV9sb2NrX2Jo
KCZvc2ZfbG9jayk7CiAJCWxpc3RfZm9yX2VhY2hfc2FmZShlbnQsIG4sICZmaW5nZXJfbGlzdCkK
IAkJewogCQkJaSsrOwpAQCAtNDkzLDYgKzQ5NCw3IEBACiAJCQlsaXN0X2RlbCgmZmluZ2VyLT5m
bGlzdCk7CiAJCQlmaW5nZXJfZnJlZShmaW5nZXIpOwogCQl9CisJCXdyaXRlX3VubG9ja19iaCgm
b3NmX2xvY2spOwogCQogCQlsb2coIkZsdXNoZWQgJWQgZW50cmllcy5cbiIsIGkpOwogCQkK

--Multipart_Mon__22_Sep_2003_17:32:31_+0400_082aa610--
