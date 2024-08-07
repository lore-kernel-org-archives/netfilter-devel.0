Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3A61E6738;
	Wed,  7 Aug 2024 13:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723037271; cv=none; b=ZU8iRGAH0wE2jgKcgbjjD6EKF5F+NZkBJQAgDkEj/IrPI5kLxSJI1e2OB8EBsMH5bqc/sADYxKcUZ/kQIGmzRDQcbkU6AXb53VqLqfZzS4WicfOwpfwoQS7FLq3bWsPHRI/fYmOeh7kvoN9SwznOzuv/fVdSv1F6tkjZef+s+cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723037271; c=relaxed/simple;
	bh=OADje7zt8dY9Vw2o86Ho381UgUDbTseWM16A5rJV8f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZjogVvDiXAHVYlb+p6s6Fo9uBUn3CLcBzGHYRNwD9qfqav6s1mLzzR9dX/4nni8D2eHJqNPMAmUhbyLZ2zNGUOsWqc0aEmCWbXfXSTG/LOLJ8iTJ+bJblHH6pvHaXoc0THGnTbeh+YuQpXQddg9BUL3V3GkYQK1a37/bl0cmx1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IU1XCW/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IU1XCW/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABB6C32782;
	Wed,  7 Aug 2024 13:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723037270;
	bh=OADje7zt8dY9Vw2o86Ho381UgUDbTseWM16A5rJV8f0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IU1XCW/D6wOEwJcQtvuddIih6pY5hqO+GhjH9X+ewtQcpYnB0Y48f/8su+gb/ptew
	 Pq6CW7/SMiXzEXzOhvSI9UHmFuTXWh3SFp/onAqKyioaX9MAGG9t0thw/5isrH6xt6
	 WuvGUfqyLCK0ZAWtGwXR0oNsOzJYoXxody01XDvOtaXSWZaPi/Qf1RGDCHrhe7nVqk
	 tyffwT0A2YgPKjUth5a0pM/AfK7nIjZ+cstwKuHWhmIpCzxYCkVNSrtjRNtMTq7RKB
	 AELnht5eip8je6Ctavbs0M3RuzKicTBWkh5eDkzF9tFI5qjjxEwxC8afQNzl45RR+j
	 rmZTzDarW0GWw==
Date: Wed, 7 Aug 2024 09:27:48 -0400
From: Sasha Levin <sashal@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: CVE-2024-39503: netfilter: ipset: Fix race between namespace
 cleanup and gc in the list:set type
Message-ID: <ZrN2VCc9hM_mahCS@sashalap>
References: <2024071204-CVE-2024-39503-e604@gregkh>
 <c44971f608d7d1d2733757112ef6fca87b004d17.camel@oracle.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c44971f608d7d1d2733757112ef6fca87b004d17.camel@oracle.com>

On Wed, Aug 07, 2024 at 06:42:14AM +0000, Siddh Raman Pant wrote:
>On Fri, 12 Jul 2024 14:21:09 +0200, Greg Kroah-Hartman wrote:
>> In the Linux kernel, the following vulnerability has been resolved:
>>
>> netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type
>>
>> Lion Ackermann reported that there is a race condition between namespace cleanup
>> in ipset and the garbage collection of the list:set type. The namespace
>> cleanup can destroy the list:set type of sets while the gc of the set type is
>> waiting to run in rcu cleanup. The latter uses data from the destroyed set which
>> thus leads use after free. The patch contains the following parts:
>>
>> - When destroying all sets, first remove the garbage collectors, then wait
>>   if needed and then destroy the sets.
>> - Fix the badly ordered "wait then remove gc" for the destroy a single set
>>   case.
>> - Fix the missing rcu locking in the list:set type in the userspace test
>>   case.
>> - Use proper RCU list handlings in the list:set type.
>>
>> The patch depends on c1193d9bbbd3 (netfilter: ipset: Add list flush to cancel_gc).
>
>This commit does not exist in stable kernels. Please backport it.
>
>	netfilter: ipset: Add list flush to cancel_gc
>	
>	Flushing list in cancel_gc drops references to other lists right away,
>	without waiting for RCU to destroy list. Fixes race when referenced
>	ipsets can't be destroyed while referring list is scheduled for destroy.
>
>Since this is missing, the CVE fix potentially introduced new races as
>it makes use of RCU.

Indeed, looks like it was missing on older trees. I'll queue it up.

Thanks!

-- 
Thanks,
Sasha
