Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB5EC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Apr 2022 18:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbiDCSeO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Apr 2022 14:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiDCSeN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Apr 2022 14:34:13 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BA539168
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Apr 2022 11:32:18 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id b17so5805901lfv.3
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Apr 2022 11:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=7gSJ7lBDUSV91N/ZBedS4w6QWUrRokZ4ME+wN1HbZQA=;
        b=WF1a4W+eaXGJTG+f/JfZhsTyXIszcomyR12hX1TFyj6S4ILzkFsF8kS/6VmbF+ysP0
         iy+qurX2JgAXOuH8TgIHQnvGQGIqlVcLlofwtt3wHLoxprpmXWULbM9Lk7guvJnx2q90
         jR41aFGC9Gh2Isb+7+Cv/QfQULIUbKXSR6982AV45RmmrDwvSNx9b7oyOuKV+A26Jcwp
         Ssae4SZaG8HUb/DkZaq3uJT3cchNfFY++W+BmohJOrK82WABils8hd0wgeqJwsv7KiS+
         Ll/7qJIiE4HDMatwr1sDeeI3R+rzL3mSQ//R416VrkoOiHmSqeHYlHyv2o5qMhKn0LQo
         qc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=7gSJ7lBDUSV91N/ZBedS4w6QWUrRokZ4ME+wN1HbZQA=;
        b=XGy8Zn9XurCKGZ878NS9/LwVh0RYXOJV82oG0bMQgJ/JuKDwxrIhuV1vaVWD+GVj2s
         W0m/cC8QRyZfVSRxV89UuB+BTGFZkw5mB5zpewTy06XpCqQ1ICpOFvE2Ycf/NPzd577e
         dF5iq8Sw4OZcWFYlYsk69++6R9xO0PAiZcmtNCyuPUi+W2M0VstaSzWLgRjmxTRkMRCc
         /oiLW/gJsCZU5YzjEeuRqzZUHAOZ6bZLypYpjxROnYVFyAjqeBHoegp4MwVNJ33lpYxg
         H59vJ98Z5u5E24K+GsJ+gZI27MqH7ajwodCm58yxOx8SNo/2J/PdD+020/x+N7EN1sy6
         P/LQ==
X-Gm-Message-State: AOAM5317tr0pISAwrf+3ZXayD0Aw4p0Hn9PWX2BBuJN2Cv8sHpMsHvzL
        z065F2TnCsCxZbpbakmfLLqdgE3n6+Q=
X-Google-Smtp-Source: ABdhPJx5VZihlyh7PM/GLQ01isXzvi1fKX/9VWjE2KLvycG3VPS4ZIReJ7hgOCy4Xq1QRQXfPgimnQ==
X-Received: by 2002:a05:6512:c23:b0:44a:3191:b65c with SMTP id z35-20020a0565120c2300b0044a3191b65cmr19867938lfu.636.1649010736852;
        Sun, 03 Apr 2022 11:32:16 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id p41-20020a05651213a900b00443e2c39fc4sm888434lfa.111.2022.04.03.11.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 11:32:16 -0700 (PDT)
Message-ID: <6786df44-49de-3d35-2c16-030e6290d19d@gmail.com>
Date:   Sun, 3 Apr 2022 21:32:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Support for loading firewall rules with cgroup(v2) expressions
 early
Content-Language: en-US
From:   Topi Miettinen <toiwoton@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <fabde324-383a-622c-7e69-32c9b2d06191@gmail.com>
 <YkDXwaPwYf8NgKT+@salvia> <418f6461-4504-4707-5ec2-61227af2ad27@gmail.com>
 <YkHOuprHwwuXjWrm@salvia> <5b850d67-92c1-9ece-99d2-390e8a5731b3@gmail.com>
 <YkOF0LyDSqKX6ERe@salvia> <YkPGJRUAuaLKrA0I@salvia>
 <bcb8f1c4-177a-c9a4-4da4-cc594ca91f91@gmail.com>
In-Reply-To: <bcb8f1c4-177a-c9a4-4da4-cc594ca91f91@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2.4.2022 11.12, Topi Miettinen wrote:
> On 30.3.2022 5.53, Pablo Neira Ayuso wrote:
>> On Wed, Mar 30, 2022 at 12:25:25AM +0200, Pablo Neira Ayuso wrote:
>>> On Tue, Mar 29, 2022 at 09:20:25PM +0300, Topi Miettinen wrote:
>> [...]
>>> You could define a ruleset that describes the policy following the
>>> cgroupsv2 hierarchy. Something like this:
>>>
>>>   table inet filter {
>>>          map dict_cgroup_level_1 {
>>>                  type cgroupsv2 : verdict;
>>>                  elements = { "system.slice" : jump system_slice }
>>>          }
>>>
>>>          map dict_cgroup_level_2 {
>>>                  type cgroupsv2 : verdict;
>>>                  elements = { 
>>> "system.slice/systemd-timesyncd.service" : jump systemd_timesyncd }
>>>          }
>>>
>>>          chain systemd_timesyncd {
>>>                  # systemd-timesyncd policy
>>>          }
>>>
>>>          chain system_slice {
>>>                  socket cgroupv2 level 2 vmap @dict_cgroup_level_2
>>>                  # policy for system.slice process
>>>          }
>>>
>>>          chain input {
>>>                  type filter hook input priority filter; policy drop;
>>
>> This example should use the output chain instead:
>>
>>            chain output {
>>                    type filter hook output priority filter; policy drop;
>>
>>  From the input chain, the packet relies on early demux to have access
>> to the socket.
>>
>> The idea would be to filter out outgoing traffic and rely on conntrack
>> for (established) input traffic.
> 
> Is it really so that 'socket cgroupv2' can't be used on input side at 
> all? At least 'ss' can display the cgroup for listening sockets 
> correctly, so the cgroup information should be available somewhere:
> 
> $ ss -lt --cgroup
> State    Recv-Q   Send-Q       Local Address:Port       Peer 
> Address:Port   Process
> LISTEN   0        4096                  *%lo:ssh                   *:* 
>       cgroup:/system.slice/ssh.socket

Also 'meta skuid' doesn't seem to work in input filters. It would have 
been simple to use 'meta skuid < 1000' to simulate 'system.slice' vs. 
'user.slice' cgroups.

If this is intentional, the manual page should make this much clearer. 
There's no warning and the kernel doesn't reject the useless input rules.

I think it should be possible to do filtering on input side based on the 
socket properties (UID, GID, cgroup). Especially with UDP, it should be 
possible to drop all packets if the listening process is not OK.

My use case is that I need to open ports for Steam games (TCP and UDP 
ports 27015-27030) but I don't want to make them available for system 
services or any other apps besides Steam games. SELinux SECMARKs and TE 
rules for sockets help me here but there are other problems.

-Topi
