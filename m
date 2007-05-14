From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: netfilter load sharing
Date: Mon, 14 May 2007 21:53:09 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705142151340.9570@yvahk01.tjqt.qr>
References: <46483D46.6040308@fragstein.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailing List <netfilter@lists.netfilter.org>
To: Thomas Fragstein <thomas@fragstein.de>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <46483D46.6040308@fragstein.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On May 14 2007 12:43, Thomas Fragstein wrote:
>
> Hi List,
>
> i have two questions.
>
> first: how i can see how many cpu load ist generate by netfilter (iptables)
>
> second: on my linux box i have seen 20-30% of one cpu is using by system. it is
> possible that netfilter can share the load over any cores (multicore cpu)

I believe that on incoming packets, the CPU handling the network card
interurpt will also serve the iptables and routing logic, and on output,
the processor the program runs on that sent a packet. Not sure, though.
CC/FWD to nf-dev, maybe they know.


	Jan
-- 
