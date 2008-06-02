From: "Rami Rosen" <ramirose@gmail.com>
Subject: [PATCH net-2.6] [NETFILTER] Misc Cleanups.
Date: Mon, 2 Jun 2008 14:11:42 +0300
Message-ID: <eb3ff54b0806020411p16531d2chb05061a6d209b406@mail.gmail.com>
References: <20080601.234549.229050768.davem@davemloft.net>
	 <4843C183.4060008@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_10188_10248701.1212405102526"
Cc: "David Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:25783 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYFBLLo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:11:44 -0400
Received: by rv-out-0506.google.com with SMTP id l9so994310rvb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2008 04:11:42 -0700 (PDT)
In-Reply-To: <4843C183.4060008@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------=_Part_10188_10248701.1212405102526
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
  - Thanks for your comments; I was not aware that this issues occur
in other places too; attached here is another patch, fixing where
applicable in ip6_queue and nfnetlink_queue.

  1) in net/ipv6/netfilter/ip6_queue.c
    - No need to perform data_len = 0 in the switch command, since data_len
	   is initialized to 0 in the beginning of the
ipq_build_packet_message() method
    - We can reach nlmsg_failure only from one place; skb is sure to be NULL
	     when getting there; since skb is NULL, there is no need to check this fact
	     and call kfree_skb().

2) in net/netfilter/nfnetlink_queue.c:
    - No need to perform data_len = 0 in the switch command, since data_len
	   is initialized to 0 in the beginning of the
nfqnl_build_packet_message() method

(Note: here, as opposed to previous patch, nlmsg_failure must check
skb and free it if it is not NULL, so the call to kfree_skb() is
needed , so it is not removed)
	
 	

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>


On Mon, Jun 2, 2008 at 12:46 PM, Patrick McHardy <kaber@trash.net> wrote:
> David Miller wrote:
>>
>> Forwarding to netfilter-devel where this belongs...
>
> Thanks.
>
>>        In this patch, these three fixes were made in
>> net/ipv4/netfilter/ip_queue.c:
>>
>>        1) No need to perform data_len = 0 in the switch command, since
>> data_len
>>           is initialized to 0 in the beginning of the method
>> ,ipq_build_packet_message().
>>
>>        2) We can reach nlmsg_failure only from one place; skb is sure to
>> be NULL
>>           when getting there; since skb is NULL, there is no need to check
>> this fact
>>           and call kfree_skb().
>>
>>        3) Add #ifdef CONFIG_PROC_FS when removing the VFS entry,
>>                 proc_net_remove(&init_net, IPQ_PROC_FS_NAME);
>>
>>
>> Regards,
>> Rami Rosen
>>
>>
>> Signed-off-by: Rami Rosen <ramirose@gmail.com>
>
> 1) also affects ip6_queue and nfnetlink_queue
> 2) also affects ip6_queue
> 3) is unnecessary since proc_net_remove is a NOP without
>   CONFIG_PROC_FS
>
> Please update your patch to also change ip6_queue and
> nfnetlink_queue where applicable. Thanks.
>
>
>

------=_Part_10188_10248701.1212405102526
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgyyjphc0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9pcHY2L25ldGZpbHRlci9pcDZfcXVldWUuYyBiL25ldC9pcHY2L25l
dGZpbHRlci9pcDZfcXVldWUuYwppbmRleCAyZWZmM2FlLi4xYjg4MTVmIDEwMDY0NAotLS0gYS9u
ZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2X3F1ZXVlLmMKKysrIGIvbmV0L2lwdjYvbmV0ZmlsdGVyL2lw
Nl9xdWV1ZS5jCkBAIC0xNTksNyArMTU5LDYgQEAgaXBxX2J1aWxkX3BhY2tldF9tZXNzYWdlKHN0
cnVjdCBuZl9xdWV1ZV9lbnRyeSAqZW50cnksIGludCAqZXJycCkKIAljYXNlIElQUV9DT1BZX01F
VEE6CiAJY2FzZSBJUFFfQ09QWV9OT05FOgogCQlzaXplID0gTkxNU0dfU1BBQ0Uoc2l6ZW9mKCpw
bXNnKSk7Ci0JCWRhdGFfbGVuID0gMDsKIAkJYnJlYWs7CiAKIAljYXNlIElQUV9DT1BZX1BBQ0tF
VDoKQEAgLTIyNiw4ICsyMjUsNiBAQCBpcHFfYnVpbGRfcGFja2V0X21lc3NhZ2Uoc3RydWN0IG5m
X3F1ZXVlX2VudHJ5ICplbnRyeSwgaW50ICplcnJwKQogCXJldHVybiBza2I7CiAKIG5sbXNnX2Zh
aWx1cmU6Ci0JaWYgKHNrYikKLQkJa2ZyZWVfc2tiKHNrYik7CiAJKmVycnAgPSAtRUlOVkFMOwog
CXByaW50ayhLRVJOX0VSUiAiaXA2X3F1ZXVlOiBlcnJvciBjcmVhdGluZyBwYWNrZXQgbWVzc2Fn
ZVxuIik7CiAJcmV0dXJuIE5VTEw7CmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mbmV0bGlu
a19xdWV1ZS5jIGIvbmV0L25ldGZpbHRlci9uZm5ldGxpbmtfcXVldWUuYwppbmRleCAzNDQ3MDI1
Li4wNGU5Yzk2IDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVyL25mbmV0bGlua19xdWV1ZS5jCisr
KyBiL25ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rX3F1ZXVlLmMKQEAgLTI0Myw3ICsyNDMsNiBAQCBu
ZnFubF9idWlsZF9wYWNrZXRfbWVzc2FnZShzdHJ1Y3QgbmZxbmxfaW5zdGFuY2UgKnF1ZXVlLAog
CXN3aXRjaCAoKGVudW0gbmZxbmxfY29uZmlnX21vZGUpcXVldWUtPmNvcHlfbW9kZSkgewogCWNh
c2UgTkZRTkxfQ09QWV9NRVRBOgogCWNhc2UgTkZRTkxfQ09QWV9OT05FOgotCQlkYXRhX2xlbiA9
IDA7CiAJCWJyZWFrOwogCiAJY2FzZSBORlFOTF9DT1BZX1BBQ0tFVDoK
------=_Part_10188_10248701.1212405102526--
