From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Fri, 31 Oct 2003 18:30:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310311830.45394.bdschuym@pandora.be>
References: <20031031125306.66465.qmail@web13907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20031031125306.66465.qmail@web13907.mail.yahoo.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 31 October 2003 13:53, Scott MacKay wrote:
> I had a question on this item and was wondering if it
> is caused by the topic of this thread.

Oh, sorry, I forgot you mailed that question. I was going to mail back after I 
tested Dave's fix, but then I forgot...

> I have a QUEUE target, a custom C app running off of
> ip_queue in userspace.  I am using the ebtables
> bridging software under linux 2.4.20.  My QUEUE target
> does some packet alteration (data content of TCP/UDP &
> re-checksums, otherwise does not change header).  In
> bridge mode, I cannot seem to place the QUEUE in
> PREROUTING mangle or raw tables.  When I try, it seems
> to not do any traffic.  If it is in POSTROUTING or
> FORWARD or whatever, it is OK.  It also is OK if it is
> routing in PREROUTING as opposed to bridging.  Are the
> issued addressed by this patch discussion possibly the
> cause of my problems?

Sounds like that's the problem. It's probably just a coincidence that it 
worked in the FORWARD chain.
I'll cook up a new patch (for 2.4.22) this weekend. You can manually make 
Dave's changes if you don't want to use 2.4.22.

cheers,
Bart
