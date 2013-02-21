From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] utils: bpf_compile
Date: Thu, 21 Feb 2013 14:43:34 +0100
Message-ID: <51262486.40905@redhat.com>
References: <20130123185620.GA6251@1984> <1361159041-9783-1-git-send-email-willemb@google.com> <5124A795.6090504@redhat.com> <CA+FuTScKuNMZ5rfGJ9r_h1mgDeZ76NwA6hgsqrSvaCzJza+Lxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3BUNoW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:44:22 -0500
In-Reply-To: <CA+FuTScKuNMZ5rfGJ9r_h1mgDeZ76NwA6hgsqrSvaCzJza+Lxg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/21/2013 05:35 AM, Willem de Bruijn wrote:
> On Wed, Feb 20, 2013 at 5:38 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
>> On 02/18/2013 04:44 AM, Willem de Bruijn wrote:
>>>
>>> A BPF compiler to convert tcpudmp expressions to the decimal format
>>> accepted
>>> by the libxt_bpf.
>>
>> [...]
>>
>>> --- /dev/null
>>> +++ b/utils/bpf_compile.c
>>> @@ -0,0 +1,55 @@
>>> +/*
>>> + * BPF program compilation tool
>>> + *
>>> + * Generates decimal output, similar to `tcpdump -ddd ...`.
>>> + * Unlike tcpdump, will generate for any given link layer type.
>>> + *
>>> + * There is no makefile:
>>> + * compile with `gcc -Wall -o bpf2decimal bpf2decimal.c -lpcap` or
>>> similar.
>>> + *
>>> + * Written by Willem de Bruijn (willemb@google.com)
>>> + * Copyright Google, Inc. 2013
>>> + * Licensed under the GNU General Public License version 2 (GPLv2)
>>> +*/
>>> +
>>> +#include <pcap.h>
>>> +#include <stdio.h>
>>> +
>>> +int main(int argc, char **argv)
>>> +{
>>> +       struct bpf_program program;
>>> +       struct bpf_insn *ins;
>>> +       int i, dlt = DLT_RAW;
>>> +
>>> +       if (argc < 2 || argc > 3) {
>>> +               fprintf(stderr, "Usage:    %s [link] '<program>'\n\n"
>>> +                               "          link is a pcap linklayer
>>> type:\n"
>>> +                               "          one of EN10MB, RAW, SLIP,
>>> ...\n\n"
>>> +                               "Examples: %s RAW 'tcp and greater 100'\n"
>>> +                               "          %s EN10MB 'ip proto 47'\n'",
>>> +                               argv[0], argv[0], argv[0]);
>>> +               return 1;
>>> +       }
>>> +
>>> +       if (argc == 3) {
>>> +               dlt = pcap_datalink_name_to_val(argv[1]);
>>> +               if (dlt == -1) {
>>> +                       fprintf(stderr, "Unknown datalinktype: %s\n",
>>> argv[1]);
>>> +                       return 1;
>>> +               }
>>> +       }
>>> +
>>> +       if (pcap_compile_nopcap(65535, dlt, &program, argv[argc - 1], 1,
>>> +                               PCAP_NETMASK_UNKNOWN)) {
>>> +               fprintf(stderr, "Compilation error\n");
>>> +               return 1;
>>> +       }
>>> +
>>> +       printf("%d\n", program.bf_len);
>>> +       ins = program.bf_insns;
>>> +       for (i = 0; i < program.bf_len; ++ins, ++i)
>>> +               printf("%u %u %u %u\n", ins->code, ins->jt, ins->jf,
>>> ins->k);
>>
>>
>> Here I think you should release the internally allocated memory by adding a:
>>
>>          pcap_freecode(&program);
>
> Thanks for catching that, Daniel. I'll hold off respinning the patch
> to see if there is other feedback, but will fix this in the next
> revision.

Thanks, otherwise I think the user space utility looks good.

I've also just added support for this output format into bpfc
(netsniff-ng Git tree), in case low-level filter devel/debugging
is needed, e.g. bpfc -Di <file>.
