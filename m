From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] netfilter: add overflow checks in xt_bpf.c
Date: Fri, 1 Dec 2017 05:08:56 +0100
Message-ID: <CAG48ez0QWNg5zqyxnrDnaxqfRv4umjP81CqQxrhS3i6Wxi4t9g@mail.gmail.com>
References: <20171201004607.7389-1-jannh@google.com> <CAF=yD-JRfKGjvPq4cMQADbNJc2C+0FBxAO2v=xNHKc7y-O=rJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Willem de Bruijn <willemb@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        coreteam@netfilter.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAF=yD-JRfKGjvPq4cMQADbNJc2C+0FBxAO2v=xNHKc7y-O=rJQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Dec 1, 2017 at 5:04 AM, Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> On Thu, Nov 30, 2017 at 7:46 PM, Jann Horn <jannh@google.com> wrote:
>> Check whether inputs from userspace are too long (explicit length field too
>> big or string not null-terminated) to avoid out-of-bounds reads.
>>
>> As far as I can tell, this can at worst lead to very limited kernel heap
>> memory disclosure or oopses.
>>
>> This bug can be triggered by an unprivileged user even if the xt_bpf module
>> is not loaded: iptables is available in network namespaces, and the xt_bpf
>> module can be autoloaded.
>>
>> Triggering the bug with a classic BPF filter with fake length 0x1000 causes
>> the following KASAN report:
>>
>> ==================================================================
>> BUG: KASAN: slab-out-of-bounds in bpf_prog_create+0x84/0xf0
>> Read of size 32768 at addr ffff8801eff2c494 by task test/4627
>>
>> CPU: 0 PID: 4627 Comm: test Not tainted 4.15.0-rc1+ #1
>> [...]
>> Call Trace:
>>  dump_stack+0x5c/0x85
>>  print_address_description+0x6a/0x260
>>  kasan_report+0x254/0x370
>>  ? bpf_prog_create+0x84/0xf0
>>  memcpy+0x1f/0x50
>>  bpf_prog_create+0x84/0xf0
>>  bpf_mt_check+0x90/0xd6 [xt_bpf]
>> [...]
>> Allocated by task 4627:
>>  kasan_kmalloc+0xa0/0xd0
>>  __kmalloc_node+0x47/0x60
>>  xt_alloc_table_info+0x41/0x70 [x_tables]
>> [...]
>> The buggy address belongs to the object at ffff8801eff2c3c0
>>                 which belongs to the cache kmalloc-2048 of size 2048
>> The buggy address is located 212 bytes inside of
>>                 2048-byte region [ffff8801eff2c3c0, ffff8801eff2cbc0)
>> [...]
>> ==================================================================
>>
>> Fixes: e6f30c731718 ("netfilter: x_tables: add xt_bpf match")
>> Signed-off-by: Jann Horn <jannh@google.com>
>> ---
>>  net/netfilter/xt_bpf.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/net/netfilter/xt_bpf.c b/net/netfilter/xt_bpf.c
>> index 041da0d9c06f..1f7fbd3c7e5a 100644
>> --- a/net/netfilter/xt_bpf.c
>> +++ b/net/netfilter/xt_bpf.c
>> @@ -27,6 +27,9 @@ static int __bpf_mt_check_bytecode(struct sock_filter *insns, __u16 len,
>>  {
>>         struct sock_fprog_kern program;
>>
>> +       if (len > XT_BPF_MAX_NUM_INSTR)
>> +               return -EINVAL;
>> +
>>         program.len = len;
>>         program.filter = insns;
>
> Next, this calls bpf_prog_create, which calls bpf_check_basics_ok to verify len.

Irrelevant:

 - see the KASAN splat in the commit message
 - bpf_check_basics_ok checks against BPF_MAXINSNS (4096), but a check against
   XT_BPF_MAX_NUM_INSTR (64) is needed because that's the size of the
member in the
   input struct
