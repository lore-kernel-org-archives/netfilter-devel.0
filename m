From: Michael Schwendt <mschwendt@yahoo.com>
Subject: Re: [PATCH] libipt_mac.c: minor bug and questions
Date: Mon, 9 Sep 2002 06:07:00 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020909130700.79853.qmail@web14602.mail.yahoo.com>
References: <638AA0336D7ED411928700D0B7B0D75B03053C7E@aimail.aiinet.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-2045304795-1031576820=:78090"
Cc: "Eble, Dan" <DanE@aiinet.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <638AA0336D7ED411928700D0B7B0D75B03053C7E@aimail.aiinet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-2045304795-1031576820=:78090
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

--- "Eble, Dan" <DanE@aiinet.com> wrote:
> Yesterday I began evaluating iptables for MAC and IP address ACLs.  It
> looks like it will work very well, but I think there is a bug at
> libipt_mac.c:121.
> It says printf("--mac ") instead of printf("--mac-source ").  Please
> forgive me if I am a clueless newbie, but this seem like a bad thing.

No, not a clueless newbie. It's well-spotted!

I consider such bugs in iptables-save as crucial, because some system
firewall solutions save/load their rules with the
iptables-save/iptables-restore tools. I found this yesterday night in
1.2.6a, too, when I had to block one host based on its MAC address, but
couldn't reach netfilter.org.

Attached is the trivial patch against 1.2.7a for both ipv4 and ipv6
mac-match extension.

Regards,
Michael

-- 




__________________________________________________
Do You Yahoo!?
Yahoo! Finance - Get real-time stock quotes
http://finance.yahoo.com
--0-2045304795-1031576820=:78090
Content-Type: application/octet-stream; name="iptables-1.2.7a-matchmac.patch"
Content-Transfer-Encoding: base64
Content-Description: iptables-1.2.7a-matchmac.patch
Content-Disposition: attachment; filename="iptables-1.2.7a-matchmac.patch"

W2J1Zy1maXhdIHByaW50IC0tbWFjLXNvdXJjZSBpbnN0ZWFkIG9mIC0tbWFj
CgpkaWZmIC1OYXVyIGlwdGFibGVzLTEuMi43YS1vcmlnL2V4dGVuc2lvbnMv
bGliaXA2dF9tYWMuYyBpcHRhYmxlcy0xLjIuN2EvZXh0ZW5zaW9ucy9saWJp
cDZ0X21hYy5jCi0tLSBpcHRhYmxlcy0xLjIuN2Etb3JpZy9leHRlbnNpb25z
L2xpYmlwNnRfbWFjLmMJV2VkIE1heSAyOSAxNTowODoxNiAyMDAyCisrKyBp
cHRhYmxlcy0xLjIuN2EvZXh0ZW5zaW9ucy9saWJpcDZ0X21hYy5jCVN1biBT
ZXAgIDggMjM6Mjc6MjIgMjAwMgpAQCAtMTE4LDcgKzExOCw3IEBACiAvKiBT
YXZlcyB0aGUgdW5pb24gaXA2dF9tYXRjaGluZm8gaW4gcGFyc2FibGUgZm9y
bSB0byBzdGRvdXQuICovCiBzdGF0aWMgdm9pZCBzYXZlKGNvbnN0IHN0cnVj
dCBpcDZ0X2lwNiAqaXAsIGNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5X21hdGNo
ICptYXRjaCkKIHsKLQlwcmludGYoIi0tbWFjICIpOworCXByaW50ZigiLS1t
YWMtc291cmNlICIpOwogCXByaW50X21hYygoKHN0cnVjdCBpcDZ0X21hY19p
bmZvICopbWF0Y2gtPmRhdGEpLT5zcmNhZGRyLAogCQkgICgoc3RydWN0IGlw
NnRfbWFjX2luZm8gKiltYXRjaC0+ZGF0YSktPmludmVydCk7CiB9CmRpZmYg
LU5hdXIgaXB0YWJsZXMtMS4yLjdhLW9yaWcvZXh0ZW5zaW9ucy9saWJpcHRf
bWFjLmMgaXB0YWJsZXMtMS4yLjdhL2V4dGVuc2lvbnMvbGliaXB0X21hYy5j
Ci0tLSBpcHRhYmxlcy0xLjIuN2Etb3JpZy9leHRlbnNpb25zL2xpYmlwdF9t
YWMuYwlXZWQgTWF5IDI5IDE1OjA4OjE2IDIwMDIKKysrIGlwdGFibGVzLTEu
Mi43YS9leHRlbnNpb25zL2xpYmlwdF9tYWMuYwlTdW4gU2VwICA4IDIzOjI3
OjQ3IDIwMDIKQEAgLTExOCw3ICsxMTgsNyBAQAogLyogU2F2ZXMgdGhlIHVu
aW9uIGlwdF9tYXRjaGluZm8gaW4gcGFyc2FibGUgZm9ybSB0byBzdGRvdXQu
ICovCiBzdGF0aWMgdm9pZCBzYXZlKGNvbnN0IHN0cnVjdCBpcHRfaXAgKmlw
LCBjb25zdCBzdHJ1Y3QgaXB0X2VudHJ5X21hdGNoICptYXRjaCkKIHsKLQlw
cmludGYoIi0tbWFjICIpOworCXByaW50ZigiLS1tYWMtc291cmNlICIpOwog
CXByaW50X21hYygoKHN0cnVjdCBpcHRfbWFjX2luZm8gKiltYXRjaC0+ZGF0
YSktPnNyY2FkZHIsCiAJCSAgKChzdHJ1Y3QgaXB0X21hY19pbmZvICopbWF0
Y2gtPmRhdGEpLT5pbnZlcnQpOwogfQo=

--0-2045304795-1031576820=:78090--
