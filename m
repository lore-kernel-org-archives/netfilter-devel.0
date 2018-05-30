From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] netfilter: nfnetlink: Remove VLA usage
Date: Wed, 30 May 2018 12:08:08 -0700
Message-ID: <CAGXu5jKdB+Md-8OkG8xfzpcSgCVbVsUU4ojD++gFsz4-Q0nxeg@mail.gmail.com>
References: <20180530003525.GA18642@beast> <20180530095249.3jdhb5gdwt24cnsa@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530095249.3jdhb5gdwt24cnsa@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 30, 2018 at 2:52 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, May 29, 2018 at 05:35:25PM -0700, Kees Cook wrote:
>> In the quest to remove all stack VLA usage from the kernel[1], this
>> allocates the maximum size expected for all possible attrs and adds
>> a sanity-check to make sure nothing gets out of sync.
>>
>> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  net/netfilter/nfnetlink.c | 22 ++++++++++++++++++++--
>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
>> index 03ead8a9e90c..0cb395f9627e 100644
>> --- a/net/netfilter/nfnetlink.c
>> +++ b/net/netfilter/nfnetlink.c
>> @@ -28,6 +28,7 @@
>>
>>  #include <net/netlink.h>
>>  #include <linux/netfilter/nfnetlink.h>
>> +#include <linux/netfilter/nf_tables.h>
>>
>>  MODULE_LICENSE("GPL");
>>  MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
>> @@ -37,6 +38,11 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
>>       rcu_dereference_protected(table[(id)].subsys, \
>>                                 lockdep_nfnl_is_held((id)))
>>
>> +#define NFTA_MAX_ATTR        max(max(max(NFTA_CHAIN_MAX, NFTA_FLOWTABLE_MAX),\
>> +                             max(NFTA_OBJ_MAX, NFTA_RULE_MAX)),      \
>> +                         max(NFTA_TABLE_MAX,                         \
>> +                             max(NFTA_SET_ELEM_LIST_MAX, NFTA_SET_MAX)))
>
> This is very specific of nftables, there are other nf subsystems using
> nfnetlink that may go over this maximum attribute value (grep from
> "struct nfnetlink_subsystem").

Oops, yes. I see that now.

> To remove the VLA, I think we need an artificial maximum attribute
> that reasonably large enough.

git grep insanity:

$ for i in $(git grep -A10 'static .*struct nfnetlink_subsystem' | \
                 grep '\.cb\b' | awk '{print $NF}' | cut -d, -f1)
do git grep -A100 'static .*'"$i\b"; done | \
    grep '\.attr_count\b' | awk -F= '{print $NF}' | \
    sed -e 's/ //g' | cut -d, -f1 | sort -u

and manual counting gets me:

CTA_EXPECT_MAX 12
CTA_MAX 25
CTA_TIMEOUT_MAX 6
IPSET_ATTR_CMD_MAX 11
NFACCT_MAX 9
NFCTH_MAX 7
NFQA_CFG_MAX 6
NFQA_MAX 21
NFTA_CHAIN_MAX 10
NFTA_COMPAT_MAX 4
NFTA_OBJ_MAX 8
NFTA_RULE_MAX 10
NFTA_SET_ELEM_LIST_MAX 5
NFTA_SET_MAX 17
NFTA_TABLE_MAX 6
NFULA_CFG_MAX 7
NFULA_MAX 20
OSF_ATTR_MAX 2

How about 32?

As Florian suggested, I'll add the check in
nfnetlink_subsys_register() with a WARN().

-Kees

-- 
Kees Cook
Pixel Security
