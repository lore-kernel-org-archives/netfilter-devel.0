From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH] netfilter: Remove the duplicated word "see" in the
 comment when set the IPS_ASSURED_BIT in tcp_packet
Date: Thu, 20 Aug 2015 08:47:33 +0800
Message-ID: <CA+6hz4rB=QDD8Ei39ieothtf+kyuv9h6VJXeFJD2R78RM94G0Q@mail.gmail.com>
References: <CA+6hz4o4TbcAhgnC8sbN6utxAR=wWOMkd_=k+hGVqW+tZZxuZw@mail.gmail.com>
	<20150819192537.GA4636@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e0158b2162866b2051db37f5d
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33133 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbHTArd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 20:47:33 -0400
Received: by obbhe7 with SMTP id he7so19474416obb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2015 17:47:33 -0700 (PDT)
In-Reply-To: <20150819192537.GA4636@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--089e0158b2162866b2051db37f5d
Content-Type: text/plain; charset=UTF-8

Hi Pablo,

Thanks your reply and advice.
Now I have updated the patch according to your advice.

>From 8844279c5e8966b57251c20c003e896f49f768ee Mon Sep 17 00:00:00 2001
From: Feng Gao <gfree.wind@gmail.com>
Date: Thu, 20 Aug 2015 08:43:26 +0800
Subject: [PATCH] netfilter: nf_ct_tcp: Remove the duplicated word in comment

Signed-off-by: Feng Gao <gfree.wind@gmail.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
b/net/netfilter/nf_conntrack_proto_tcp.c
index 70383de..cf7b18a 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1088,9 +1088,9 @@ static int tcp_packet(struct nf_conn *ct,
           && (old_state == TCP_CONNTRACK_SYN_RECV
               || old_state == TCP_CONNTRACK_ESTABLISHED)
           && new_state == TCP_CONNTRACK_ESTABLISHED) {
-       /* Set ASSURED if we see see valid ack in ESTABLISHED
-          after SYN_RECV or a valid answer for a picked up
-          connection. */
+       /* Set ASSURED if we see valid ack in ESTABLISHED after
+        * SYN_RECV or a valid answer for a picked up connection.
+        */
        set_bit(IPS_ASSURED_BIT, &ct->status);
        nf_conntrack_event_cache(IPCT_ASSURED, ct);
    }
--


On Thu, Aug 20, 2015 at 3:25 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Aug 13, 2015 at 04:22:28PM +0800, Feng Gao wrote:
>> Hi Pablo,
>>
>> There is one duplicated word "see" in the comment when set the
>> IPS_ASSURED_BIT in tcp_packet.
>>
>> The attachment is the patch file.
>>
>> The following is the change.
>>
>> From d092aaa3dc847ed08b27081a467e39727d6627cb Mon Sep 17 00:00:00 2001
>> From: Feng Gao <gfree.wind@gmail.com>
>> Date: Thu, 13 Aug 2015 16:14:36 +0800
>> Subject: [PATCH 1/1] netfilter: Remove the duplicated word "see" in the
>>  comment when set the IPS_ASSURED_BIT in tcp_packet
>>
>> Signed-off-by: Feng Gao <gfree.wind@gmail.com>
>> ---
>>  net/netfilter/nf_conntrack_proto_tcp.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
>> b/net/netfilter/nf_conntrack_proto_tcp.c
>> index 70383de..697210f 100644
>> --- a/net/netfilter/nf_conntrack_proto_tcp.c
>> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
>> @@ -1088,7 +1088,7 @@ static int tcp_packet(struct nf_conn *ct,
>>            && (old_state == TCP_CONNTRACK_SYN_RECV
>>                || old_state == TCP_CONNTRACK_ESTABLISHED)
>>            && new_state == TCP_CONNTRACK_ESTABLISHED) {
>> -       /* Set ASSURED if we see see valid ack in ESTABLISHED
>> +       /* Set ASSURED if we see valid ack in ESTABLISHED
>>            after SYN_RECV or a valid answer for a picked up
>>            connection. */
>
> I think this is a good chance to fix the comment style, this should
> be:
>
>         /* Set ASSURED if we see valid ack in ESTABLISHED after
>          * SYN_RECV or a valid answer for a picked up connection.
>          */
>
> Would you update the comment style in the same patch and resubmit,
> please?
>
> I'd also suggest a smaller patch title, eg.
>
> netfilter: nf_ct_tcp: Remove the duplicated word in comment
>
> Thanks!

--089e0158b2162866b2051db37f5d
Content-Type: application/octet-stream;
	name="0001-netfilter-nf_ct_tcp-Remove-the-duplicated-word-in-co.patch"
Content-Disposition: attachment;
	filename="0001-netfilter-nf_ct_tcp-Remove-the-duplicated-word-in-co.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_idjhm84p0

RnJvbSA4ODQ0Mjc5YzVlODk2NmI1NzI1MWMyMGMwMDNlODk2ZjQ5Zjc2OGVlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGZW5nIEdhbyA8Z2ZyZWUud2luZEBnbWFpbC5jb20+CkRhdGU6
IFRodSwgMjAgQXVnIDIwMTUgMDg6NDM6MjYgKzA4MDAKU3ViamVjdDogW1BBVENIXSBuZXRmaWx0
ZXI6IG5mX2N0X3RjcDogUmVtb3ZlIHRoZSBkdXBsaWNhdGVkIHdvcmQgaW4gY29tbWVudAoKU2ln
bmVkLW9mZi1ieTogRmVuZyBHYW8gPGdmcmVlLndpbmRAZ21haWwuY29tPgotLS0KIG5ldC9uZXRm
aWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX3RjcC5jIHwgNiArKystLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L25ldGZp
bHRlci9uZl9jb25udHJhY2tfcHJvdG9fdGNwLmMgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFj
a19wcm90b190Y3AuYwppbmRleCA3MDM4M2RlLi5jZjdiMThhIDEwMDY0NAotLS0gYS9uZXQvbmV0
ZmlsdGVyL25mX2Nvbm50cmFja19wcm90b190Y3AuYworKysgYi9uZXQvbmV0ZmlsdGVyL25mX2Nv
bm50cmFja19wcm90b190Y3AuYwpAQCAtMTA4OCw5ICsxMDg4LDkgQEAgc3RhdGljIGludCB0Y3Bf
cGFja2V0KHN0cnVjdCBuZl9jb25uICpjdCwKIAkJICAgJiYgKG9sZF9zdGF0ZSA9PSBUQ1BfQ09O
TlRSQUNLX1NZTl9SRUNWCiAJCSAgICAgICB8fCBvbGRfc3RhdGUgPT0gVENQX0NPTk5UUkFDS19F
U1RBQkxJU0hFRCkKIAkJICAgJiYgbmV3X3N0YXRlID09IFRDUF9DT05OVFJBQ0tfRVNUQUJMSVNI
RUQpIHsKLQkJLyogU2V0IEFTU1VSRUQgaWYgd2Ugc2VlIHNlZSB2YWxpZCBhY2sgaW4gRVNUQUJM
SVNIRUQKLQkJICAgYWZ0ZXIgU1lOX1JFQ1Ygb3IgYSB2YWxpZCBhbnN3ZXIgZm9yIGEgcGlja2Vk
IHVwCi0JCSAgIGNvbm5lY3Rpb24uICovCisJCS8qIFNldCBBU1NVUkVEIGlmIHdlIHNlZSB2YWxp
ZCBhY2sgaW4gRVNUQUJMSVNIRUQgYWZ0ZXIKKwkJICogU1lOX1JFQ1Ygb3IgYSB2YWxpZCBhbnN3
ZXIgZm9yIGEgcGlja2VkIHVwIGNvbm5lY3Rpb24uCisJCSAqLwogCQlzZXRfYml0KElQU19BU1NV
UkVEX0JJVCwgJmN0LT5zdGF0dXMpOwogCQluZl9jb25udHJhY2tfZXZlbnRfY2FjaGUoSVBDVF9B
U1NVUkVELCBjdCk7CiAJfQotLSAKMS44LjMuMQoK
--089e0158b2162866b2051db37f5d--
