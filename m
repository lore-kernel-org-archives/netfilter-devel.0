From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] LOCAL_IN support for owner match
Date: Thu, 27 Mar 2003 15:21:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E8308DC.80601@trash.net>
References: <3E81B60F.1000609@trash.net> <20030327131241.GF25471@sunbeam.de.gnumonks.org> <3E830466.6010001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: marc@mbsi.ca,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <3E830466.6010001@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

> Harald Welte wrote:
>
>> After a quick read through the code, it seems like your implementation
>> works only for udp and tcp sockets.
>>
>> In this case, you should make sure that the owner match in INPUT can
>> only be used if the match did contain '-p udp' or '-p tcp'.
>
>
> i assumed the original owner match would only work with tcp/udp, too.
> after the discussion about raw sockets i guess it does also work with
> raw sockets. would it be acceptable to extend it further to work
> with raw-sockets, too ? 


This was probably one of my stupidest ideas lately ;)
i'm going to make the changes you suggested and post it again.

Thanks,
Patrick
