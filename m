From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Add refcounts to LED target
Date: Sun, 4 Apr 2010 13:59:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004041330180.22215@obet.zrqbmnf.qr>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net>
 <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net>
 <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271940470.3068@obet.zrqbmnf.qr> <4BAEB7B1.6070209@shikadi.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="683461209-1689909669-1270382391=:22215"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47085 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab0DDL7w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Apr 2010 07:59:52 -0400
In-Reply-To: <4BAEB7B1.6070209@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--683461209-1689909669-1270382391=:22215
Content-Type: TEXT/PLAIN; charset=US-ASCII


On Sunday 2010-03-28 03:58, Adam Nielsen wrote:
>>>
>>> I can post this again if you'd like to take a look.  I also have a kernel
>>> module that makes your keyboard LEDs available as LED devices if you want to
>>> test it out too.  (I could certainly use some feedback on that!)
>> 
>> Yes that would be nice, as I don't have any other LED hardware around
>> other than a cramped WRT54 device.
>
>I've uploaded the kernel module to make your keyboard LEDs accessible as LED
>devices here: http://www.shikadi.net/files/kernel/leds-input-20100328.tar.bz2

I've got patches for that. (attached)

>It's still a bit rough, but if you can see any obvious mistakes I've made
>please let me know!  There are a couple of minor issues I'm aware of listed at
>the top of the .c file.

>Due to the limited bandwidth available to most input devices, it's
>possible for a fast enough trigger (e.g. netfilter) to saturate the
>link with LED on/off messages, causing a delay between pressing a
>key and having it appear on the screen. With netfilter the
>"--led-delay 1" option solves the problem, but it might be worth
>implementing a delay here too so that it works with other LED
>trigger sources too.

And what I observed is that I get duplicated keypresses when there is
network activity. (UP with CONFIG_PREEMPT=y.) Most likely because the
i8042 keyboard is such a piece of legacy hardware that it is not
worth investigating. I don't have any USB keyboard handy right now,
so testing that needs to wait until after the holidays.

But other than that, does its job.
--683461209-1689909669-1270382391=:22215
Content-Type: TEXT/x-patch; name=kbuild.diff
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LSU.2.01.1004041359510.22215@obet.zrqbmnf.qr>
Content-Description: 
Content-Disposition: attachment; filename=kbuild.diff

LS0tDQogTWFrZWZpbGUgfCAgICA3ICsrKysrKy0NCiAxIGZpbGUgY2hhbmdl
ZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCkluZGV4OiBs
ZWRzLWlucHV0L01ha2VmaWxlDQo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQot
LS0gbGVkcy1pbnB1dC5vcmlnL01ha2VmaWxlDQorKysgbGVkcy1pbnB1dC9N
YWtlZmlsZQ0KQEAgLTEsNCArMSw5IEBADQorS0VSTkVMX0RJUiA6PSAvbGli
L21vZHVsZXMvJChzaGVsbCB1bmFtZSAtcikvYnVpbGQNCisNCiBvYmotbSA6
PSBsZWRzLWlucHV0Lm8NCiANCiBhbGw6DQotCSQoTUFLRSkgLUMgL3Vzci9z
cmMvbGludXggTT1gcHdkYCBtb2R1bGVzDQorCSQoTUFLRSkgLUMgJHtLRVJO
RUxfRElSfSBNPSQkUFdEDQorDQorY2xlYW46DQorCSQoTUFLRSkgLUMgJHtL
RVJORUxfRElSfSBNPSQkUFdEICRADQo=

--683461209-1689909669-1270382391=:22215
Content-Type: TEXT/x-patch; name=leds.diff
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LSU.2.01.1004041359511.22215@obet.zrqbmnf.qr>
Content-Description: 
Content-Disposition: attachment; filename=leds.diff

LS0tDQogbGVkcy1pbnB1dC5jIHwgICAyMiArKysrKysrKysrLS0tLS0tLS0t
LS0tDQogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEyIGRl
bGV0aW9ucygtKQ0KDQpJbmRleDogbGVkcy1pbnB1dC9sZWRzLWlucHV0LmMN
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBsZWRzLWlucHV0Lm9yaWcv
bGVkcy1pbnB1dC5jDQorKysgbGVkcy1pbnB1dC9sZWRzLWlucHV0LmMNCkBA
IC01NSwxMiArNTUsOCBAQCBzdHJ1Y3QgbGVkZGV2IHsNCiAJY2hhciBsZWRf
bmFtZVsyMF07IC8qIEFzIHBlciBsZWRfY2xhc3NkZXYubmFtZSAqLw0KIH07
DQogDQotLyogRmlndXJlIG91dCBpZiBhIGJpdCBpcyBzZXQgaW4gYW4gYXJy
YXkgb2YgbG9uZ3MgKi8NCi0jZGVmaW5lIElTX0JJVF9TRVQoYnVmZmVyLCBi
aXQpIFwNCi0JKCgoKGJ1ZmZlcilbQklUU19UT19MT05HUygoYml0KSArIDEp
IC0gMV0gPj4gKChiaXQpICUgQklUU19QRVJfTE9ORykpKSAmIDEpDQotDQog
LyogVGhlIG9yZGVyIG9mIHRoZXNlIG1hcHBpbmdzIG11c3QgbWF0Y2ggdGhl
IExFRF8qIGNvbnN0YW50cyBpbiBpbnB1dC5oICovDQotc3RhdGljIGNvbnN0
IGNoYXIgKmxlZG5hbWVzW10gPSB7DQorc3RhdGljIGNvbnN0IGNoYXIgKmNv
bnN0IGxlZG5hbWVzW10gPSB7DQogCSJudW0iLCAgICAgIC8qIExFRF9OVU1M
ICovDQogCSJjYXBzIiwgICAgIC8qIExFRF9DQVBTTCAqLw0KIAkic2Nyb2xs
IiwgICAvKiBMRURfU0NST0xMICovDQpAQCAtODQsNyArODAsNyBAQCBzdGF0
aWMgY29uc3QgY2hhciAqbGVkbmFtZXNbXSA9IHsNCiBzdGF0aWMgdm9pZCBs
ZWRzX2lucHV0X3NldChzdHJ1Y3QgbGVkX2NsYXNzZGV2ICpsZWRfY2RldiwN
CiAJZW51bSBsZWRfYnJpZ2h0bmVzcyB2YWx1ZSkNCiB7DQotCXN0cnVjdCBs
ZWRkZXYgKmxlZGRldjsNCisJY29uc3Qgc3RydWN0IGxlZGRldiAqbGVkZGV2
Ow0KIA0KIAlsZWRkZXYgPSBjb250YWluZXJfb2YobGVkX2NkZXYsIHN0cnVj
dCBsZWRkZXYsIGxlZF9jZGV2KTsNCiAJaW5wdXRfaW5qZWN0X2V2ZW50KCZs
ZWRkZXYtPmhhbmRsZXJfZGF0YS0+aGFuZGxlLA0KQEAgLTk4LDE0ICs5NCwx
NyBAQCBzdGF0aWMgdm9pZCBsZWRzX2lucHV0X3NldChzdHJ1Y3QgbGVkX2Ns
DQogLyogQ2FsbGVkIHdoZW4gdGhlIExFRCBjbGFzcyBkcml2ZXIgd2FudHMg
dG8ga25vdyB0aGlzIExFRCdzIGJyaWdodG5lc3MgKi8NCiBzdGF0aWMgZW51
bSBsZWRfYnJpZ2h0bmVzcyBsZWRzX2lucHV0X2dldChzdHJ1Y3QgbGVkX2Ns
YXNzZGV2ICpsZWRfY2RldikNCiB7DQotCXN0cnVjdCBsZWRkZXYgKmxlZGRl
diA9IGNvbnRhaW5lcl9vZihsZWRfY2Rldiwgc3RydWN0IGxlZGRldiwgbGVk
X2NkZXYpOw0KKwljb25zdCBzdHJ1Y3QgbGVkZGV2ICpsZWRkZXYgPQ0KKwkJ
Y29udGFpbmVyX29mKGxlZF9jZGV2LCBzdHJ1Y3QgbGVkZGV2LCBsZWRfY2Rl
dik7DQogCXN0cnVjdCBpbnB1dF9kZXYgKmluZGV2Ow0KIA0KLQlpZiAoIWxl
ZGRldi0+aGFuZGxlcl9kYXRhKSByZXR1cm4gTEVEX09GRjsgLyogdG9vIGVh
cmx5ICovDQorCWlmICghbGVkZGV2LT5oYW5kbGVyX2RhdGEpDQorCQlyZXR1
cm4gTEVEX09GRjsgLyogdG9vIGVhcmx5ICovDQogCWluZGV2ID0gbGVkZGV2
LT5oYW5kbGVyX2RhdGEtPmhhbmRsZS5kZXY7DQotCWlmICghaW5kZXYpIHJl
dHVybiBMRURfT0ZGOw0KKwlpZiAoIWluZGV2KQ0KKwkJcmV0dXJuIExFRF9P
RkY7DQogDQotCWlmIChJU19CSVRfU0VUKGluZGV2LT5sZWQsIGxlZGRldi0+
ZXZkZXZfbGVkX2lkKSkNCisJaWYgKHRlc3RfYml0KGxlZGRldi0+ZXZkZXZf
bGVkX2lkLCBpbmRldi0+bGVkKSkNCiAJCXJldHVybiBMRURfRlVMTDsNCiAN
CiAJcmV0dXJuIExFRF9PRkY7DQpAQCAtMTk1LDcgKzE5NCw3IEBAIHN0YXRp
YyBpbnQgbGVkZGV2X2Nvbm5lY3Qoc3RydWN0IGlucHV0X2gNCiAJLyogUmVn
aXN0ZXIgYSBkZXZpY2UgaW4gdGhlIExFRCBjbGFzcyBmb3IgZWFjaCBMRUQg
cmVwb3J0ZWQgYnkgdGhlIGlucHV0IGxheWVyICovDQogCW5ld2xlZHMgPSAw
Ow0KIAlmb3IgKGkgPSAwOyBpIDwgTEVEX0NOVDsgaSsrKSB7DQotCQlpZiAo
SVNfQklUX1NFVChkZXYtPmxlZGJpdCwgaSkpIHsNCisJCWlmICh0ZXN0X2Jp
dChpLCBkZXYtPmxlZGJpdCkpIHsNCiAJCQkvL3ByaW50ayhLRVJOX0RFQlVH
IERSVk1TRyAiaGFzIGxlZCAlZCAoJXMpXG4iLCBpLCBsZWRuYW1lc1tpXSk7
DQogCQkJZXJyb3IgPSBsZWRkZXZfY3JlYXRlKGhhbmRsZXJfZGF0YSwgaGFu
ZGxlciwgZGV2LCBpKTsNCiAJCQlpZiAoIWVycm9yKQ0KQEAgLTI4Myw3ICsy
ODIsNiBAQCBzdGF0aWMgaW50IF9faW5pdCBsZWRzX2lucHV0X2luaXQodm9p
ZCkNCiBzdGF0aWMgdm9pZCBfX2V4aXQgbGVkc19pbnB1dF9leGl0KHZvaWQp
DQogew0KIAlpbnB1dF91bnJlZ2lzdGVyX2hhbmRsZXIoJmxlZGRldl9oYW5k
bGVyKTsNCi0JcmV0dXJuOw0KIH0NCiANCiBtb2R1bGVfaW5pdChsZWRzX2lu
cHV0X2luaXQpOw0K

--683461209-1689909669-1270382391=:22215--
