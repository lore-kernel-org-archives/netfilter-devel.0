From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [PATCH] BUG: libiptc chain references bug
Date: Sun, 16 Jul 2006 22:19:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0607162125500.31595@ask.diku.dk>
References: <Pine.LNX.4.61.0607121722360.13610@ask.diku.dk>
	<Pine.LNX.4.61.0607131303220.29013@tyr.diku.dk>
	<Pine.LNX.4.61.0607141427230.31153@tyr.diku.dk>
	<44BA54E1.1000908@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=------------050709010700000304050009
Cc: hawk@comx.dk, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44BA54E1.1000908@netfilter.org>
Content-ID: <Pine.LNX.4.61.0607162125501.31595@ask.diku.dk>
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

--------------050709010700000304050009
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <Pine.LNX.4.61.0607162125502.31595@ask.diku.dk>


On Sun, 16 Jul 2006, Pablo Neira Ayuso wrote:

> Hi Jesper,

Hi Pablo, nice to hear from you!

> Jesper Dangaard Brouer wrote:
>> 
>> Correcting a chain references increment bug in libiptc.
>> 
>> The bug lies in function iptc_delete_entry() / TC_DELETE_ENTRY.  The
>> problem is the construction of "r" the rule entry, that is used for
>> comparison. The problem is that the function iptcc_map_target()
>> increase the target chains references count.
>> 
>> The fix is to use function iptcc_delete_rule() to delete the "r" rule
>> (as it decrement the counter again). To make it work a small NULL
>> pointer check is also added iptcc_delete_rule().
>> 
>> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
>
> I don't like too much the is-the-rule-in-list checking in delete_entry, 
> please, could you tell me what you think about the patch attached? I think 
> it's cleaner. Thanks.

First of all, (no offence) your patch will not work, as it does not catch 
all control-flow cases. That is, if no match was found your patch does not 
decrement the refcount. Hint, look at the places free(r) is called.

I have attached a patch, that does catch all cases.  This is achived by 
adding a else statement to the if statement where iptcc_map_target is 
called.

I did consider, your strategy, but the reason I decided not to, was that I 
though it was cleaner to always call "iptcc_delete_rule" when we want to 
delete a rule, instead of free'ing it manually.

Well, I think Patrick should make the decision. As long as we fix the bug, 
I don't care which patch goes in.

Cheers,
   Jesper Brouer

p.s. Pablo, I was not going to piss in the bush... I was just discussing 
with Gert Hansen about how dry the plant was... Perhaps the plant would 
have preferred that I would have taken a leak... See you around ;-)

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
--------------050709010700000304050009
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name="iptables.references_bug02.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0607162219170.31595@ask.diku.dk>
Content-Description: 
Content-Disposition: attachment; filename="iptables.references_bug02.patch"

SW5kZXg6IGxpYmlwdGMvbGliaXB0Yy5jDQo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09DQotLS0gbGliaXB0Yy9saWJpcHRjLmMJKHJldmlzaW9uIDY2NDQpDQor
KysgbGliaXB0Yy9saWJpcHRjLmMJKHdvcmtpbmcgY29weSkNCkBAIC0xNTE4
LDggKzE1MTgsMTYgQEAgVENfREVMRVRFX0VOVFJZKGNvbnN0IElQVF9DSEFJ
TkxBQkVMIGNoYQ0KIAlpZiAoIWlwdGNjX21hcF90YXJnZXQoKmhhbmRsZSwg
cikpIHsNCiAJCURFQlVHUCgidW5hYmxlIHRvIG1hcCB0YXJnZXQgb2YgcnVs
ZSBmb3IgY2hhaW4gYCVzJ1xuIiwgY2hhaW4pOw0KIAkJZnJlZShyKTsNCiAJ
CXJldHVybiAwOw0KKwl9IGVsc2Ugew0KKwkJLyogaXB0Y2NfbWFwX3Rhcmdl
dCBpbmNyZW1lbnQgdGFyZ2V0IGNoYWluIHJlZmVyZW5jZXMNCisJCSAqIHNp
bmNlIHRoaXMgaXMgYSBmYWtlIHJ1bGUgb25seSB1c2VkIGZvciBtYXRjaGlu
Zw0KKwkJICogdGhlIGNoYWluIHJlZmVyZW5jZXMgY291bnQgaXMgZGVjcmVt
ZW50ZWQgYWdhaW4uIA0KKwkJICovDQorCQlpZiAoci0+dHlwZSA9PSBJUFRD
Q19SX0pVTVANCisJCSAgICAmJiByLT5qdW1wKQ0KKwkJCXItPmp1bXAtPnJl
ZmVyZW5jZXMtLTsNCiAJfQ0KIA0KIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGks
ICZjLT5ydWxlcywgbGlzdCkgew0KIAkJdW5zaWduZWQgY2hhciAqbWFzazsN
Cg==

--------------050709010700000304050009--
