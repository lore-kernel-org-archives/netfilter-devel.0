From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: connlimit error?
Date: Mon, 11 Apr 2005 21:54:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504112152050.31294@filer.marasystems.com>
References: <1112710072.30219.3.camel@sas>
	<Pine.LNX.4.61.0504051612120.19152@filer.marasystems.com>
	<20050410205544.GX9155@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.61.0504102303070.16575@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463811839-995659488-1113249246=:31294"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0504102303070.16575@filer.marasystems.com>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-995659488-1113249246=:31294
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

patch to address my concerns below.

On Sun, 10 Apr 2005, Henrik Nordstrom wrote:

> On Sun, 10 Apr 2005, Harald Welte wrote:
>
>>> If I am not mistaken that = should be a ==
>> 
>> No, actually not.  two lines above "struct ip_conntrack *ct = NULL".
>> 
>> The whole purpose of this segment is to check for 'found' and if there
>> is one, resolve 'ct' based on found and do some further checks.  I've
>> added the missing parenthesis in svn now.
>> 
>> [yes, bad programming style, but I didn't want to change more than
>> absolutely required between 2.6.10 and 2.6.11 versions]
>
> Indeed bad style, not even counting the missing parantesis:
>
>  The variable ct is overloaded both as a block local and a function 
> argument. This is what fooled me into thinking the intention was to compare 
> with the ct given as argument..
>
>  In addition the block level ct is declared mid-block (not at the beginning 
> of a block) which will cause compile errors with GCC 2.95.X and RedHat GCC 
> 2.96-xxx and makes it even harder to see that it is overloaded when 
> eyeballing the code.
>
> Regards
> Henrik
>
---1463811839-995659488-1113249246=:31294
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="connlimit-style.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0504112154060.31294@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename="connlimit-style.patch"

SW5kZXg6IGNvbm5saW1pdC9saW51eC0yLjYuMTEvbmV0L2lwdjQvbmV0Zmls
dGVyL2lwdF9jb25ubGltaXQuYw0KPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
LS0tIGNvbm5saW1pdC9saW51eC0yLjYuMTEvbmV0L2lwdjQvbmV0ZmlsdGVy
L2lwdF9jb25ubGltaXQuYwkocmV2aXNpb24gMzg1NSkNCisrKyBjb25ubGlt
aXQvbGludXgtMi42LjExL25ldC9pcHY0L25ldGZpbHRlci9pcHRfY29ubmxp
bWl0LmMJKHdvcmtpbmcgY29weSkNCkBAIC02NywxMiArNjcsMTIgQEANCiAN
CiAJLyogY2hlY2sgdGhlIHNhdmVkIGNvbm5lY3Rpb25zICovDQogCWZvciAo
bGggPSBoYXNoLT5uZXh0OyBsaCAhPSBoYXNoOyBsaCA9IGxoLT5uZXh0KSB7
DQotCSAgICAgY29ubiA9IGxpc3RfZW50cnkobGgsc3RydWN0IGlwdF9jb25u
bGltaXRfY29ubixsaXN0KTsNCi0JICAgICBmb3VuZCA9IGlwX2Nvbm50cmFj
a19maW5kX2dldCgmY29ubi0+dHVwbGUsY3QpOw0KLQkgICAgICAgIHN0cnVj
dCBpcF9jb25udHJhY2sgKmN0ID0gTlVMTDsNCisJCXN0cnVjdCBpcF9jb25u
dHJhY2sgKmZvdW5kX2N0ID0gTlVMTDsNCisJCWNvbm4gPSBsaXN0X2VudHJ5
KGxoLHN0cnVjdCBpcHRfY29ubmxpbWl0X2Nvbm4sbGlzdCk7DQorCQlmb3Vu
ZCA9IGlwX2Nvbm50cmFja19maW5kX2dldCgmY29ubi0+dHVwbGUsY3QpOw0K
IAkJaWYgKDAgPT0gbWVtY21wKCZjb25uLT50dXBsZSwmdHVwbGUsc2l6ZW9m
KHR1cGxlKSkgJiYNCi0JCSAgICBmb3VuZCAhPSBOVUxMICYmIChjdCA9IHR1
cGxlaGFzaF90b19jdHJhY2soZm91bmQpKSAmJg0KLQkJICAgIGN0LT5wcm90
by50Y3Auc3RhdGUgIT0gVENQX0NPTk5UUkFDS19USU1FX1dBSVQpIHsNCisJ
CSAgICBmb3VuZCAhPSBOVUxMICYmIChmb3VuZF9jdCA9IHR1cGxlaGFzaF90
b19jdHJhY2soZm91bmQpKSAhPSBOVUxMICYmDQorCQkgICAgZm91bmRfY3Qt
PnByb3RvLnRjcC5zdGF0ZSAhPSBUQ1BfQ09OTlRSQUNLX1RJTUVfV0FJVCkg
ew0KIAkJCS8qIEp1c3QgdG8gYmUgc3VyZSB3ZSBoYXZlIGl0IG9ubHkgb25j
ZSBpbiB0aGUgbGlzdC4NCiAJCQkgICBXZSBzaG91bGQnbnQgc2VlIHR1cGxl
cyB0d2ljZSB1bmxlc3Mgc29tZW9uZSBob29rcyB0aGlzDQogCQkJICAgaW50
byBhIHRhYmxlIHdpdGhvdXQgIi1wIHRjcCAtLXN5biIgKi8NCkBAIC04Myw3
ICs4Myw3IEBADQogCQkgICAgICAgaXB0X2lwaGFzaChhZGRyICYgbWFzayks
DQogCQkgICAgICAgTklQUVVBRChjb25uLT50dXBsZS5zcmMuaXApLCBudG9o
cyhjb25uLT50dXBsZS5zcmMudS50Y3AucG9ydCksDQogCQkgICAgICAgTklQ
UVVBRChjb25uLT50dXBsZS5kc3QuaXApLCBudG9ocyhjb25uLT50dXBsZS5k
c3QudS50Y3AucG9ydCksDQotCQkgICAgICAgKE5VTEwgIT0gZm91bmQpID8g
dGNwW2N0LT5wcm90by50Y3Auc3RhdGVdIDogImdvbmUiKTsNCisJCSAgICAg
ICAoTlVMTCAhPSBmb3VuZCkgPyB0Y3BbZm91bmRfY3QtPnByb3RvLnRjcC5z
dGF0ZV0gOiAiZ29uZSIpOw0KICNlbmRpZg0KIAkJaWYgKE5VTEwgPT0gZm91
bmQpIHsNCiAJCQkvKiB0aGlzIG9uZSBpcyBnb25lICovDQpAQCAtOTIsMjAg
KzkyLDIwIEBADQogCQkJa2ZyZWUoY29ubik7DQogCQkJY29udGludWU7DQog
CQl9DQotCQlpZiAoY3QtPnByb3RvLnRjcC5zdGF0ZSA9PSBUQ1BfQ09OTlRS
QUNLX1RJTUVfV0FJVCkgew0KKwkJaWYgKGZvdW5kX2N0LT5wcm90by50Y3Au
c3RhdGUgPT0gVENQX0NPTk5UUkFDS19USU1FX1dBSVQpIHsNCiAJCQkvKiB3
ZSBkb24ndCBjYXJlIGFib3V0IGNvbm5lY3Rpb25zIHdoaWNoIGFyZQ0KIAkJ
CSAgIGNsb3NlZCBhbHJlYWR5IC0+IGRpdGNoIGl0ICovDQogCQkJbGggPSBs
aC0+cHJldjsNCiAJCQlsaXN0X2RlbChsaC0+bmV4dCk7DQogCQkJa2ZyZWUo
Y29ubik7DQotCQkJbmZfY29ubnRyYWNrX3B1dCgmY3QtPmN0X2dlbmVyYWwp
Ow0KKwkJCW5mX2Nvbm50cmFja19wdXQoJmZvdW5kX2N0LT5jdF9nZW5lcmFs
KTsNCiAJCQljb250aW51ZTsNCiAJCX0NCiAJCWlmICgoYWRkciAmIG1hc2sp
ID09IChjb25uLT50dXBsZS5zcmMuaXAgJiBtYXNrKSkgew0KIAkJCS8qIHNh
bWUgc291cmNlIElQIGFkZHJlc3MgLT4gYmUgY291bnRlZCEgKi8NCiAJCQlt
YXRjaGVzKys7DQogCQl9DQotCQluZl9jb25udHJhY2tfcHV0KCZjdC0+Y3Rf
Z2VuZXJhbCk7DQorCQluZl9jb25udHJhY2tfcHV0KCZmb3VuZF9jdC0+Y3Rf
Z2VuZXJhbCk7DQogCX0NCiAJaWYgKGFkZGl0KSB7DQogCQkvKiBzYXZlIHRo
ZSBuZXcgY29ubmVjdGlvbiBpbiBvdXIgbGlzdCAqLw0K

---1463811839-995659488-1113249246=:31294--
