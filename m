From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: ipt_TARPIT.c - dst_ptmu
Date: Mon, 9 May 2005 23:58:22 -0400
Message-ID: <debc30fc05050920582d8bde35@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----=_Part_304_1105951.1115697502231"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

------=_Part_304_1105951.1115697502231
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I get errors about :
*** Warning: "dst_pmtu" [net/ipv4/netfilter/ipt_TARPIT.ko] undefined!
when compiling the TARPIT, I replaced the dst_pmtu with dst_mtu and it
now works, just a little patch to do to ipt_TARPIT.c to make it work
with the new kernel I think. Using 2.6.12-rc3-mm3.

------=_Part_304_1105951.1115697502231
Content-Type: application/octet-stream; name="ipt_TARPIT.c.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ipt_TARPIT.c.diff"

LS0tIGlwdF9UQVJQSVQuYy5vbGQJMjAwNS0wNS0wOSAyMzo1NDo1MC4wMDAwMDAwMDAgLTA0MDAK
KysrIGlwdF9UQVJQSVQuYwkyMDA1LTA1LTA5IDIzOjUxOjE0LjAwMDAwMDAwMCAtMDQwMApAQCAt
MTk0LDcgKzE5NCw3IEBACiAJbnNrYi0+ZHN0ID0gJm5ydC0+dS5kc3Q7CiAKIAkvKiAiTmV2ZXIg
aGFwcGVucyIgKi8KLQlpZiAobnNrYi0+bGVuID4gZHN0X3BtdHUobnNrYi0+ZHN0KSkKKwlpZiAo
bnNrYi0+bGVuID4gZHN0X210dShuc2tiLT5kc3QpKQogCQlnb3RvIGZyZWVfbnNrYjsKIAogCWlw
X2RpcmVjdF9zZW5kIChuc2tiKTsK
------=_Part_304_1105951.1115697502231--
