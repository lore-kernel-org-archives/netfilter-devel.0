From: Maik Hentsche <netfilter@mm-double.de>
Subject: [PATCH] libnfnetlink
Date: Mon, 09 Oct 2006 17:07:50 +0200
Message-ID: <1160406470.452a65c62a14c@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="-MOQ1160406470f6dd2c2b67d0197e0a035d58f86ff139"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
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

This message is in MIME format.

---MOQ1160406470f6dd2c2b67d0197e0a035d58f86ff139
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hallo pablo, hello readers of the list,
attached is a patch, that corrects another error in the comments of
libnfnetlink. nfnl_send uses send_to and thus returns the number of
send bytes instead of 0 in case of success. Pardon me for bothering you
with such trivial patches, but I think, as long as the
sgml-documentation isn't finished (I'm working on it), developers using
the lib might need those comments.

so long
Maik


---MOQ1160406470f6dd2c2b67d0197e0a035d58f86ff139
Content-Type: text/x-patch; name="libnfnetlink_send_comment.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="libnfnetlink_send_comment.patch"

ZGlmZiAtVSAzIC1iIC1CIC1kIC1pIC1yIC1OIC14IC5zdm4gLS0gbGlibmZuZXRsaW5rLTAuMC4x
Ni1wYWJsby1yMS9zcmMvbGlibmZuZXRsaW5rLmMgbGlibmZuZXRsaW5rLTAuMC4xNi1wYWJsby1y
MS5uZXcvc3JjL2xpYm5mbmV0bGluay5jCi0tLSBsaWJuZm5ldGxpbmstMC4wLjE2LXBhYmxvLXIx
L3NyYy9saWJuZm5ldGxpbmsuYwkyMDA2LTEwLTA5IDE2OjU0OjMwLjAwMDAwMDAwMCArMDIwMAor
KysgbGlibmZuZXRsaW5rLTAuMC4xNi1wYWJsby1yMS5uZXcvc3JjL2xpYm5mbmV0bGluay5jCTIw
MDYtMTAtMDkgMTY6NTI6NDMuMDAwMDAwMDAwICswMjAwCkBAIC0zMzAsOCArMzMwLDggQEAKICAq
IEBuZm5saDogbmZuZXRsaW5rIGhhbmRsZXIKICAqIEBuOiBuZXRsaW5rIG1lc3NhZ2UKICAqCi0g
KiBPbiBzdWNjZXNzLCAwIGlzIHJldHVybmVkLiBPbiBlcnJvciwgLTEgaXMgcmV0dXJuZWQgYW5k
IGVycm5vIGlzIHNldAotICogYXBwcm9waWF0ZWx5LgorICogT24gc3VjY2VzcywgdGhlIG51bWJl
ciBvZiBzZW5kIGJ5dGVzIGlzIHJldHVybmVkLiBPbiBlcnJvciwgLTEgaXMKKyAqIHJldHVybmVk
IGFuZCBlcnJubyBpcyBzZXQgYXBwcm9waWF0ZWx5LgogICovCiBpbnQgbmZubF9zZW5kKHN0cnVj
dCBuZm5sX2hhbmRsZSAqbmZubGgsIHN0cnVjdCBubG1zZ2hkciAqbikKIHsK

---MOQ1160406470f6dd2c2b67d0197e0a035d58f86ff139--
