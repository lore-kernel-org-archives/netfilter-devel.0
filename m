From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Wed, 17 Mar 2004 17:35:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403171734230.11069-200000@filer.marasystems.com>
References: <1079530631.810.117.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1397364434-1079541322=:11069"
Cc: Vijaya Chandra Vupputuri <vijay@tachyontech.net>,
   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1079530631.810.117.camel@nienna.balabit>
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

---1463811839-1397364434-1079541322=:11069
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Wed, 17 Mar 2004, KOVACS Krisztian wrote:

> On Wed, 2004-03-17 at 14:04, Henrik Nordstrom wrote:
> > nothing. Thinking.. ah, now I get it. The problem is that you are doing
> > traffic local->local and that the NAT code then gets confused as it sees
> > the same packet twice in each direction, and as no null mapping was
> > created the first time for the "local" side PREROUTING tries to when it
> > sees the traffic coming "in" (from itself).
> 
>   Yes, this is the case.

The attached patch MAY fix this issue (completely untested, I always 
compile with CONFIG_IP_NF_LOCAL_NAT enabled).

Regards
Henrik

---1463811839-1397364434-1079541322=:11069
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="renat_confirmed.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0403171735220.11069@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename="renat_confirmed.patch"

LS0tIGlwX25hdF9zdGFuZGFsb25lLmMtMi40LjI1CVdlZCBNYXIgMTcgMTc6
MjM6MzMgMjAwNA0KKysrIGlwX25hdF9zdGFuZGFsb25lLmMJV2VkIE1hciAx
NyAxNzozMzoyOCAyMDA0DQpAQCAtMTE0LDcgKzExNCwxNiBAQA0KIAkJV1JJ
VEVfTE9DSygmaXBfbmF0X2xvY2spOw0KIAkJLyogU2VlbiBpdCBiZWZvcmU/
ICBUaGlzIGNhbiBoYXBwZW4gZm9yIGxvb3BiYWNrLCByZXRyYW5zLA0KIAkJ
ICAgb3IgbG9jYWwgcGFja2V0cy4uICovDQotCQlpZiAoIShpbmZvLT5pbml0
aWFsaXplZCAmICgxIDw8IG1hbmlwdHlwZSkpKSB7DQorCQlpZiAoIShpbmZv
LT5pbml0aWFsaXplZCAmICgxIDw8IG1hbmlwdHlwZSkpDQorI2lmbmRlZiBD
T05GSUdfSVBfTkZfTkFUX0xPQ0FMDQorCQkgICAgLyogSWYgdGhpcyBzZXNz
aW9uIGhhcyBhbHJlYWR5IGJlZW4gY29uZmlybWVkIHdlIG11c3Qgbm90DQor
CQkgICAgICogdG91Y2ggaXQgYWdhaW4gZXZlbiBpZiB0aGVyZSBpcyBubyBt
YXBwaW5nIHNldCB1cC4NCisJCSAgICAgKiBDYW4gb25seSBoYXBwZW4gb24g
bG9jYWwtPmxvY2FsIHRyYWZmaWMgd2l0aA0KKwkJICAgICAqIENPTkZJR19J
UF9ORl9OQVRfTE9DQUwgZGlzYWJsZWQuDQorCQkgICAgICovDQorCQkgICAg
JiYgY3QtPnN0YXR1cyAmIElQU19DT05GSVJNRUQNCisjZW5kaWYNCisJCSAg
ICApIHsNCiAJCQl1bnNpZ25lZCBpbnQgcmV0Ow0KIA0KIAkJCWlmIChjdC0+
bWFzdGVyDQo=
---1463811839-1397364434-1079541322=:11069--
