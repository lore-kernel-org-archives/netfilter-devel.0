From: =?UTF-8?B?UGVkcm8gTGFtYXLDo28=?= <pedro.lamarao@globo.com>
Subject: why don't we use /etc/protocols ?
Date: Thu, 18 Mar 2004 15:54:39 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4059F06F.1050306@globo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090507060100070006030307"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------090507060100070006030307
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

I've just subscribed to the list, so, uhm, hello.

I tried to look for some older discussion about this section of 
iptables-save.c, but I'm not that good at searching mailing list 
archives, so here it goes.

Browsing the code I stumbled at this FIXME in iptables-save.c and 
produced the following patch. Please review it and send me comments. 
I'll be over this code for some time, so, if there is more of this kind 
of FIXME, I'd gladly work on it.

--
  Pedro

--------------090507060100070006030307
Content-Type: text/plain;
 name="patch.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch.txt"

SW5kZXg6IGlwdGFibGVzLXNhdmUuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClJDUyBmaWxlOiAvY3ZzcHVi
bGljL2lwdGFibGVzL2lwdGFibGVzLXNhdmUuYyx2CnJldHJpZXZpbmcgcmV2aXNpb24gMS4y
NwpkaWZmIC11IC1yMS4yNyBpcHRhYmxlcy1zYXZlLmMKLS0tIGlwdGFibGVzLXNhdmUuYwky
MSBGZWIgMjAwNCAwOToyMDozNCAtMDAwMAkxLjI3CisrKyBpcHRhYmxlcy1zYXZlLmMJMTgg
TWFyIDIwMDQgMTg6NTM6NTQgLTAwMDAKQEAgLTYyLDM2ICs2MiwxOCBAQAogCXByaW50Zigi
ICIpOwogfQogCi0vKiBUaGVzZSBhcmUgaGFyZGNvZGVkIGJhY2t1cHMgaW4gaXB0YWJsZXMu
Yywgc28gdGhleSBhcmUgc2FmZSAqLwotc3RydWN0IHBwcm90IHsKLQljaGFyICpuYW1lOwot
CXVfaW50OF90IG51bTsKLX07Ci0KLS8qIEZJWE1FOiB3aHkgZG9uJ3Qgd2UgdXNlIC9ldGMv
cHJvdG9jb2xzID8gKi8KLXN0YXRpYyBjb25zdCBzdHJ1Y3QgcHByb3QgY2hhaW5fcHJvdG9z
W10gPSB7Ci0JeyAidGNwIiwgSVBQUk9UT19UQ1AgfSwKLQl7ICJ1ZHAiLCBJUFBST1RPX1VE
UCB9LAotCXsgImljbXAiLCBJUFBST1RPX0lDTVAgfSwKLQl7ICJlc3AiLCBJUFBST1RPX0VT
UCB9LAotCXsgImFoIiwgSVBQUk9UT19BSCB9LAotCXsgInNjdHAiLCBJUFBST1RPX1NDVFAg
fSwKLX07Ci0KIHN0YXRpYyB2b2lkIHByaW50X3Byb3RvKHVfaW50MTZfdCBwcm90bywgaW50
IGludmVydCkKIHsKIAlpZiAocHJvdG8pIHsKLQkJdW5zaWduZWQgaW50IGk7CiAJCWNvbnN0
IGNoYXIgKmludmVydHN0ciA9IGludmVydCA/ICIhICIgOiAiIjsKIAotCQlmb3IgKGkgPSAw
OyBpIDwgc2l6ZW9mKGNoYWluX3Byb3Rvcykvc2l6ZW9mKHN0cnVjdCBwcHJvdCk7IGkrKykK
LQkJCWlmIChjaGFpbl9wcm90b3NbaV0ubnVtID09IHByb3RvKSB7Ci0JCQkJcHJpbnRmKCIt
cCAlcyVzICIsCi0JCQkJICAgICAgIGludmVydHN0ciwgY2hhaW5fcHJvdG9zW2ldLm5hbWUp
OwotCQkJCXJldHVybjsKLQkJCX0KLQotCQlwcmludGYoIi1wICVzJXUgIiwgaW52ZXJ0c3Ry
LCBwcm90byk7CisJCXN0cnVjdCBwcm90b2VudCogcGVudCA9IGdldHByb3RvYnludW1iZXIo
cHJvdG8pCisJCWlmIChwcm90bykgeworCQkJcHJpbnRmKCItcCAlcyVzICIsIGludmVydHN0
ciwgcGVudC0+cF9uYW1lKTsKKwkJfQorCQllbHNlIHsKKwkJCXByaW50ZigiLXAgJXMldSIs
IGludmVydHN0ciwgcHJvdG8pOworCQl9CiAJfQogfQogCg==
--------------090507060100070006030307--
