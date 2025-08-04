Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF5E1F4617
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 10:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754301900; cv=none; b=kLSe98Xd2OMX8H8wW0qZfyP5T8CgKggw+l5jaPrefSgsvaXqqKKB6jO1muClwtietbdgrx6Fs47R75r+89Nh0uLOlZuf80LlxFm6ENJm0kx26Bi0pRdFzIx6c1klSE2yOV/6blPyF4gnhuFptyYeKCcZwLf13FzHI14wL43+ZC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754301900; c=relaxed/simple;
	bh=EAu7GxnwjKS4kD7W/wHMzceDkOeO8txDn9R4AOsBAMk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=e9nJgN4GCqnUY+DuejDgqUJB3BmRKM6XkuQYSNMtCL5Rfyj5OS++1DayTpq96Fn80VnlAMT1MlYEWsOItp1UOFQSMFkqdgwTgK79/BX+4ZacpLb2SZDmDyiNICuitjaycVCVhE7QNcjRbtHDrCDlFYYFQXexlJxmd0yQSmL8XtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RTDOY5Em; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RTDOY5Em"
Message-ID: <a20cb422-9eca-4a41-9087-28cd608483fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754301895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbItwscr7uRMimGniOKr6OFcSfaGgEJBZ2eE8r5qsZ0=;
	b=RTDOY5Em9W/zoY+3oft4BmrpmAbj049z3z+X3Bh0uGydc83Vlsl8YYpoO25ByjUV5sv7sa
	sm1fa2M+dYZZC3n6m/vzzGl+kJKlnvG87/ZhKNRgzL8H8YIHgG84n9VgYqfQgNQlMNX9vV
	oS0+jWQ2nipizCG7rbtUuTdOXPh0NC8=
Date: Mon, 4 Aug 2025 18:04:50 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [bug report] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: netfilter-devel@vger.kernel.org
References: <aJBtpniVz8dIRDYf@stanley.mountain>
 <0e275ffe-e475-40eb-ac19-d0122ba847ae@linux.dev>
 <cd3b87dd-9f6f-48f0-b2f2-586d60d9a365@suswa.mountain>
 <c401288b-e2de-42a7-8e04-abd08daa112a@linux.dev>
In-Reply-To: <c401288b-e2de-42a7-8e04-abd08daa112a@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 2025/8/4 17:57, Lance Yang wrote:
> 
> 
> On 2025/8/4 17:24, Dan Carpenter wrote:
>> On Mon, Aug 04, 2025 at 05:05:32PM +0800, Lance Yang wrote:
>>>
>>>
>>> On 2025/8/4 16:21, Dan Carpenter wrote:
>>>> Hello Lance Yang,
>>>>
>>>> Commit e89a68046687 ("netfilter: load nf_log_syslog on enabling
>>>> nf_conntrack_log_invalid") from May 26, 2025 (linux-next), leads to
>>>> the following Smatch static checker warning:
>>>>
>>>>     net/netfilter/nf_conntrack_standalone.c:575 
>>>> nf_conntrack_log_invalid_sysctl()
>>>>     warn: missing error code? 'ret'
>>>
>>> Thanks for pointing this out!
>>>
>>>>
>>>> net/netfilter/nf_conntrack_standalone.c
>>>>       559 static int
>>>>       560 nf_conntrack_log_invalid_sysctl(const struct ctl_table 
>>>> *table, int write,
>>>>       561                                 void *buffer, size_t 
>>>> *lenp, loff_t *ppos)
>>>>       562 {
>>>>       563         int ret, i;
>>>>       564
>>>>       565         ret = proc_dou8vec_minmax(table, write, buffer, 
>>>> lenp, ppos);
>>>>       566         if (ret < 0 || !write)
>>>>       567                 return ret;
>>>>       568
>>>>       569         if (*(u8 *)table->data == 0)
>>>>       570                 return ret;
>>>>
>>>> return 0?
>>>
>>> That's a good question. proc_dou8vec_minmax() returns 0 on a successful
>>> write. So when a user writes '0' to disable the feature, ret is 
>>> already 0.
>>> Returning it is the correct behavior to signal success.
>>>
>>>>
>>>>       571
>>>>       572         /* Load nf_log_syslog only if no logger is 
>>>> currently registered */
>>>>       573         for (i = 0; i < NFPROTO_NUMPROTO; i++) {
>>>>       574                 if (nf_log_is_registered(i))
>>>> --> 575                         return ret;
>>>>
>>>> This feels like it should be return -EBUSY?  Or potentially return 0.
>>>
>>> We simply return ret (which is 0) to signal success, as no further 
>>> action
>>> (like loading the nf_log_syslog module) is needed.
>>>
>>>>
>>>>       576         }
>>>>       577         request_module("%s", "nf_log_syslog");
>>>>       578
>>>>       579         return ret;
>>>>
>>>> return 0.
>>>
>>> It's 0 as well.
>>>
>>> Emm... do you know a way to make the Smatch static checker happy?
>>>
>>
>> Returning 0 would make the code so much more clear.  Readers probably
> 
> Yep, I see your point ;)
> 
>> assume that proc_dou8vec_minmax() returns positive values on success
> 
> IIUC, proc_dou8vec_minmax only returns 0 for success or a negative
> error code, so there's no positive value case here ...

Correction:

IIUC, proc_dou8vec_minmax only returns 0 for success or a negative
error code on a write, so there's no positive value case here ...

> 
>> and that's why we are returning ret.  I know that I had to check.
>>
> 
> It should make the code clearer and also make the Smatch checker happy:
> 
>      ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
>      - if (ret < 0 || !write)
>      + if (ret != 0 || !write)
>          return ret;
> 
> By checking for "ret != 0", it becomes explicit that ret can only be
> zero after that. wdyt?
> 
> Also, if you'd like, please feel free to send a patch for it ;p
> 
> Thanks,
> Lance
> 

