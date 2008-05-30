From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: iptables version defines
Date: Fri, 30 May 2008 11:56:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805301155550.16963@bizon.gios.gov.pl>
References: <200805301016.03130.thomas.jarosch@intra2net.com>
 <Pine.LNX.4.64.0805301140430.14733@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-427901961-1212141388=:16963"
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:37944 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYE3J4d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 05:56:33 -0400
In-Reply-To: <Pine.LNX.4.64.0805301140430.14733@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-427901961-1212141388=:16963
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 30 May 2008, Krzysztof Oledzki wrote:

>
>
> On Fri, 30 May 2008, Thomas Jarosch wrote:
>
>> Hello netfilter coreteam,
>>=20
>> I'm currently looking for a way to support ipt_ACCOUNT
>> both for iptables 1.4.0 and iptables 1.4.1. Some function
>> names changed (addr_to_dotted() -> ipaddr_to_numeric())
>> and it would be easy to #ifdef around them.
>>=20
>> The linux kernel provides multiple defines for its version number,
>> while iptables only supports a char* version string.
>>=20
>> Would it make sense to add something like the kernel version defines
>> so one could write code like this:
>>=20
>> #if IPTABLES_VERSION_CODE < IPTABLES_VERSION(1,4,1)
>> =09abc
>> #else
>> =09xyz
>> #endif
>
> #ifdef _XTABLES_H
> init(struct xt_entry_target *t)
> #else
> init(struct ipt_entry_target *t, unsigned int *nfcache)
> #endif

Plese check the attached patch.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-427901961-1212141388=:16963
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=libipt_ACCOUNT.c-patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0805301156280.16963@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=libipt_ACCOUNT.c-patch

LS0tIGxpYmlwdF9BQ0NPVU5ULmMJMjAwNy0xMi0xNCAxMDo0MjoxNi4wMDAw
MDAwMDAgKzAxMDANCisrKyBsaWJpcHRfQUNDT1VOVC5jLW5ldwkyMDA4LTA1
LTEyIDIzOjE0OjE1LjAwMDAwMDAwMCArMDIwMA0KQEAgLTMwLDE0ICszMCwy
MCBAQA0KIA0KIC8qIEluaXRpYWxpemUgdGhlIHRhcmdldC4gKi8NCiBzdGF0
aWMgdm9pZA0KKyNpZmRlZiBfWFRBQkxFU19IDQoraW5pdChzdHJ1Y3QgeHRf
ZW50cnlfdGFyZ2V0ICp0KQ0KKyNlbHNlDQogaW5pdChzdHJ1Y3QgaXB0X2Vu
dHJ5X3RhcmdldCAqdCwgdW5zaWduZWQgaW50ICpuZmNhY2hlKQ0KKyNlbmRp
Zg0KIHsNCiAgICAgc3RydWN0IGlwdF9hY2NfaW5mbyAqYWNjb3VudGluZm8g
PSAoc3RydWN0IGlwdF9hY2NfaW5mbyAqKXQtPmRhdGE7DQogDQogICAgIGFj
Y291bnRpbmZvLT50YWJsZV9uciA9IC0xOw0KIA0KKyNpZm5kZWYgX1hUQUJM
RVNfSA0KICAgICAvKiBDYW4ndCBjYWNoZSB0aGlzICovDQogICAgICpuZmNh
Y2hlIHw9IE5GQ19VTktOT1dOOw0KKyNlbmRpZg0KIH0NCiANCiAjZGVmaW5l
IElQVF9BQ0NPVU5UX09QVF9BRERSIDB4MDENCkBAIC00Nyw4ICs1MywxMSBA
QA0KICAgIGF0ZSBhbiBvcHRpb24gKi8NCiBzdGF0aWMgaW50DQogcGFyc2Uo
aW50IGMsIGNoYXIgKiphcmd2LCBpbnQgaW52ZXJ0LCB1bnNpZ25lZCBpbnQg
KmZsYWdzLA0KLSAgICAgIGNvbnN0IHN0cnVjdCBpcHRfZW50cnkgKmVudHJ5
LA0KLSAgICAgIHN0cnVjdCBpcHRfZW50cnlfdGFyZ2V0ICoqdGFyZ2V0KQ0K
KyNpZmRlZiBfWFRBQkxFU19IDQorICAgICAgY29uc3Qgdm9pZCAqZW50cnks
IHN0cnVjdCB4dF9lbnRyeV90YXJnZXQgKip0YXJnZXQpDQorI2Vsc2UNCisg
ICAgICBjb25zdCBzdHJ1Y3QgaXB0X2VudHJ5ICplbnRyeSwgc3RydWN0IGlw
dF9lbnRyeV90YXJnZXQgKip0YXJnZXQpDQorI2VuZGlmDQogew0KICAgICBz
dHJ1Y3QgaXB0X2FjY19pbmZvICphY2NvdW50aW5mbyA9IChzdHJ1Y3QgaXB0
X2FjY19pbmZvICopKCp0YXJnZXQpLT5kYXRhOw0KICAgICBzdHJ1Y3QgaW5f
YWRkciAqYWRkcnMgPSBOVUxMLCBtYXNrOw0KQEAgLTEzNyw4ICsxNDYsMTMg
QEANCiANCiAvKiBQcmludHMgb3V0IHRoZSB0YXJnaW5mby4gKi8NCiBzdGF0
aWMgdm9pZA0KKyNpZmRlZiBfWFRBQkxFU19IDQorcHJpbnQoY29uc3Qgdm9p
ZCAqaXAsDQorICAgICAgY29uc3Qgc3RydWN0IHh0X2VudHJ5X3RhcmdldCAq
dGFyZ2V0LA0KKyNlbHNlDQogcHJpbnQoY29uc3Qgc3RydWN0IGlwdF9pcCAq
aXAsDQogICAgICAgY29uc3Qgc3RydWN0IGlwdF9lbnRyeV90YXJnZXQgKnRh
cmdldCwNCisjZW5kaWYNCiAgICAgICBpbnQgbnVtZXJpYykNCiB7DQogICAg
IHByaW50X2l0IChpcCwgdGFyZ2V0LCAwKTsNCkBAIC0xNDYsNyArMTYwLDEz
IEBADQogDQogLyogU2F2ZXMgdGhlIHVuaW9uIGlwdF90YXJnaW5mbyBpbiBw
YXJzYWJsZSBmb3JtIHRvIHN0ZG91dC4gKi8NCiBzdGF0aWMgdm9pZA0KLXNh
dmUoY29uc3Qgc3RydWN0IGlwdF9pcCAqaXAsIGNvbnN0IHN0cnVjdCBpcHRf
ZW50cnlfdGFyZ2V0ICp0YXJnZXQpDQorI2lmZGVmIF9YVEFCTEVTX0gNCitz
YXZlKGNvbnN0IHZvaWQgKmlwLA0KKyAgICAgY29uc3Qgc3RydWN0IHh0X2Vu
dHJ5X3RhcmdldCAqdGFyZ2V0KQ0KKyNlbHNlDQorc2F2ZShjb25zdCBzdHJ1
Y3QgaXB0X2lwICppcCwNCisgICAgIGNvbnN0IHN0cnVjdCBpcHRfZW50cnlf
dGFyZ2V0ICp0YXJnZXQpDQorI2VuZGlmDQogew0KICAgICBwcmludF9pdChp
cCwgdGFyZ2V0LCAxKTsNCiB9DQo=

---187430788-427901961-1212141388=:16963--
