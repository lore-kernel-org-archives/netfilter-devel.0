From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 2 Sep 2004 07:10:11 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040902051011.GA1453@alpha.home.local>
References: <1092407190.2402.120.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	jamal <hadi@cyberus.ca>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1092407190.2402.120.camel@nienna.balabit>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

>	One more
>         example could be TCP window tracking, I don't think we have
>         the necessary bandwidth and CPU time to send an update message
>         after each and every received TCP packet... Any idea how we
>         could solve these problems?

I don't really agree on the bandwidth argument : a small TCP packet with
only an ACK or a control flag is 40 bytes. This is 12 bytes more than the
smallest UDP packet, so if you can update a connection with at most 12 bytes,
you can use links of the same nature. BTW, I don't think you should send one
packet per connection. You should queue updates into a list, and build the
update packet from this list. This way, you eliminate the IP+UDP header (28
bytes) for all updates except the first one, which means you then have 40
bytes to update a connection without using more bandwidth. I'm not saying
this is much enough for every case, but I think that depending on the type
of message (creation, update, destruction), we might do things with this.

If you don't want to synchronize TCP windows, you might also turn the slave
in a "lazy mode" for existing connections when it becomes master. This is a
bit dirty, but might be an acceptable trade-off.

Regards,
Willy
