Received: from mail.jubileegroup.co.uk (host-83-67-166-33.static.as9105.net [83.67.166.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E48622578E
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 09:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.67.166.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741772913; cv=none; b=d0dYTM/zMwKZtEN8ALPT8wQw1bR36Im3I4kItfDMdX2fnrbPQ2e1veFD4dqxDEScSTOGgOpNf0UNIS/WL4n5C1mXtzZFWwMU5uu9KP/dBh6wBVL/YwB7vUL7siT6LFwO+I/RMRDDQr4+IyUmC9j4YgAvUWsnU71gxcxkrMIjdEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741772913; c=relaxed/simple;
	bh=ZoVASWjnB3FVD7BypNG2Y+Sy7KKnW852y9b6+qgtEC0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qZNk0Pqfamo9v7zptcsJMsss1dtldtlJHlZi7Bg0zyNwUny1ZD2BcQxRkStPVusPKjMB3yFMyjcJaPuZeRHkyq8/KEwwTCGpTcyK2y72IVPOPGdix0o8Nv9FUSorQCVetB2F3NGEI51eh+9W4kVbD05lrSlWWxrer6RT5A7b34M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk; spf=pass smtp.mailfrom=jubileegroup.co.uk; dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b=KV0p1+7B; arc=none smtp.client-ip=83.67.166.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b="KV0p1+7B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	jubileegroup.co.uk; h=date:from:to:cc:subject:in-reply-to
	:message-id:references:mime-version:content-type; s=uk; bh=2CzS2
	JehO6sFcgTF50fRxuc8aisQVduGBsC32l5gbgc=; b=KV0p1+7BJnu+xRUjYgmNl
	YcTcqB7rcjFPr1I4uLkwyYd4ioWRr40e8w6ZPw0v1RSPsSRKgNJrBzTH6tAgosRN
	6LSRDuVlHObhQIcDYNaUDSjv4oOfL7Zj6XNhnMOSFA/i8G/0L9JB3SR9muQO69FW
	nvtBbcLlx25mys+/lhPgEcs9w4UqFq6qQaRFDQwMBjt6yw4ZTLkUdQ2t7FsMWbKR
	Waxz0WTUBA8KZkEFNKfHNZk6ZgMn1/ORA1+54F8bD8y60F3ihBlqS0xHZ4jbP8i3
	mv0zQcq8B436T1tsZYY6ptHDKDGwq7KNfphZNTR/vk4LSAqWc9Lz9TKBl4X1Ztdi
	g==
Received: from piplus.local.jubileegroup.co.uk (piplus.local.jubileegroup.co.uk [192.168.44.5])
	by mail6.jubileegroup.co.uk (8.16.0.48/8.15.2/Debian-14~deb10u1) with ESMTPS id 52C9m0Du031148
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 12 Mar 2025 09:48:11 GMT
Date: Wed, 12 Mar 2025 09:48:00 +0000 (GMT)
From: "G.W. Haywood" <ged@jubileegroup.co.uk>
To: Duncan Roe <duncan_roe@optusnet.com.au>
cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation oddity.
In-Reply-To: <Z9EoA1g/USRbSufZ@slk15.local.net>
Message-ID: <e0ebeec6-7b3b-c976-734e-9f2bbecaa6a@jubileegroup.co.uk>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk> <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu> <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk> <Z899IF0jLhUMQLE4@slk15.local.net> <99edfdb-3c85-3cce-dcc3-6e61c6268a77@jubileegroup.co.uk>
 <Z9EoA1g/USRbSufZ@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463810772-1637324354-1741772896=:3645"
X-AS-Number: AS0 ([] [--] [192.168.44.5])
X-Greylist-Delay: WHITELISTED Local IP, transport not delayed by extensible-milter-7.178s

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463810772-1637324354-1741772896=:3645
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Duncan,

On Wed, 12 Mar 2025, Duncan Roe wrote:
> On Tue, Mar 11, 2025 at 10:00:04AM +0000, G.W. Haywood wrote:
>>
>> Debian 11, gcc version 10.2.1-6 here.
>>
>> 8<----------------------------------------------------------------------
>> $ gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
>> /usr/bin/ld: /tmp/ccbLJv89.o: in function `nfq_send_verdict':
>> /home/ged/nf-queue.c:30: undefined reference to `nfq_nlmsg_put'
>> ...
>> ...
>> collect2: error: ld returned 1 exit status
>> 8<----------------------------------------------------------------------
>>
> nf-queue.c has compiled fine.

Quite so, but it hasn't linked and no executable has been produced... :/

However, with the object and source file args at the beginning of the
command line, there are no linker errors and the executable is produced.

> There is a problem with the shared libraries libmnl.so and
> libnetfilter_queue.so. Those 2 libraries should satisfy the mnl_ and nfq_
> references respectively.

Obviously I do have them installed.

> On my (Slackware x86_64) system, "nm -D /usr/lib64/libmnl.so|grep -Ew T" gives:
> | 0000000000003687 T mnl_attr_get_len@@LIBMNL_1.0
> | 00000000000036ac T mnl_attr_get_payload@@LIBMNL_1.0
> | 0000000000003698 T mnl_attr_get_payload_len@@LIBMNL_1.0
> | ...
> for a total of 68 lines. What do you get? (you may have to put /usr/lib instead
> of /usr/lib64).

The libraries are in /usr/lib/aarch64-linux-gnu/, and yes, 68 lines output:

8<----------------------------------------------------------------------

$ nm -D /usr/lib/aarch64-linux-gnu/libmnl.so|grep -Ew T | head
0000000000002ad8 T mnl_attr_get_len@@LIBMNL_1.0
0000000000002af0 T mnl_attr_get_payload@@LIBMNL_1.0
0000000000002ae0 T mnl_attr_get_payload_len@@LIBMNL_1.0
0000000000002f20 T mnl_attr_get_str@@LIBMNL_1.0
0000000000002ac8 T mnl_attr_get_type@@LIBMNL_1.0
0000000000002ed8 T mnl_attr_get_u16@@LIBMNL_1.0
0000000000002ef0 T mnl_attr_get_u32@@LIBMNL_1.0
0000000000002f08 T mnl_attr_get_u64@@LIBMNL_1.0
0000000000002ec0 T mnl_attr_get_u8@@LIBMNL_1.0
00000000000032a0 T mnl_attr_nest_cancel@@LIBMNL_1.0
0000000000003278 T mnl_attr_nest_end@@LIBMNL_1.0
00000000000030a8 T mnl_attr_nest_start@@LIBMNL_1.0
0000000000003250 T mnl_attr_nest_start_check@@LIBMNL_1.0
0000000000002c30 T mnl_attr_next@@LIBMNL_1.0
0000000000002c00 T mnl_attr_ok@@LIBMNL_1.0
0000000000002d08 T mnl_attr_parse@@LIBMNL_1.0
0000000000002da0 T mnl_attr_parse_nested@@LIBMNL_1.0
0000000000002e40 T mnl_attr_parse_payload@@LIBMNL_1.1
0000000000002f28 T mnl_attr_put@@LIBMNL_1.0
00000000000030e0 T mnl_attr_put_check@@LIBMNL_1.0
0000000000003018 T mnl_attr_put_str@@LIBMNL_1.0
00000000000031b0 T mnl_attr_put_str_check@@LIBMNL_1.0
0000000000003060 T mnl_attr_put_strz@@LIBMNL_1.0
0000000000003200 T mnl_attr_put_strz_check@@LIBMNL_1.0
0000000000002fb8 T mnl_attr_put_u16@@LIBMNL_1.0
0000000000003150 T mnl_attr_put_u16_check@@LIBMNL_1.0
0000000000002fd8 T mnl_attr_put_u32@@LIBMNL_1.0
0000000000003170 T mnl_attr_put_u32_check@@LIBMNL_1.0
0000000000002ff8 T mnl_attr_put_u64@@LIBMNL_1.0
0000000000003190 T mnl_attr_put_u64_check@@LIBMNL_1.0
0000000000002f98 T mnl_attr_put_u8@@LIBMNL_1.0
0000000000003130 T mnl_attr_put_u8_check@@LIBMNL_1.0
0000000000002c48 T mnl_attr_type_valid@@LIBMNL_1.0
0000000000002c98 T mnl_attr_validate@@LIBMNL_1.0
0000000000002cd8 T mnl_attr_validate2@@LIBMNL_1.0
00000000000022f8 T mnl_cb_run@@LIBMNL_1.0
0000000000002168 T mnl_cb_run2@@LIBMNL_1.0
0000000000002ab0 T mnl_nlmsg_batch_current@@LIBMNL_1.0
0000000000002aa8 T mnl_nlmsg_batch_head@@LIBMNL_1.0
0000000000002ab8 T mnl_nlmsg_batch_is_empty@@LIBMNL_1.0
00000000000029f8 T mnl_nlmsg_batch_next@@LIBMNL_1.0
0000000000002a40 T mnl_nlmsg_batch_reset@@LIBMNL_1.0
0000000000002aa0 T mnl_nlmsg_batch_size@@LIBMNL_1.0
00000000000029b8 T mnl_nlmsg_batch_start@@LIBMNL_1.0
00000000000029f0 T mnl_nlmsg_batch_stop@@LIBMNL_1.0
0000000000002590 T mnl_nlmsg_fprintf@@LIBMNL_1.0
00000000000024c8 T mnl_nlmsg_get_payload@@LIBMNL_1.0
0000000000002470 T mnl_nlmsg_get_payload_len@@LIBMNL_1.0
00000000000024d0 T mnl_nlmsg_get_payload_offset@@LIBMNL_1.0
0000000000002548 T mnl_nlmsg_get_payload_tail@@LIBMNL_1.0
0000000000002518 T mnl_nlmsg_next@@LIBMNL_1.0
00000000000024e8 T mnl_nlmsg_ok@@LIBMNL_1.0
0000000000002578 T mnl_nlmsg_portid_ok@@LIBMNL_1.0
0000000000002490 T mnl_nlmsg_put_extra_header@@LIBMNL_1.0
0000000000002480 T mnl_nlmsg_put_header@@LIBMNL_1.0
0000000000002560 T mnl_nlmsg_seq_ok@@LIBMNL_1.0
0000000000002468 T mnl_nlmsg_size@@LIBMNL_1.0
0000000000001ec0 T mnl_socket_bind@@LIBMNL_1.0
0000000000002068 T mnl_socket_close@@LIBMNL_1.0
0000000000001e18 T mnl_socket_fdopen@@LIBMNL_1.2
0000000000001df8 T mnl_socket_get_fd@@LIBMNL_1.0
0000000000001e00 T mnl_socket_get_portid@@LIBMNL_1.0
00000000000020c0 T mnl_socket_getsockopt@@LIBMNL_1.0
0000000000001e08 T mnl_socket_open@@LIBMNL_1.0
0000000000001e10 T mnl_socket_open2@@LIBMNL_1.2
0000000000001fa0 T mnl_socket_recvfrom@@LIBMNL_1.0
0000000000001f88 T mnl_socket_sendto@@LIBMNL_1.0
00000000000020a0 T mnl_socket_setsockopt@@LIBMNL_1.0
$

8<----------------------------------------------------------------------

>> There were other problems when I tried the same thing on x86, but that
>> was gcc version 8, so I think they can be ignored.
>
> gcc-8 should be fine. Please document these problems also.

8<----------------------------------------------------------------------

# uname -a
Linux laptop3 4.19.0-27-amd64 #1 SMP Debian 4.19.316-1 (2024-06-25) x86_64 GNU/Linux
# apt-get install libmnl-dev libmnl0 libnetfilter-queue-dev libnetfilter-queue1 libnftnl11 libnftnl-dev
Reading package lists... Done
Building dependency tree 
Reading state information... Done
libmnl-dev is already the newest version (1.0.4-2).
libmnl0 is already the newest version (1.0.4-2).
libnetfilter-queue-dev is already the newest version (1.0.3-1).
libnetfilter-queue1 is already the newest version (1.0.3-1).
libnftnl-dev is already the newest version (1.1.2-2).
libnftnl11 is already the newest version (1.1.2-2).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
#

8<----------------------------------------------------------------------

8<----------------------------------------------------------------------

$ gcc -g3 -gdwarf-4 -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
nf-queue.c: In function ¡nfq_send_verdict¢:
nf-queue.c:30:8: warning: implicit declaration of function ¡nfq_nlmsg_put¢; did you mean ¡nfq_nlmsg_parse¢? [-Wimplicit-function-declaration]
   nlh = nfq_nlmsg_put(buf, NFQNL_MSG_VERDICT, queue_num);
         ^~~~~~~~~~~~~
         nfq_nlmsg_parse
nf-queue.c:30:6: warning: assignment to ¡struct nlmsghdr *¢ from ¡int¢ makes pointer from integer without a cast [-Wint-conversion]
   nlh = nfq_nlmsg_put(buf, NFQNL_MSG_VERDICT, queue_num);
       ^
nf-queue.c: In function ¡main¢:
nf-queue.c:184:6: warning: assignment to ¡struct nlmsghdr *¢ from ¡int¢ makes pointer from integer without a cast [-Wint-conversion]
   nlh = nfq_nlmsg_put(buf, NFQNL_MSG_CONFIG, queue_num);
       ^
nf-queue.c:195:6: warning: assignment to ¡struct nlmsghdr *¢ from ¡int¢ makes pointer from integer without a cast [-Wint-conversion]
   nlh = nfq_nlmsg_put(buf, NFQNL_MSG_CONFIG, queue_num);
       ^
/usr/bin/ld: /tmp/cc2fCm9v.o: in function `nfq_send_verdict':
/home/ged/Downloads/src/net/netfilter/nf-queue.c:30: undefined reference to `nfq_nlmsg_put'
/usr/bin/ld: /tmp/cc2fCm9v.o: in function `main':
/home/ged/Downloads/src/net/netfilter/nf-queue.c:184: undefined reference to `nfq_nlmsg_put'
/usr/bin/ld: /home/ged/Downloads/src/net/netfilter/nf-queue.c:195: undefined reference to `nfq_nlmsg_put'
collect2: error: ld returned 1 exit status
$

8<----------------------------------------------------------------------

Changing the order of command line options doesn't seem to help.

8<----------------------------------------------------------------------

$ nm -D /usr/lib/x86_64-linux-gnu/libmnl.so|grep -Ew T
0000000000002f20 T mnl_attr_get_len
0000000000002fa0 T mnl_attr_get_payload
0000000000002f60 T mnl_attr_get_payload_len
0000000000003560 T mnl_attr_get_str
0000000000002ee0 T mnl_attr_get_type
00000000000034a0 T mnl_attr_get_u16
00000000000034e0 T mnl_attr_get_u32
0000000000003520 T mnl_attr_get_u64
0000000000003460 T mnl_attr_get_u8
0000000000003b80 T mnl_attr_nest_cancel
0000000000003b40 T mnl_attr_nest_end
0000000000003820 T mnl_attr_nest_start
0000000000003ae0 T mnl_attr_nest_start_check
0000000000003110 T mnl_attr_next
00000000000030c0 T mnl_attr_ok
0000000000003290 T mnl_attr_parse
0000000000003330 T mnl_attr_parse_nested
00000000000033e0 T mnl_attr_parse_payload
00000000000035a0 T mnl_attr_put
0000000000003870 T mnl_attr_put_check
0000000000003760 T mnl_attr_put_str
0000000000003a10 T mnl_attr_put_str_check
00000000000037c0 T mnl_attr_put_strz
0000000000003a70 T mnl_attr_put_strz_check
0000000000003670 T mnl_attr_put_u16
0000000000003920 T mnl_attr_put_u16_check
00000000000036c0 T mnl_attr_put_u32
0000000000003970 T mnl_attr_put_u32_check
0000000000003710 T mnl_attr_put_u64
00000000000039c0 T mnl_attr_put_u64_check
0000000000003620 T mnl_attr_put_u8
00000000000038d0 T mnl_attr_put_u8_check
0000000000003150 T mnl_attr_type_valid
00000000000031b0 T mnl_attr_validate
0000000000003220 T mnl_attr_validate2
0000000000002390 T mnl_cb_run
0000000000002200 T mnl_cb_run2
0000000000002e60 T mnl_nlmsg_batch_current
0000000000002e20 T mnl_nlmsg_batch_head
0000000000002ea0 T mnl_nlmsg_batch_is_empty
0000000000002d00 T mnl_nlmsg_batch_next
0000000000002d60 T mnl_nlmsg_batch_reset
0000000000002de0 T mnl_nlmsg_batch_size
0000000000002c60 T mnl_nlmsg_batch_start
0000000000002cc0 T mnl_nlmsg_batch_stop
0000000000002800 T mnl_nlmsg_fprintf
0000000000002600 T mnl_nlmsg_get_payload
0000000000002510 T mnl_nlmsg_get_payload_len
0000000000002640 T mnl_nlmsg_get_payload_offset
0000000000002720 T mnl_nlmsg_get_payload_tail
00000000000026d0 T mnl_nlmsg_next
0000000000002680 T mnl_nlmsg_ok
00000000000027b0 T mnl_nlmsg_portid_ok
00000000000025a0 T mnl_nlmsg_put_extra_header
0000000000002550 T mnl_nlmsg_put_header
0000000000002760 T mnl_nlmsg_seq_ok
00000000000024d0 T mnl_nlmsg_size
0000000000001e50 T mnl_socket_bind
0000000000002010 T mnl_socket_close
0000000000001dc0 T mnl_socket_fdopen
0000000000001cd0 T mnl_socket_get_fd
0000000000001d00 T mnl_socket_get_portid
00000000000020b0 T mnl_socket_getsockopt
0000000000001d40 T mnl_socket_open
0000000000001d80 T mnl_socket_open2
0000000000001f40 T mnl_socket_recvfrom
0000000000001ef0 T mnl_socket_sendto
0000000000002060 T mnl_socket_setsockopt
$

8<----------------------------------------------------------------------

Thanks for being interested. :)

-- 

73,
Ged.
---1463810772-1637324354-1741772896=:3645--
