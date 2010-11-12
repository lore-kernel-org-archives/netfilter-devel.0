From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: NF_HOOK_COND has wrong conditional
Date: Fri, 12 Nov 2010 08:32:10 +0100
Message-ID: <4CDCED7A.9040202@trash.net>
References: <20101111190954.29005.61686.stgit@paris.rdu.redhat.com> <alpine.LNX.2.01.1011112148100.30863@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1011112148100.30863@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 11.11.2010 21:49, Jan Engelhardt wrote:
> On Thursday 2010-11-11 20:09, Eric Paris wrote:
> 
>> The NF_HOOK_COND returns 0 when it shouldn't due to what I believe to be an
>> error in the code as the order of operations is not what was intended.  C will
>> evalutate == before =.  Which means ret is getting set to the bool result,
>> rather than the return value of the function call.  The code says
>>
>> if (ret = function() == 1)
>> when it meant to say:
>> if ((ret = function()) == 1)
> 
> Thanks for catching. Indeed (ret = f) == 1 is desired, as can be seen in 
> patch 2249065f4b22b493bae2caf549b86f175f33188e.

Applied, thanks Eric.
