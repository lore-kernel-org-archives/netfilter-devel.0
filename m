From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: [PATCH] libipt_statistic
Date: Sun, 1 Jul 2007 19:10:59 -0500
Message-ID: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_75185_16216654.1183335059989"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

------=_Part_75185_16216654.1183335059989
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Patrick,

I think that this calculation is erroneous:
info->u.nth.count = info->u.nth.every - info->u.nth.packet;

ex: --mode nth --every 4 --packet 6
AIUI, we want to drop the 4th packet after 6 packets have pass.
Base on this example, we want to match the 10th packet.

But we are gonna match the 7th packet, wich is wrong.
   count: -3
   every: 3
   packet: 6

 -3,  -2, -1,  0,  1,  2,  (3) -- Increment
  1,   2,   3,  4,  5,  6,   7  -- nth packet

comments are welcome.
--
I think that my patch introduce space at the beginning of each line,
someone could give me a vim hint to avoid that ? thanks.
--

acidfu

------=_Part_75185_16216654.1183335059989
Content-Type: text/x-patch; name=libipt_statistic.c.patch;
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f3m70oen
Content-Disposition: attachment; filename="libipt_statistic.c.patch"

SW5kZXg6IGxpYmlwdF9zdGF0aXN0aWMuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaWJpcHRfc3RhdGlzdGlj
LmMJKHJldmlzaW9uIDY4OTQpCisrKyBsaWJpcHRfc3RhdGlzdGljLmMJKHdvcmtpbmcgY29weSkK
QEAgLTExMyw3ICsxMTMsNyBAQAogCWlmIChmbGFncyAmIDB4OCAmJiBpbmZvLT5tb2RlICE9IFhU
X1NUQVRJU1RJQ19NT0RFX05USCkKIAkJZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwKIAkJ
CSAgICItLXBhY2tldCBjYW4gb25seSBiZSB1c2VkIGluIG50aCBtb2RlIik7Ci0JaW5mby0+dS5u
dGguY291bnQgPSBpbmZvLT51Lm50aC5ldmVyeSAtIGluZm8tPnUubnRoLnBhY2tldDsKKwlpbmZv
LT51Lm50aC5jb3VudCA9IC1pbmZvLT51Lm50aC5wYWNrZXQ7CiB9CiAKIC8qIFByaW50cyBvdXQg
dGhlIG1hdGNoaW5mby4gKi8KQEAgLTE1Niw3ICsxNTYsNyBAQAogCXByaW50X21hdGNoKGluZm8s
ICItLSIpOwogfQogCi1zdGF0aWMgc3RydWN0IGlwdGFibGVzX21hdGNoIHN0YXRpc3RpYyA9IHsg
CitzdGF0aWMgc3RydWN0IGlwdGFibGVzX21hdGNoIHN0YXRpc3RpYyA9IHsKIAkubmFtZQkJPSAi
c3RhdGlzdGljIiwKIAkudmVyc2lvbgk9IElQVEFCTEVTX1ZFUlNJT04sCiAJLnNpemUJCT0gSVBU
X0FMSUdOKHNpemVvZihzdHJ1Y3QgeHRfc3RhdGlzdGljX2luZm8pKSwK
------=_Part_75185_16216654.1183335059989--
