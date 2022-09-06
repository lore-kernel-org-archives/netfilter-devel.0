Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F95ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Sep 2022 08:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiIFIJQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Sep 2022 04:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238826AbiIFIJK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2022 04:09:10 -0400
X-Greylist: delayed 126 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Sep 2022 01:09:09 PDT
Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [83.166.143.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6788371BFF
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Sep 2022 01:09:09 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMJ1v4ztWzMqGRc;
        Tue,  6 Sep 2022 10:09:07 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMJ1v0Xt7zMv9LM;
        Tue,  6 Sep 2022 10:09:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451747;
        bh=ZSwetP40PNrFpKSGIDiYTynydCI507BnrECWePACzdY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cumlnFZB+fZbxMSdFjFzMlTo8vKBAqYjdZAVjtLuoYR9oKylackloBosMo9LFlG4D
         x89uriWg4Ia4xcNMqYH8OFku8YfUt9fjuamIpwHKlWQLg9KxAHOIG45ee7zrDjg5ZY
         EIgh4nV4ljuDePBoL8D/pVesWcC+KvpbcID5Mlhs=
Message-ID: <c4505758-3129-f6b9-f769-ea78c5ced4e3@digikod.net>
Date:   Tue, 6 Sep 2022 10:09:06 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 10/18] seltests/landlock: move helper function
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-11-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-11-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please be a bit more specific in the subject: "selftests/landlock: Share 
enforce_ruleset()"

BTW, as I already said, you need to replace all your "seltests" with 
"selftests".



On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> This commit moves enforce_ruleset() helper function to common.h so that
> to be used both by filesystem tests and network ones.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v6:
> * None.
> 
> Changes since v5:
> * Splits commit.
> * Moves enforce_ruleset helper into common.h
> * Formats code with clang-format-14.
> 
> ---
>   tools/testing/selftests/landlock/common.h  | 10 ++++++++++
>   tools/testing/selftests/landlock/fs_test.c | 10 ----------
>   2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
> index 7ba18eb23783..48870afb054b 100644
> --- a/tools/testing/selftests/landlock/common.h
> +++ b/tools/testing/selftests/landlock/common.h
> @@ -187,3 +187,13 @@ clear_cap(struct __test_metadata *const _metadata, const cap_value_t caps)
>   {
>   	_effective_cap(_metadata, caps, CAP_CLEAR);
>   }
> +
> +__attribute__((__unused__)) static void
> +enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
> +{
> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
> +	{
> +		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
> +	}
> +}
> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
> index debe2d9ea6cf..25a655891754 100644
> --- a/tools/testing/selftests/landlock/fs_test.c
> +++ b/tools/testing/selftests/landlock/fs_test.c
> @@ -556,16 +556,6 @@ static int create_ruleset(struct __test_metadata *const _metadata,
>   	return ruleset_fd;
>   }
> 
> -static void enforce_ruleset(struct __test_metadata *const _metadata,
> -			    const int ruleset_fd)
> -{
> -	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> -	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
> -	{
> -		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
> -	}
> -}
> -
>   TEST_F_FORK(layout1, proc_nsfs)
>   {
>   	const struct rule rules[] = {
> --
> 2.25.1
> 
