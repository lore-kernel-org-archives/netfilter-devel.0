From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Fri, 31 Oct 2003 04:53:06 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031031125306.66465.qmail@web13907.mail.yahoo.com>
References: <200310280002.12023.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200310280002.12023.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I had a question on this item and was wondering if it
is caused by the topic of this thread.

I have a QUEUE target, a custom C app running off of
ip_queue in userspace.  I am using the ebtables
bridging software under linux 2.4.20.  My QUEUE target
does some packet alteration (data content of TCP/UDP &
re-checksums, otherwise does not change header).  In
bridge mode, I cannot seem to place the QUEUE in
PREROUTING mangle or raw tables.  When I try, it seems
to not do any traffic.  If it is in POSTROUTING or
FORWARD or whatever, it is OK.  It also is OK if it is
routing in PREROUTING as opposed to bridging.  Are the
issued addressed by this patch discussion possibly the
cause of my problems?

-Scott

__________________________________
Do you Yahoo!?
Exclusive Video Premiere - Britney Spears
http://launch.yahoo.com/promos/britneyspears/
