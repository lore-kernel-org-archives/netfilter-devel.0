From: Alexey Toptygin <alexeyt@freeshell.org>
Subject: Re: Strange thing with iptables
Date: Thu, 9 Sep 2004 14:33:06 +0000 (UTC)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.NEB.4.60.0409091430510.3683@ukato.freeshell.org>
References: <opsd15s018le1n2s@mail.tlt.hu>
	<1094732295.8900.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1094732295.8900.7.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 9 Sep 2004, Martin Josefsson wrote:

>> which looked like:
>>
>> iptables -A FORWARD -s $machine/255.255.0.255 -j ACCEPT
>>
>>
>> What I was surprised on is the netmask. Is this a feature or a bug? I mean
>> this is quite strange netmask for me.
>
> It's a feature :)
> It doesn't make the current code any more complicated.
> And ther are actually people using it to do weird stuff...

Do you mean that one can use arbitrary bitmasks wherever netfilter wants a 
netmask value?
So, one might select all IPs with the LSB set with 0.0.0.1/0.0.0.1?

 			Alexey
