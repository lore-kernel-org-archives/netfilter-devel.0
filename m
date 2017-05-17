From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: linux-next: build failure after merge of the netfilter tree
Date: Wed, 17 May 2017 11:29:19 -0400
Message-ID: <CA+FuTScZAee2BDVn0DFdQ99bt3SoVgmUiENMHDfMyoyb-iVnKA@mail.gmail.com>
References: <20170517134536.3ce21d47@canb.auug.org.au> <CA+FuTSfKpNj6kAfEGVnE=SN-OK0+8vbFiZTr1kaHd1x+9HEYdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+FuTSfKpNj6kAfEGVnE=SN-OK0+8vbFiZTr1kaHd1x+9HEYdw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 17, 2017 at 1:02 AM, Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> On Tue, May 16, 2017 at 11:45 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the netfilter tree, today's linux-next build (i386
>> defconfig) failed like this:
>>
>> net/netfilter/x_tables.c: In function 'xt_match_to_user':
>> net/netfilter/x_tables.c:303:13: error: implicit declaration of function 'COMPAT_XT_ALIGN' [-Werror=implicit-function-declaration]
>>     C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :  \
>>              ^
>> net/netfilter/x_tables.c:310:9: note: in expansion of macro 'XT_DATA_TO_USER'
>>          XT_DATA_TO_USER(u, m, match, 0);
>>          ^
>>
>> Caused by commit
>>
>>   324318f0248c ("netfilter: xtables: zero padding in data_to_user")
>>
>> In the !CONFIG_COMPAT case C_SIZE will always be zero, but the compiler
>> is still looking for the macro :-(
>
> Apologies for the breakage.
>
>> I added this cludge patch (I am sure it can be done better):
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Wed, 17 May 2017 13:36:26 +1000
>> Subject: [PATCH] netfilter: xtables: fix for zero padding in data_to_user
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>  net/netfilter/x_tables.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
>> index d17769599c10..2b1785993a92 100644
>> --- a/net/netfilter/x_tables.c
>> +++ b/net/netfilter/x_tables.c
>> @@ -296,12 +296,20 @@ int xt_data_to_user(void __user *dst, const void *src,
>>  }
>>  EXPORT_SYMBOL_GPL(xt_data_to_user);
>>
>> +#ifdef CONFIG_COMPAT
>>  #define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)                            \
>>         xt_data_to_user(U->data, K->data,                               \
>>                         K->u.kernel.TYPE->usersize,                     \
>>                         C_SIZE ? : K->u.kernel.TYPE->TYPE##size,        \
>>                         C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :              \
>>                                  XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
>> +#else
>> +#define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)                            \
>> +       xt_data_to_user(U->data, K->data,                               \
>> +                       K->u.kernel.TYPE->usersize,                     \
>> +                       C_SIZE ? : K->u.kernel.TYPE->TYPE##size,        \
>> +                       C_SIZE ? : XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
>> +#endif
>>
>
> I will send a patch to the netfilter to define a separate
> COMPAT_XT_DATA_TO_USER inside the CONFIG_COMPAT region further down
> the file. This also allows simplifying XT_DATA_TO_USER by removing
> those ternary statements.

Full patch out for review at http://patchwork.ozlabs.org/patch/763655/
