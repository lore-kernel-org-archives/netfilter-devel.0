From: Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH] utils: bpf_compile
Date: Wed, 20 Feb 2013 23:35:34 -0500
Message-ID: <CA+FuTScKuNMZ5rfGJ9r_h1mgDeZ76NwA6hgsqrSvaCzJza+Lxg@mail.gmail.com>
References: <20130123185620.GA6251@1984> <1361159041-9783-1-git-send-email-willemb@google.com>
 <5124A795.6090504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51693 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3BUEgE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2013 23:36:04 -0500
Received: by mail-ie0-f177.google.com with SMTP id 16so10509096iea.8
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2013 20:36:04 -0800 (PST)
In-Reply-To: <5124A795.6090504@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 20, 2013 at 5:38 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 02/18/2013 04:44 AM, Willem de Bruijn wrote:
>>
>> A BPF compiler to convert tcpudmp expressions to the decimal format
>> accepted
>> by the libxt_bpf.
>
>
> [...]
>
>
>> --- /dev/null
>> +++ b/utils/bpf_compile.c
>> @@ -0,0 +1,55 @@
>> +/*
>> + * BPF program compilation tool
>> + *
>> + * Generates decimal output, similar to `tcpdump -ddd ...`.
>> + * Unlike tcpdump, will generate for any given link layer type.
>> + *
>> + * There is no makefile:
>> + * compile with `gcc -Wall -o bpf2decimal bpf2decimal.c -lpcap` or
>> similar.
>> + *
>> + * Written by Willem de Bruijn (willemb@google.com)
>> + * Copyright Google, Inc. 2013
>> + * Licensed under the GNU General Public License version 2 (GPLv2)
>> +*/
>> +
>> +#include <pcap.h>
>> +#include <stdio.h>
>> +
>> +int main(int argc, char **argv)
>> +{
>> +       struct bpf_program program;
>> +       struct bpf_insn *ins;
>> +       int i, dlt = DLT_RAW;
>> +
>> +       if (argc < 2 || argc > 3) {
>> +               fprintf(stderr, "Usage:    %s [link] '<program>'\n\n"
>> +                               "          link is a pcap linklayer
>> type:\n"
>> +                               "          one of EN10MB, RAW, SLIP,
>> ...\n\n"
>> +                               "Examples: %s RAW 'tcp and greater 100'\n"
>> +                               "          %s EN10MB 'ip proto 47'\n'",
>> +                               argv[0], argv[0], argv[0]);
>> +               return 1;
>> +       }
>> +
>> +       if (argc == 3) {
>> +               dlt = pcap_datalink_name_to_val(argv[1]);
>> +               if (dlt == -1) {
>> +                       fprintf(stderr, "Unknown datalinktype: %s\n",
>> argv[1]);
>> +                       return 1;
>> +               }
>> +       }
>> +
>> +       if (pcap_compile_nopcap(65535, dlt, &program, argv[argc - 1], 1,
>> +                               PCAP_NETMASK_UNKNOWN)) {
>> +               fprintf(stderr, "Compilation error\n");
>> +               return 1;
>> +       }
>> +
>> +       printf("%d\n", program.bf_len);
>> +       ins = program.bf_insns;
>> +       for (i = 0; i < program.bf_len; ++ins, ++i)
>> +               printf("%u %u %u %u\n", ins->code, ins->jt, ins->jf,
>> ins->k);
>
>
> Here I think you should release the internally allocated memory by adding a:
>
>         pcap_freecode(&program);

Thanks for catching that, Daniel. I'll hold off respinning the patch
to see if there is other feedback, but will fix this in the next
revision.

>
>> +       return 0;
>> +}
>> +
>>
>
