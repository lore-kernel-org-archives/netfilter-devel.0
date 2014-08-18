From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: none zero check of the classid in xt_cgroup
Date: Mon, 18 Aug 2014 15:52:29 +0200
Message-ID: <53F2051D.7080607@redhat.com>
References: <53EEF618.6020103@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaHRNwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:52:37 -0400
In-Reply-To: <53EEF618.6020103@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/16/2014 08:11 AM, Alexey Perevalov wrote:
> Hello Daniel,
>
> I have a question regarding xt_cgroup, again )
>
> I'm interesting why did you add check for none zero id into cgroup_mt_check. With it, it's impossible
> to introduce some rules, like -m cgroup ! --cgroup 0. It could be useful for end user, for example, to block
> all processes which was under cgroups, but not whole traffic.

Yes, indeed, probably I was too focussed on [1] when in combination
with cls_cgroup (as they use the same cgroup) it's non-zero anyway;
but that doesn't make sense when in use as xt_cgroup stand-alone.
I've sent a patch, thanks.

   [1] Documentation/cgroups/net_cls.txt
