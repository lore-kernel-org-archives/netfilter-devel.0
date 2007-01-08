From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: MARK targets all non-terminating
Date: Mon, 8 Jan 2007 22:42:34 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
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


On Jan 8 2007 08:56, Jozsef Kadlecsik wrote:
> On Sun, 7 Jan 2007, Jan Engelhardt wrote:
>
>> I was about to extend the kernel and iptables to support
>> something along the lines of
>> 
>> iptables -t mangle -A POSTROUTING -j MARK --mark 117 --terminate
>> 
>> but then faced the problem of what verdict to return in xt_MARK when
>> --terminate is given. NF_DROP? No, that could possibly interfere
>> with the default chain policy. Same goes for NF_ACCEPT. NF_STOLEN,
>> NF_QUEUE and NF_STOP do not seem to be the right ones either. We'd
>> need some sort of NF_EXIT in ipt_do_table, which essentially jumps
>> right out of all user-defined chains to the end of the table to hit
>> the default policy.
>
> Why should the processing be continued? If the packet is
> to be marked then it's highly unlikley it should at the
> same time be dropped. So in my opinion a simple NF_ACCEPT
> would be a perfect return value.

That makes sense. Thanks for the hint, I think I can
complete it now.


[ Gah, I just dislike it that you can actually *filter*
  packets in the "mangle" and "nat" tables. This leads to
  things like users doing just that (nat especially because
  it only gets the first packet in a connection. To me, it
  looks like mangle-input and filter-input could just be
  consolidated into one table, same going for
  mangle-forward/filter-forward.

  http://www.imagestream.com/~josh/PacketFlow-new.png ]



	-`J'
-- 
