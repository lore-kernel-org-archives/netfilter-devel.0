From: Alistair Tonner <Alistair@nerdnet.ca>
Subject: Re: Memory leaks in ip_conntrack?
Date: Mon, 10 Nov 2003 19:03:09 -0500
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <200311101903.09886.Alistair@nerdnet.ca>
References: <EFBADA8C200C2B418DA39734FD15475B0B204E@skat.sky.com>
Reply-To: Alistair@nerdnet.ca
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Kishore Dharmavaram <kishored@servgate.com>, netfilter@lists.netfilter.org
In-Reply-To: <EFBADA8C200C2B418DA39734FD15475B0B204E@skat.sky.com>
Content-Disposition: inline
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On November 10, 2003 03:10 pm, Kishore Dharmavaram wrote:

	Kishore:

	what is set in /proc/sys/net/ipv4/tcp_wmem?

	I suspect that what is STOPPing the network is there .. 
	cat /proc/sys/net/ipv4/tcp_wmem -- on my system the max is ... 
	!! 131072 !!
	
	Maybe you've maxed your memory allocation for TCP?


> Alistair & All,
>
> I believe /proc/slabinfo gives # of conntracks being used, in my tests I
> usually find slabinfo number is same as number of entries in
> /proc/net/ip_conntrack. But, after 18hrs or so the number in /proc/slabinfo
> reaches maximum and box starts refusing connections, /proc/net/ip_conntrack
> show 20 to 30 entries, I hear /proc/net/ip_conntrack is unreliable and
> broken. Anyway, I guess I have to dig into the code.
>
> Thanks,
> -Kishore
>
> -----Original Message-----
> From: Alistair Tonner [mailto:Alistair@nerdnet.ca]
> Sent: Sunday, November 09, 2003 4:40 PM
> To: netfilter@lists.netfilter.org
> Subject: Re: Memory leaks in ip_conntrack?
>
>
>
> 	Actually Anthony I'm inclined to agree with you .. I was just
> pointing out
> that the assumption that the count in /proc/slabinfo (ip_conntrack) is  an
> indication of the count in /proc/net/ipv4/ip_conntrack is completely
> incorrect.  i.e. the two counters are keeping track of dfferent things.
>
> 	I'm curious myself (as to what is causing this gent's problem) as
> there have
> been so many queries on this subject lately, and as I pointed out to Oskar
> we
> *really* are starting to need a FAQ on this.
>
> 	i.e. -- if you think this is a problem, here's best how to determine
> if
> iptables is causing memory issues on your system.  Frequenly folks are
> implementing iptables and don't understand linux memory management schema
> and the affects it has on what they see on their screens.
>
> 	Not that I'm complaining, ... Its good learning for me as I try to
> diagnose
> the issue on my system, but it might make new users lives easier if we had
> the info out there to start with.
>
>
> 	Alistair Tonner
> 	nerdnet.ca
> 	Senior Systems Analyst - RSS
>
>      Any sufficiently advanced technology will have the appearance of
> magic. Lets get magical!

-- 

	Alistair Tonner
	nerdnet.ca
	Senior Systems Analyst - RSS
	
     Any sufficiently advanced technology will have the appearance of magic.
	Lets get magical!
