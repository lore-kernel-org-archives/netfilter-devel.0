Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0458C43334
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jun 2022 13:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243393AbiFCNLL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jun 2022 09:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiFCNLK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jun 2022 09:11:10 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a11:7980:3::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7522F017
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jun 2022 06:11:06 -0700 (PDT)
Message-ID: <ed67442e-883c-fd20-5641-c053fa315e78@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1654261863;
        bh=Ejmb4Z0Kvwwho303WUu7+5ARVcsLCuKAfRQw+/bgw0Q=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=vw/nMADIMGKT8/YzBz99lStb01pgMsghg103MV4Tf/slFYDSPHeUrOHphbcSoewDN
         Zn4jBRQW145FZsBXgT2PmDFIiy2NGpD7dGYhw+e1xdroUh8kB6/AdvE9XhaAc3T/q0
         Q3FGTzdT126F37HZjl2AEkXCnpk+F+8MTN8nJCyShdA3AWsy9fPGTpT9r7MObLqm2F
         gez9VN0rbK2MReJrslD4H0ODUkporQjwg79wsK3FQC/WIK0Ol4V6IWqvLtTJaalrUr
         DjKqDXZQGd50bWY3+s6/d4kqXsEdXi+0YXAADkjbHUDJNBRYWijuNZpoNAXGuJK+ip
         dHDbtu+jMUenA==
Date:   Fri, 3 Jun 2022 15:10:45 +0200
MIME-Version: 1.0
Subject: Re: [iptables PATCH] libxtables: Unexport init_extensions*()
 declarations
Content-Language: en-US
From:   Nick <vincent@systemli.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20220602182412.4630-1-phil@nwl.cc>
 <eab33b47-5d3a-f1b8-45e6-d0025d9acf76@systemli.org>
In-Reply-To: <eab33b47-5d3a-f1b8-45e6-d0025d9acf76@systemli.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The patch works for me. Thanks.

Bests
Nick

On 6/3/22 07:08, Nick wrote:
> Thanks. You can also put my whole Name: Nick Hainke 
> <vincent@systemli.org>.
> I will test it again. :) I had a longer discussion with another 
> OpenWrt member, why everything is done in OpenWrt as it is. Not sure 
> what will happen in future with firewall3.
>
> Bests
> Nick
>
> On 6/2/22 20:24, Phil Sutter wrote:
>> The functions are used for static builds to initialize extensions after
>> libxtables init. Regular library users should not need them, but the
>> empty declarations introduced in #else case (and therefore present in
>> user's env) may clash with existing symbol names.
>>
>> Avoid problems and guard the whole block declaring the function
>> prototypes and mangling extensions' _init functions by XTABLES_INTERNAL.
>>
>> Reported-by: Nick <vincent@systemli.org>
>> Fixes: 6c689b639cf8e ("Simplify static build extension loading")
>> Signed-off-by: Phil Sutter <phil@nwl.cc>
>> ---
>>   include/xtables.h | 44 ++++++++++++++++++++++----------------------
>>   1 file changed, 22 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/xtables.h b/include/xtables.h
>> index c2694b7b28886..f1937f3ea0530 100644
>> --- a/include/xtables.h
>> +++ b/include/xtables.h
>> @@ -585,27 +585,6 @@ static inline void 
>> xtables_print_mark_mask(unsigned int mark,
>>       xtables_print_val_mask(mark, mask, NULL);
>>   }
>>   -#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
>> -#    ifdef _INIT
>> -#        undef _init
>> -#        define _init _INIT
>> -#    endif
>> -    extern void init_extensions(void);
>> -    extern void init_extensions4(void);
>> -    extern void init_extensions6(void);
>> -    extern void init_extensionsa(void);
>> -    extern void init_extensionsb(void);
>> -#else
>> -#    define _init __attribute__((constructor)) _INIT
>> -#    define EMPTY_FUNC_DEF(x) static inline void x(void) {}
>> -    EMPTY_FUNC_DEF(init_extensions)
>> -    EMPTY_FUNC_DEF(init_extensions4)
>> -    EMPTY_FUNC_DEF(init_extensions6)
>> -    EMPTY_FUNC_DEF(init_extensionsa)
>> -    EMPTY_FUNC_DEF(init_extensionsb)
>> -#    undef EMPTY_FUNC_DEF
>> -#endif
>> -
>>   extern const struct xtables_pprot xtables_chain_protos[];
>>   extern uint16_t xtables_parse_protocol(const char *s);
>>   @@ -663,9 +642,30 @@ void xtables_announce_chain(const char *name);
>>   #        define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
>>   #    endif
>>   +#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
>> +#    ifdef _INIT
>> +#        undef _init
>> +#        define _init _INIT
>> +#    endif
>> +    extern void init_extensions(void);
>> +    extern void init_extensions4(void);
>> +    extern void init_extensions6(void);
>> +    extern void init_extensionsa(void);
>> +    extern void init_extensionsb(void);
>> +#else
>> +#    define _init __attribute__((constructor)) _INIT
>> +#    define EMPTY_FUNC_DEF(x) static inline void x(void) {}
>> +    EMPTY_FUNC_DEF(init_extensions)
>> +    EMPTY_FUNC_DEF(init_extensions4)
>> +    EMPTY_FUNC_DEF(init_extensions6)
>> +    EMPTY_FUNC_DEF(init_extensionsa)
>> +    EMPTY_FUNC_DEF(init_extensionsb)
>> +#    undef EMPTY_FUNC_DEF
>> +#endif
>> +
>>   extern void _init(void);
>>   -#endif
>> +#endif /* XTABLES_INTERNAL */
>>     #ifdef __cplusplus
>>   } /* extern "C" */
