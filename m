Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50BBEB64DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 18:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbjFSSTu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 14:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjFSSTt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 14:19:49 -0400
Received: from smtp-42af.mail.infomaniak.ch (smtp-42af.mail.infomaniak.ch [84.16.66.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD59AF
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 11:19:47 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QlJ2R3CbvzMpnqh;
        Mon, 19 Jun 2023 18:19:43 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QlJ2Q3thpzMq93t;
        Mon, 19 Jun 2023 20:19:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1687198783;
        bh=iWv+eVL1CNQoKwhLaN0n+7CtOdblEkckUdLFaKna81U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=yoPnSEDVyDXggBf8gvRDQoqDxoAi08gavp2OXPK8jJ68Jzcg7GVoQcdmycLnMIOyf
         1HyX7Mupk1UnE1MFrCwhRorB9NAqNRbWGcV4EL9EesLnCrjQdsRGE+s5/TsVgAt7ky
         vy1cyCrgPwMHyIKG8K0ozRSl8kjrRhpHb7o3ELX8=
Message-ID: <fb1d9351-355c-feb8-c2a2-419e24000049@digikod.net>
Date:   Mon, 19 Jun 2023 20:19:41 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 11/12] samples/landlock: Add network demo
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack@google.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-12-konstantin.meskhidze@huawei.com>
 <ZH9OFyWZ1njI7VG9@google.com>
 <d9f07165-f589-13d4-6484-1272704f1de0@huawei.com>
 <8c09fc5a-e3a5-4792-65a8-b84c6044128a@digikod.net>
 <c0713bf1-a65e-c4cd-08b9-c60bd79fc86f@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <c0713bf1-a65e-c4cd-08b9-c60bd79fc86f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 19/06/2023 16:24, Konstantin Meskhidze (A) wrote:
> 
> 
> 6/13/2023 11:38 PM, Mickaël Salaün пишет:
>>
>> On 13/06/2023 12:54, Konstantin Meskhidze (A) wrote:
>>>
>>>
>>> 6/6/2023 6:17 PM, Günther Noack пишет:
>>>> Hi Konstantin!
>>>>
>>>> Apologies if some of this was discussed before, in this case,
>>>> Mickaël's review overrules my opinions from the sidelines ;)
>>>>
>>>> On Tue, May 16, 2023 at 12:13:38AM +0800, Konstantin Meskhidze wrote:
>>>>> This commit adds network demo. It's possible to allow a sandboxer to
>>>>> bind/connect to a list of particular ports restricting network
>>>>> actions to the rest of ports.
>>>>>
>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>
>>>>
>>>>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>>>>> index e2056c8b902c..b0250edb6ccb 100644
>>>>> --- a/samples/landlock/sandboxer.c
>>>>> +++ b/samples/landlock/sandboxer.c
>>>>
>>>> ...
>>>>
>>>>> +static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>>>>> +				const __u64 allowed_access)
>>>>> +{
>>>>> +	int num_ports, i, ret = 1;
>>>>
>>>> I thought the convention was normally to set ret = 0 initially and to
>>>> override it in case of error, rather than the other way around?
>>
>> Which convention? In this case, by default the return code is an error.
>>
>>
>>>>
>>>      Well, I just followed Mickaёl's way of logic here. >
>>>
>>>>> +	char *env_port_name;
>>>>> +	struct landlock_net_service_attr net_service = {
>>>>> +		.allowed_access = allowed_access,
>>>>> +		.port = 0,
>>>>> +	};
>>>>> +
>>>>> +	env_port_name = getenv(env_var);
>>>>> +	if (!env_port_name)
>>>>> +		return 0;
>>>>> +	env_port_name = strdup(env_port_name);
>>>>> +	unsetenv(env_var);
>>>>> +	num_ports = parse_port_num(env_port_name);
>>>>> +
>>>>> +	if (num_ports == 1 && (strtok(env_port_name, ENV_PATH_TOKEN) == NULL)) {
>>>>> +		ret = 0;
>>>>> +		goto out_free_name;
>>>>> +	}
>>>>
>>>> I don't understand why parse_port_num and strtok are necessary in this
>>>> program. The man-page for strsep(3) describes it as a replacement to
>>>> strtok(3) (in the HISTORY section), and it has a very short example
>>>> for how it is used.
>>>>
>>>> Wouldn't it work like this as well?
>>>>
>>>> while ((strport = strsep(&env_port_name, ":"))) {
>>>>      net_service.port = atoi(strport);
>>>>      /* etc */
>>>> }
>>>
>>>      Thanks for a tip. I think it's a better solution here. Now this
>>> commit is in Mickaёl's -next branch. I could send a one-commit patch later.
>>> Mickaёl, what do you think?
>>
>> I removed this series from -next because there is some issues (see the
>> bot's emails), but anyway, this doesn't mean these patches don't need to
>> be changed, they do. The goal of -next is to test more widely a patch
>> series and get more feedbacks, especially from bots. When this series
>> will be fully ready (and fuzzed with syzkaller), I'll push it to Linus
>> Torvalds.
>>
>> I'll review the remaining tests and sample code this week, but you can
>> still take into account the documentation review.
> 
>    Hi, Mickaёl.
> 
>    I have a few quetions?
>     - Are you going to fix warnings for bots, meanwhile I run syzcaller?

No, you need to fix that with the next series (except the Signed-off-by 
warnings).

What is your status on syzkaller? Do you need some help? I can write the 
tests if it's too much.


>     - I will fix documentation and sandbox demo and sent patch v12?

Yes please. Let me a few days to send more reviews.

> 
>>
>>
>>>
>>>>
>>>>> +
>>>>> +	for (i = 0; i < num_ports; i++) {
>>>>> +		net_service.port = atoi(strsep(&env_port_name, ENV_PATH_TOKEN));
>>>>
>>>> Naming of ENV_PATH_TOKEN:
>>>> This usage is not related to paths, maybe rename the variable?
>>>> It's also technically not the token, but the delimiter.
>>>>
>>>     What do you think of ENV_PORT_TOKEN or ENV_PORT_DELIMITER???
>>
>> You can rename ENV_PATH_TOKEN to ENV_DELIMITER for the FS and network parts.
>>
>      Ok. Got it.
>>
>>>
>>>>> +		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>>>>> +				      &net_service, 0)) {
>>>>> +			fprintf(stderr,
>>>>> +				"Failed to update the ruleset with port \"%lld\": %s\n",
>>>>> +				net_service.port, strerror(errno));
>>>>> +			goto out_free_name;
>>>>> +		}
>>>>> +	}
>>>>> +	ret = 0;
>>>>> +
>>>>> +out_free_name:
>>>>> +	free(env_port_name);
>>>>> +	return ret;
>>>>> +}
>>>>
>>>>
>>>>>    		fprintf(stderr,
>>>>>    			"Launch a command in a restricted environment.\n\n");
>>>>> -		fprintf(stderr, "Environment variables containing paths, "
>>>>> -				"each separated by a colon:\n");
>>>>> +		fprintf(stderr,
>>>>> +			"Environment variables containing paths and ports "
>>>>> +			"each separated by a colon:\n");
>>>>>    		fprintf(stderr,
>>>>>    			"* %s: list of paths allowed to be used in a read-only way.\n",
>>>>>    			ENV_FS_RO_NAME);
>>>>>    		fprintf(stderr,
>>>>> -			"* %s: list of paths allowed to be used in a read-write way.\n",
>>>>> +			"* %s: list of paths allowed to be used in a read-write way.\n\n",
>>>>>    			ENV_FS_RW_NAME);
>>>>> +		fprintf(stderr,
>>>>> +			"Environment variables containing ports are optional "
>>>>> +			"and could be skipped.\n");
>>>>
>>>> As it is, I believe the program does something different when I'm
>>>> setting these to the empty string (ENV_TCP_BIND_NAME=""), compared to
>>>> when I'm unsetting them?
>>>>
>>>> I think the case where we want to forbid all handle-able networking is
>>>> a legit and very common use case - it could be clearer in the
>>>> documentation how this is done with the tool. (And maybe the interface
>>>> could be something more explicit than setting the environment variable
>>>> to empty?)
>>
>> I'd like to keep it simple, and it should be seen as an example code,
>> not a full-feature sandboxer, but still a consistent and useful one.
>> What would you suggest?
>>
>> This sandboxer tool relies on environment variables for its
>> configuration. This is definitely not a good fit for all use cases, but
>> I think it is simple and flexible enough. One use case might be to
>> export a set of environment variables and simply call this tool. I'd
>> prefer to not deal with argument parsing, but maybe that was too
>> simplistic? We might want to revisit this approach but probably not with
>> this series.
>>
>>
>>>>
>>>>
>>>>> +	/* Removes bind access attribute if not supported by a user. */
>>>>> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
>>>>> +	if (!env_port_name) {
>>>>> +		ruleset_attr.handled_access_net &=
>>>>> +			~LANDLOCK_ACCESS_NET_BIND_TCP;
>>>>> +	}
>>>>> +	/* Removes connect access attribute if not supported by a user. */
>>>>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>>>>> +	if (!env_port_name) {
>>>>> +		ruleset_attr.handled_access_net &=
>>>>> +			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>>>>> +	}
>>>>
>>>> This is the code where the program does not restrict network usage,
>>>> if the corresponding environment variable is not set.
>>>
>>>      Yep. Right.
>>>>
>>>> It's slightly inconsistent with what this tool does for filesystem
>>>> paths. - If you don't specify any file paths, it will still restrict
>>>> file operations there, independent of whether that env variable was
>>>> set or not.  (Apologies if it was discussed before.)
>>>
>>>     Mickaёl wanted to make network ports optional here.
>>>     Please check:
>>>    
>>> https://lore.kernel.org/linux-security-module/179ac2ee-37ff-92da-c381-c2c716725045@digikod.net/
>>
>> Right, the rationale is for compatibility with the previous version of
>> this tool. We should not break compatibility when possible. A comment
>> should explain the rationale though.
>>
>>>
>>> https://lore.kernel.org/linux-security-module/fe3bc928-14f8-5e2b-359e-9a87d6cf5b01@digikod.net/
>>>>
>>>> —Günther
>>>>
>> .
