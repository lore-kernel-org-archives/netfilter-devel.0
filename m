Received: from mail.jubileegroup.co.uk (host-83-67-166-33.static.as9105.net [83.67.166.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9536D22FAC3
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2025 10:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.67.166.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687231; cv=none; b=r6txmywBSSVWMCm/Qyq9+smQlcwmLYqFnoKZYMdK3rdXLINl4oecLMEUAPu+YB0xwlGfKcehDLM0EOskApHZNplpnEMjVa3jLdGZLsF3V444fSciYfoB83gMCh/aFy2acaVWVtcRDI2hEMWqVsz70A33dXWsipmB0yLX2U0lne8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687231; c=relaxed/simple;
	bh=45indzOarC+S2cltfpTL9JMhJl3DIz+aMeyYAo3xeo4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mO5pne8wtJzxajVvNPJ2GYvgUBrAzSLrEIrbsPhFP1KxHhsVZ7Yuf30OWrVXTCR8mJK4k2oYBV8X4OeT2tQEHqC1tzytMe7Ch5skqv34DujPSRh9lMAP6aG8vdbIdM52q8eJ2CGin9LINPXJz406mYA6Qjkra6EF6v9LVMp6mqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk; spf=pass smtp.mailfrom=jubileegroup.co.uk; dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b=KeCQYvYx; arc=none smtp.client-ip=83.67.166.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b="KeCQYvYx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	jubileegroup.co.uk; h=date:from:to:cc:subject:in-reply-to
	:message-id:references:mime-version:content-type; s=uk; bh=j9lyx
	cF6XfHlsc9az2swl/DbhMUlQaDJDFIFClzRqGY=; b=KeCQYvYx7O0+l3+nw3LNK
	7F84zRQu/QqwyWH2U8O9Ybcp7MK38e4D01I0Rc2gTCbVnoVAIg4/UcFhS3TxXLzk
	lMSEK8tubypKhUB+dmgTR7rxQSxaPzibVEZnNFV7uidc2L2kxDkApvFDzXWXvGrV
	Pp8TvbpA5DLRRspd5ZiATdwylZ14WIGNp1mnpTn4o4UN3wikkZq2BccpV5Tn+6X9
	q4kTX4e9G2dKbzA4NlilCWWQRBky2e6h70/V46RcRFRO+ST6MBYr9FXUNYsG1oFM
	c9zIhznd87XcAk4wDUn9vwvNrJ5Y5mwK1DH4gSkFQ6wWtJ/JMHbm94tCvhmBqvw/
	Q==
Received: from piplus.local.jubileegroup.co.uk (piplus.local.jubileegroup.co.uk [192.168.44.5])
	by mail6.jubileegroup.co.uk (8.16.0.48/8.15.2/Debian-14~deb10u1) with ESMTPS id 52BA04NT024344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 10:00:14 GMT
Date: Tue, 11 Mar 2025 10:00:04 +0000 (GMT)
From: "G.W. Haywood" <ged@jubileegroup.co.uk>
To: Duncan Roe <duncan_roe@optusnet.com.au>
cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation oddity.
In-Reply-To: <Z899IF0jLhUMQLE4@slk15.local.net>
Message-ID: <99edfdb-3c85-3cce-dcc3-6e61c6268a77@jubileegroup.co.uk>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk> <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu> <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk> <Z899IF0jLhUMQLE4@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-AS-Number: AS0 ([] [--] [192.168.44.5])
X-Greylist-Delay: WHITELISTED Local IP, transport not delayed by extensible-milter-7.178s

Hi Duncan,

Thanks for the reply.

On Tue, 11 Mar 2025, Duncan Roe wrote:
> On Mon, Mar 10, 2025 at 06:00:40PM +0000, G.W. Haywood wrote:
>> ...
>> In the docs at
>>
>> https://www.netfilter.org/projects/libnetfilter_queue/doxygen/html/
>>
>> there is given a command to compile the sample code in nf-queue.c.
>>
>> The command given is
>>
>> gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
>>
>> Here, and I suspect almost everywhere else, that doesn't work.
>
> Works here with gcc versions 11.2.0 and 14.2.0.

Debian 11, gcc version 10.2.1-6 here.

>> Should the command not be something more like the one below?
>>
>> gcc -o nf-queue nf-queue.c -g3 -ggdb -Wall -lmnl -lnetfilter_queue
>
> gcc doesn't care, but the conventional order for command arguments is option
> args first, as in the docs.

That's what I'd always thought - until I tried to do what it said
there, searched stackoverflow for similar issues, and found them. :/

> The -ggdb argument is obsolete and may be slated for removal. Can you please try
> this:
>
> gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c

Same problem exactly.

> If it still fails for you, please let me know at least 2 things:
>
> 1. What is the error message

8<----------------------------------------------------------------------
$ gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
/usr/bin/ld: /tmp/ccbLJv89.o: in function `nfq_send_verdict':
/home/ged/nf-queue.c:30: undefined reference to `nfq_nlmsg_put'
/usr/bin/ld: /home/ged/nf-queue.c:31: undefined reference to `nfq_nlmsg_verdict_put'
/usr/bin/ld: /home/ged/nf-queue.c:34: undefined reference to `mnl_attr_nest_start'
/usr/bin/ld: /home/ged/nf-queue.c:37: undefined reference to `mnl_attr_put_u32'
/usr/bin/ld: /home/ged/nf-queue.c:41: undefined reference to `mnl_attr_nest_end'
/usr/bin/ld: /home/ged/nf-queue.c:43: undefined reference to `mnl_socket_sendto'
/usr/bin/ld: /tmp/ccbLJv89.o: in function `queue_cb':
/home/ged/nf-queue.c:60: undefined reference to `nfq_nlmsg_parse'
/usr/bin/ld: /home/ged/nf-queue.c:65: undefined reference to `mnl_nlmsg_get_payload'
/usr/bin/ld: /home/ged/nf-queue.c:75: undefined reference to `mnl_attr_get_payload'
/usr/bin/ld: /home/ged/nf-queue.c:78: undefined reference to `mnl_attr_get_payload_len'
/usr/bin/ld: /home/ged/nf-queue.c:93: undefined reference to `mnl_attr_get_u32'
/usr/bin/ld: /home/ged/nf-queue.c:97: undefined reference to `mnl_attr_get_u32'
/usr/bin/ld: /home/ged/nf-queue.c:111: undefined reference to `mnl_attr_get_payload'
/usr/bin/ld: /tmp/ccbLJv89.o: in function `main':
/home/ged/nf-queue.c:162: undefined reference to `mnl_socket_open'
/usr/bin/ld: /home/ged/nf-queue.c:168: undefined reference to `mnl_socket_bind'
/usr/bin/ld: /home/ged/nf-queue.c:172: undefined reference to `mnl_socket_get_portid'
/usr/bin/ld: /home/ged/nf-queue.c:184: undefined reference to `nfq_nlmsg_put'
/usr/bin/ld: /home/ged/nf-queue.c:185: undefined reference to `nfq_nlmsg_cfg_put_cmd'
/usr/bin/ld: /home/ged/nf-queue.c:187: undefined reference to `mnl_socket_sendto'
/usr/bin/ld: /home/ged/nf-queue.c:195: undefined reference to `nfq_nlmsg_put'
/usr/bin/ld: /home/ged/nf-queue.c:196: undefined reference to `nfq_nlmsg_cfg_put_params'
/usr/bin/ld: /home/ged/nf-queue.c:198: undefined reference to `mnl_attr_put_u32'
/usr/bin/ld: /home/ged/nf-queue.c:199: undefined reference to `mnl_attr_put_u32'
/usr/bin/ld: /home/ged/nf-queue.c:201: undefined reference to `mnl_socket_sendto'
/usr/bin/ld: /home/ged/nf-queue.c:211: undefined reference to `mnl_socket_setsockopt'
/usr/bin/ld: /home/ged/nf-queue.c:217: undefined reference to `mnl_socket_recvfrom'
/usr/bin/ld: /home/ged/nf-queue.c:223: undefined reference to `mnl_cb_run'
collect2: error: ld returned 1 exit status
8<----------------------------------------------------------------------

8<----------------------------------------------------------------------
$ gcc -o nf-queue nf-queue.c -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue
$ 
8<----------------------------------------------------------------------

8<----------------------------------------------------------------------
$ !84038
gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
/usr/bin/ld: /tmp/ccPlG4la.o: in function `nfq_send_verdict':
/home/ged/nf-queue.c:30: undefined reference to `nfq_nlmsg_put'
/usr/bin/ld: /home/ged/nf-queue.c:31: undefined reference to `nfq_nlmsg_verdict_put'
/usr/bin/ld: /home/ged/nf-queue.c:34: undefined reference to `mnl_attr_nest_start'
/usr/bin/ld: /home/ged/nf-queue.c:37: undefined reference to `mnl_attr_put_u32'
/usr/bin/ld: /home/ged/nf-queue.c:41: undefined reference to `mnl_attr_nest_end'
/usr/bin/ld: /home/ged/nf-queue.c:43: undefined reference to `mnl_socket_sendto'
/usr/bin/ld: /tmp/ccPlG4la.o: in function `queue_cb':
/home/ged/nf-queue.c:60: undefined reference to `nfq_nlmsg_parse'
/usr/bin/ld: /home/ged/nf-queue.c:65: undefined reference to `mnl_nlmsg_get_payload'
/usr/bin/ld: /home/ged/nf-queue.c:75: undefined reference to `mnl_attr_get_payload'
/usr/bin/ld: /home/ged/nf-queue.c:78: undefined reference to `mnl_attr_get_payload_len'
/usr/bin/ld: /home/ged/nf-queue.c:93: undefined reference to `mnl_attr_get_u32'
/usr/bin/ld: /home/ged/nf-queue.c:97: undefined reference to `mnl_attr_get_u32'
/usr/bin/ld: /home/ged/nf-queue.c:111: undefined reference to `mnl_attr_get_payload'
/usr/bin/ld: /tmp/ccPlG4la.o: in function `main':
/home/ged/nf-queue.c:162: undefined reference to `mnl_socket_open'
/usr/bin/ld: /home/ged/nf-queue.c:168: undefined reference to `mnl_socket_bind'
/usr/bin/ld: /home/ged/nf-queue.c:172: undefined reference to `mnl_socket_get_portid'
/usr/bin/ld: /home/ged/nf-queue.c:184: undefined reference to `nfq_nlmsg_put'
/usr/bin/ld: /home/ged/nf-queue.c:185: undefined reference to `nfq_nlmsg_cfg_put_cmd'
/usr/bin/ld: /home/ged/nf-queue.c:187: undefined reference to `mnl_socket_sendto'
/usr/bin/ld: /home/ged/nf-queue.c:195: undefined reference to `nfq_nlmsg_put'
/usr/bin/ld: /home/ged/nf-queue.c:196: undefined reference to `nfq_nlmsg_cfg_put_params'
/usr/bin/ld: /home/ged/nf-queue.c:198: undefined reference to `mnl_attr_put_u32'
/usr/bin/ld: /home/ged/nf-queue.c:199: undefined reference to `mnl_attr_put_u32'
/usr/bin/ld: /home/ged/nf-queue.c:201: undefined reference to `mnl_socket_sendto'
/usr/bin/ld: /home/ged/nf-queue.c:211: undefined reference to `mnl_socket_setsockopt'
/usr/bin/ld: /home/ged/nf-queue.c:217: undefined reference to `mnl_socket_recvfrom'
/usr/bin/ld: /home/ged/nf-queue.c:223: undefined reference to `mnl_cb_run'
collect2: error: ld returned 1 exit status
$ 
8<----------------------------------------------------------------------

This is where I'd got to when I sent the OP:

8<----------------------------------------------------------------------
$ !84039
gcc -o nf-queue nf-queue.c -g3 -ggdb -Wall -lmnl -lnetfilter_queue
$
8<----------------------------------------------------------------------

> 2. The first line output by the command "gcc --version"

$ gcc --version | head -n1
gcc (Debian 10.2.1-6) 10.2.1 20210110

This is a raspberry Pi4B, 8GBytes, 64 bit.

8<----------------------------------------------------------------------
$ uname -a
Linux raspberrypi 6.1.21-v8+ #1642 SMP PREEMPT Mon Apr  3 17:24:16 BST 2023 aarch64 GNU/Linux
$ 
8<----------------------------------------------------------------------

There were other problems when I tried the same thing on x86, but that
was gcc version 8, so I think they can be ignored.

Thanks again.  Please note that this isn't a problem for me - it's
just me trying to get docs in order whenever I see something odd.

-- 

73,
Ged.
