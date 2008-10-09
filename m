From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Don't call nf_log_packet in NFLOG module.
Date: Thu, 09 Oct 2008 15:51:59 +0200
Message-ID: <48EE0C7F.5050001@trash.net>
References: <1223322024-20336-1-git-send-email-eric@inl.fr> <48ECAF7E.30502@trash.net> <20081008141523.GN7518@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51775 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbYJINwB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:52:01 -0400
In-Reply-To: <20081008141523.GN7518@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
> 
> On Wednesday, 2008 October  8 at 15:02:54 +0200, Patrick McHardy wrote:
>> Eric Leblond wrote:
>>> This patch modifies xt_NFLOG to suppress the call to nf_log_packet()
>>> function. The call of this wrapper in xt_NFLOG was causing NFLOG to
>>> use the first initialized module. Thus, if ipt_ULOG is loaded before
>>> nfnetlink_log all NFLOG rules are treated as plain LOG rules.
>> Oops, this slipped through somehow. It has been an intentional
>> decision to use the registered logging backends though, just changing
>> it to unconditionally use nfnetlink_log only solves the problem
>> partially.
> 
> Hmm, looks like my explanation is not correct. This patch fixes the
> following bug :
> 
> modprobe ipt_LOG
> modprobe nfnetlink_log
> iptables -A OUTPUT -j NFLOG
> Then : logged packet are treated as packet reaching the LOG target.

Yes, I know. That behaviour was intentional in the original design.
But I agree, it sucks, so I'll apply your patch.

>> The main problem is that the policy which backend to use is defined
>> by module load order, which is obviously a pretty bad idea. This does
>> not only affect xt_NFLOG, but also internal conntrack logging and
>> anything else we might want to use this for in the future.
>>
>> So I think what we should do instead is introduce a proper way to
>> select among the logging backends. We could introduce a global
>> policy, or split by subsystem, which would currently be just
>> "conntrack" and "NFLOG".
> 
> Yes, I currently working on doing that. I plan to send it in an other
> patch. I've send the following patch alone to fix this weird NFLOG
> target working as LOG target problem.

Great, thanks.
