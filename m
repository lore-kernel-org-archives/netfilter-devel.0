Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997333B3BFE;
	Wed, 15 Apr 2026 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.61.224.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776261110; cv=none; b=DzkLmglOeZxReDPa9typrsiE2aT2CsFWpUI5nRNAtfclT1NU2yfqnMfiZpbrZmg91MPqawenDzIdTfL1uOwOQITN8r2h1h+TAA/e41+h1UF9dg1iMITa9mZ75ejgN70j/CWhK4LK3cpTJD3pkwWZ7t4MTtjRrqXswIT7nVk8Z48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776261110; c=relaxed/simple;
	bh=1KQV6DqB3E46shdSQ8zoRrX9PH4TABhATC7C3sT0pOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jMBMgdGx54++fQKTUyunWNp3vLX049IScpbQicnEdm1ggUbnTjL3RvIX2nfThhn3a/Ryjz1HcnYnc0UqwM0eBpPIlkXxoH1w2+d2tVANi79lvqp1JQ+lKv2vrTISOSGTdiKCuVCNAF3/bcHVCEx+gNf9P2//b2HoNly8sF47bU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org; spf=pass smtp.mailfrom=cachyos.org; dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b=ZJLzIIWV; arc=none smtp.client-ip=202.61.224.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cachyos.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b="ZJLzIIWV"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 83D792860DF;
	Wed, 15 Apr 2026 15:51:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
	t=1776261104; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=cjL+4kTqmR79x407tHHUuU7PJnejCHLxK2FDjGKVSkg=;
	b=ZJLzIIWVGcccF460uwPK3yiv8WlgQ2kV8g+Pp4QaZhFeDltUkgkX+yc8Mf5XKdPWl9FFbj
	jkDoyDYvxyx8zZuQFYTkg8K2TmgwQURGjqpkoIBVNi9fMG120oQWQLpRZ3z8Z+g6uY1PXF
	z3+XdjZjKvnshBsdEPJhzEO23rqiocg6eslY/9cO22tQptYtlA+Nb/g07B+UP7VZit6N2E
	bn9QwiEySVtXoP28L3LhDLz28qVpm8otqykreJCfMkm9iGI7HB8OpAggnkkaEv5VL9aIpz
	96c660bV36WKO5f+tH++CXBjIAnMwqDDQpmJ1MigVVl0IcQUWlSS76hwCy+DoA==
Message-ID: <349d61ce-6a5c-48c7-a4b8-a554668dc75c@cachyos.org>
Date: Wed, 15 Apr 2026 13:51:00 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: The "clockevents: Prevent timer interrupt starvation" patch
 causes lockups
To: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>,
 Thomas Gleixner <tglx@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Ingo Molnar
 <mingo@kernel.org>, John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <68d1e9ac-2780-4be3-8ee3-0788062dd3a4@gmail.com>
 <aeb848aa-404a-40fb-bd41-329644623b1d@cachyos.org>
 <ad6BtKRj1GyreNCS@localhost.localdomain>
 <a3ac856c-914c-4b39-949f-634bed501e7c@gmail.com> <87340xfeje.ffs@tglx>
 <e6d3dc64-1714-4105-8a38-3942c62d159a@gmail.com>
From: Eric Naim <dnaim@cachyos.org>
In-Reply-To: <e6d3dc64-1714-4105-8a38-3942c62d159a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

On 4/15/26 5:35 AM, Hanabishi wrote:
> On 14/04/2026 20:55, Thomas Gleixner wrote:
>> The one below should cover all possible holes.
>>
>> Thanks,
>>
>>          tglx
>> ---
>> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
>> index b4d730604972..5e22697b098d 100644
>> --- a/kernel/time/clockevents.c
>> +++ b/kernel/time/clockevents.c
>> @@ -94,6 +94,9 @@ static int __clockevents_switch_state(struct
>> clock_event_device *dev,
>>       if (dev->features & CLOCK_EVT_FEAT_DUMMY)
>>           return 0;
>>   +    /* On state transitions clear the forced flag unconditionally */
>> +    dev->next_event_forced = 0;
>> +
>>       /* Transition with new state-specific callbacks */
>>       switch (state) {
>>       case CLOCK_EVT_STATE_DETACHED:
>> @@ -366,8 +369,10 @@ int clockevents_program_event(struct clock_event_device
>> *dev, ktime_t expires, b
>>       if (delta > (int64_t)dev->min_delta_ns) {
>>           delta = min(delta, (int64_t) dev->max_delta_ns);
>>           cycles = ((u64)delta * dev->mult) >> dev->shift;
>> -        if (!dev->set_next_event((unsigned long) cycles, dev))
>> +        if (!dev->set_next_event((unsigned long) cycles, dev)) {
>> +            dev->next_event_forced = 0;
>>               return 0;
>> +        }
>>       }
>>         if (dev->next_event_forced)
>> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
>> index 7e57fa31ee26..115e0bf01276 100644
>> --- a/kernel/time/tick-broadcast.c
>> +++ b/kernel/time/tick-broadcast.c
>> @@ -108,6 +108,7 @@ static struct clock_event_device
>> *tick_get_oneshot_wakeup_device(int cpu)
>>     static void tick_oneshot_wakeup_handler(struct clock_event_device *wd)
>>   {
>> +    wd->next_event_forced = 0;
>>       /*
>>        * If we woke up early and the tick was reprogrammed in the
>>        * meantime then this may be spurious but harmless.
> 
> Ok, it does fix the problem! Thank you.
> The patch itself does not apply cleanly for 7.0 though and I had to adapt it a
> bit.
> 

Sorry for the delay folks! This patch fixes the regression and a user recently
confirmed it as well.

Feel free to add:
Tested-by: Eric Naim <dnaim@cachyos.org>

-- 
Regards,
  Eric
