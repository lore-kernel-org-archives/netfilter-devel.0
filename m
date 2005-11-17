From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problems with libnetfilter_conntrack / cntl_test
Date: Thu, 17 Nov 2005 02:38:35 +0100
Message-ID: <437BDF1B.1050107@eurodev.net>
References: <200511161439.04498.pluto@agmk.net> <437B53E9.2080800@eurodev.net>
	<200511161809.25277.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000205060506060401010707"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
In-Reply-To: <200511161809.25277.pluto@agmk.net>
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

This is a multi-part message in MIME format.
--------------000205060506060401010707
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Paweł Sikora wrote:
> Dnia środa, 16 listopada 2005 16:44, napisałeś:
> 
>>Pawel Sikora wrote:
>>
>>>I have installed a 2.6.14.2 kernel + grsecurity-2.1.7-2.6.14.2-$latest,
>>>libnfnetlink-0.0.13 and libnetfilter_conntrack-0.0.28.
>>>
>>>./ctnl_test fails:
>>>
>>>Test for libnetfilter_conntrack
>>>
>>>NFNETLINK answers: Invalid argument
>>>TEST 1: create conntrack (-22)
>>>TEST 2: dump conntrack table and reset (-22)
>>>TEST 3: dump conntrack table (-22)
>>>TEST 4: get conntrack (-22)
>>>TEST 5: update conntrack (-22)
>>>NFNETLINK answers: Invalid argument
>>>TEST 6: delete conntrack (-22)
>>>nfnl_open: bind(netlink): Operation not permitted
>>>Can't open handler
>>>Test failed with error -2. Errors=7
>>>
>>>Is this a grsec issue?
>>
>>Hard to say, my last contact with grsec was years ago. That output is
>>kind of weird. Could you try reverting the grsec patch?
> 
> 
> currently I get the same error on 2.6.14.2 without grsec on root account.
> first failure occurs at first call of nfnl_talk().

There's nothing wrong in nfnl_talk. It is the kernel that is returning
-EINVAL to userspace. Please apply the patch attached. It enables
debugging. Send me the output since I'm not able to reproduce that
problem that you're reporting. BTW, is that a x86 box?

-- 
Pablo

--------------000205060506060401010707
Content-Type: text/plain;
 name="debug.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="debug.patch"

SW5kZXg6IGxpbnV4LTIuNi4xNC4yL25ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gbGludXgtMi42LjE0LjIub3JpZy9uZXQvbmV0ZmlsdGVyL25mbmV0bGlu
ay5jCTIwMDUtMTEtMTEgMDY6MzM6MTIuMDAwMDAwMDAwICswMTAwCisrKyBsaW51eC0yLjYu
MTQuMi9uZXQvbmV0ZmlsdGVyL25mbmV0bGluay5jCTIwMDUtMTEtMTcgMDI6MzU6MjEuMDAw
MDAwMDAwICswMTAwCkBAIC00Myw3ICs0Myw3IEBAIE1PRFVMRV9BTElBU19ORVRfUEZfUFJP
VE8oUEZfTkVUTElOSywgTkUKIAogc3RhdGljIGNoYXIgX19pbml0ZGF0YSBuZnZlcnNpb25b
XSA9ICIwLjMwIjsKIAotI2lmIDAKKyNpZiAxCiAjZGVmaW5lIERFQlVHUChmb3JtYXQsIGFy
Z3MuLi4pCVwKIAkJcHJpbnRrKEtFUk5fREVCVUcgIiVzKCVkKTolcygpOiAiIGZvcm1hdCwg
X19GSUxFX18sIFwKIAkJCV9fTElORV9fLCBfX0ZVTkNUSU9OX18sICMjIGFyZ3MpCkluZGV4
OiBsaW51eC0yLjYuMTQuMi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRyYWNrX25ldGxp
bmsuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMTQuMi5vcmlnL25ldC9pcHY0L25l
dGZpbHRlci9pcF9jb25udHJhY2tfbmV0bGluay5jCTIwMDUtMTEtMTEgMDY6MzM6MTIuMDAw
MDAwMDAwICswMTAwCisrKyBsaW51eC0yLjYuMTQuMi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBf
Y29ubnRyYWNrX25ldGxpbmsuYwkyMDA1LTExLTE3IDAyOjM1OjAyLjAwMDAwMDAwMCArMDEw
MApAQCAtNDYsNyArNDYsNyBAQCBNT0RVTEVfTElDRU5TRSgiR1BMIik7CiAKIHN0YXRpYyBj
aGFyIF9faW5pdGRhdGEgdmVyc2lvbltdID0gIjAuOTAiOwogCi0jaWYgMAorI2lmIDEKICNk
ZWZpbmUgREVCVUdQIHByaW50awogI2Vsc2UKICNkZWZpbmUgREVCVUdQKGZvcm1hdCwgYXJn
cy4uLikK
--------------000205060506060401010707--
