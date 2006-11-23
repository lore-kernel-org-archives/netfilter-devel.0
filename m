From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: connbytes & 64bit counters
Date: Thu, 23 Nov 2006 22:04:21 +0100
Message-ID: <45660CD5.1090405@netfilter.org>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
	<Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
	<4565AAC7.8050702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Krzysztof Oledzki <olenf@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4565AAC7.8050702@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
>>What is wrong in sending 64 bit counters to userspace if we already have
>>64 bit counters in kernel?
> 
> Nothing - but changing the API based on config options is bad design.
> I am fine with sending 64 bit unconditionally. But you need to make
> sure you don't send (32 bit) overflow events to userspace anymore.

They could be used to notify 64 bits overflow events. Userspace can 
differenciate if the kernel is using 32 or 64 bits and interpret the 
overflow event appropiately.

> Mhh .. this hole thing is a mess:
> 
> enum ctattr_counters {
>         CTA_COUNTERS_UNSPEC,
>         CTA_COUNTERS_PACKETS,           /* old 64bit counters */
>         CTA_COUNTERS_BYTES,             /* old 64bit counters */
>         CTA_COUNTERS32_PACKETS,
>         CTA_COUNTERS32_BYTES,
> 
>         __CTA_COUNTERS_MAX
> };
> 
> So apparently we already broke compatibility. My prefered solution would
> be to get rid of this mess and return to 64 bit counters unconditionally
> and everywhere.

Hm, why not default on 64 bits counters but still give the choice to 
select 32 bits at compilation time? Some advanced users could still want 
to compile 32 bits to save some memory (perhaps embedded stuff guys), so 
I have the impression that this issue will be revisited sooner or later. 
I can give a hand to Krzysztof and improve the patch to make it look 
cleaner, although we will still need some ifdef's. Still not convinced?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
