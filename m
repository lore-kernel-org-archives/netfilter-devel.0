From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: OOPS in nf_ct_unlink_expect_report using Polycom RealPresence Mobile
Date: Fri, 31 Jan 2014 16:29:58 +0300
Message-ID: <CACVxJT-wtpbDuEsOpW32tck_wHKSuFkKmhHdhVvVNqFoEkdAbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c3fd1099b7ab04f1442b2d
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: astx@aws-it.at
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:43046 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbaAaNaA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Jan 2014 08:30:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--001a11c3fd1099b7ab04f1442b2d
Content-Type: text/plain; charset=UTF-8

> Disabling nf_nat_h323 and nf_conntrack_h323 avoids crash -
> but video conferencing software is no more usable.
>
> BUG: unable to handle kernel paging request at 00100104
> IP: [<f8214f07>] nf_ct_unlink_expect_report

This must be the same bug fixed in SIP module:
commit 3f509c689a07a4aa989b426893d8491a7ffcc410
netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation

Try attached patch (if this is mangled):

--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -229,7 +229,10 @@ static int nat_rtp_rtcp(struct sk_buff *skb,
struct nf_conn *ct,
  ret = nf_ct_expect_related(rtcp_exp);
  if (ret == 0)
  break;
- else if (ret != -EBUSY) {
+ else if (ret == -EBUSY) {
+ nf_ct_unexpect_related(rtp_exp);
+ continue;
+ } else if (ret < 0) {
  nf_ct_unexpect_related(rtp_exp);
  nated_port = 0;
  break;

--001a11c3fd1099b7ab04f1442b2d
Content-Type: text/plain; charset=US-ASCII; name="h323-expect.diff"
Content-Disposition: attachment; filename="h323-expect.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hr3hnlca0

LS0tIGEvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9oMzIzLmMKKysrIGIvbmV0L2lwdjQvbmV0
ZmlsdGVyL25mX25hdF9oMzIzLmMKQEAgLTIyOSw3ICsyMjksMTAgQEAgc3RhdGljIGludCBuYXRf
cnRwX3J0Y3Aoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5mX2Nvbm4gKmN0LAogCQkJcmV0
ID0gbmZfY3RfZXhwZWN0X3JlbGF0ZWQocnRjcF9leHApOwogCQkJaWYgKHJldCA9PSAwKQogCQkJ
CWJyZWFrOwotCQkJZWxzZSBpZiAocmV0ICE9IC1FQlVTWSkgeworCQkJZWxzZSBpZiAocmV0ID09
IC1FQlVTWSkgeworCQkJCW5mX2N0X3VuZXhwZWN0X3JlbGF0ZWQocnRwX2V4cCk7CisJCQkJY29u
dGludWU7CisJCQl9IGVsc2UgaWYgKHJldCA8IDApIHsKIAkJCQluZl9jdF91bmV4cGVjdF9yZWxh
dGVkKHJ0cF9leHApOwogCQkJCW5hdGVkX3BvcnQgPSAwOwogCQkJCWJyZWFrOwo=
--001a11c3fd1099b7ab04f1442b2d--
