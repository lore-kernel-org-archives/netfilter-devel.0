From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH 2.6 0/12]: netfilter update
Date: Mon, 27 Sep 2004 00:08:41 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409262359430.7707@filer.marasystems.com>
References: <414F9DFC.701@trash.net> <20040921143611.6a6e2f60.davem@redhat.com>
	<4150BB62.2060904@trash.net> <20040921171857.2c720c8e.davem@redhat.com>
	<4150D880.70108@trash.net> <20040924154032.5a0c32e1.davem@redhat.com>
	<41571BCC.2050909@trash.net>
	<Pine.LNX.4.61.0409262344030.7439@filer.marasystems.com>
	<41573B05.1000308@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41573B05.1000308@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 26 Sep 2004, Patrick McHardy wrote:

> We confirm conntrack entries in LOCAL_IN after they passed all hooks,
> but this new set of hooks would be after LOCAL_IN, so conntrack entries
> should be confirmed there.

Right. THis would also ensure that connections not picked up by the host 
does not get confirmed, but there is many complications if attempting this 
path.

- It must be fully assured no packets is silently accepted by the host 
without entering this new hook.

- Fragmented packets is again an issue.

> I agree. But I wonder if its worth it just for having the owner match
> work in the input path, or if there are other uses for these hooks.

Not sure either. But then it is also the case I have never really been 
sure about the current independent relation of conntrack and the local 
host sockets..

Regards
Henrik
