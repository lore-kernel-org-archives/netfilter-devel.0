From: netfilter@westboro.org
Subject: Re: Memory Leaks in the iptc libs
Date: Fri, 20 Jun 2003 09:19:45 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.0.9.0.20030620091332.00a818c8@mail.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


>Date: 19 Jun 2003 07:13:39 +0200
>From: Martin Josefsson <gandalf@wlug.westbo.se>
>To: netfilter@westboro.org
>Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
>Subject: Re: Memory Leaks in the iptc libs
>
>On Thu, 2003-06-19 at 03:48, netfilter@westboro.org wrote:
> > am looking to see if anyone can point me in the right direction.  I can run
> > 67,000 iterations of the program and my memory space is not increasing -
> > but the overall memory usage of the machine seams to have gone up 60-70
> > megabytes.  IE even after I kill my process the memory is up.  For this
>
>Have you tried the cvs version?

No But I don't know what I should be looking for.  Should I start looking 
at libiptc.c or do I need to look at the netfilter tree under the kernel?

Bob
