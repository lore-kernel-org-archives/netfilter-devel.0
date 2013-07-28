From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [iptables-nftables PATCH 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Sun, 28 Jul 2013 11:34:22 +0200
Message-ID: <CAFpD06Q8JTHwAqiVFLb7p9v=eWUN_Y4bgAJm5D7b3f1D0T4aNg@mail.gmail.com>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
	<1374836719-27596-3-git-send-email-giuseppelng@gmail.com>
	<20130726145902.GA28833@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:43873 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3G1JeX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Jul 2013 05:34:23 -0400
Received: by mail-vb0-f53.google.com with SMTP id p12so2174162vbe.12
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Jul 2013 02:34:22 -0700 (PDT)
In-Reply-To: <20130726145902.GA28833@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2013/7/26 Pablo Neira Ayuso <pablo@netfilter.org>:
> Hi Giuseppe,
>
> On Fri, Jul 26, 2013 at 01:05:17PM +0200, Giuseppe Longo wrote:
> [...]
>> diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
>> index b7cf609..d61b762 100644
>> --- a/iptables/xtables-config.c
>> +++ b/iptables/xtables-config.c
>> @@ -15,6 +15,7 @@
>>  #include <stdbool.h>
>>  #include <string.h>
>>  #include <errno.h>
>> +#include <libmnl/libmnl.h>
>>
>>  #include "xtables-multi.h"
>>  #include "nft.h"
>> @@ -35,11 +36,17 @@ int xtables_config_main(int argc, char *argv[])
>>       else
>>               filename = argv[1];
>>
>> -     if (nft_init(&h, xtables_ipv4) < 0) {
>> -                fprintf(stderr, "Failed to initialize nft: %s\n",
>> -                     strerror(errno));
>> -             return EXIT_FAILURE;
>> +     h.nl = mnl_socket_open(NETLINK_NETFILTER);
>> +     if (h.nl == NULL) {
>> +             perror("mnl_socket_open");
>> +             return -1;
>>       }
>> +     if (mnl_socket_bind(h.nl, 0, MNL_SOCKET_AUTOPID) < 0) {
>> +             perror("mnl_socket_bind");
>> +             return -1;
>> +     }
>> +     h.portid = mnl_socket_get_portid(h.nl);
>> +     h.tables = xtables_ipv4;
>
> Hm, why do we need this here?

The idea is to initialize nft_handle h without nft_init and after load
the file, otherwise using nft_init the file is load 2 times. (First in
nft_init and after with nft_xtables_config_load).

This should make code more cleaner.

Regards
