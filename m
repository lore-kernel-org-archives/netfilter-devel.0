From: Scott MacKay <scottmackay@yahoo.com>
Subject: metadata association without structure alteration?
Date: Thu, 1 Apr 2004 06:01:07 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040401140107.86582.qmail@web13903.mail.yahoo.com>
References: <Pine.LNX.4.44.0403312212050.24487-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0403312212050.24487-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello!
   I was wondering, is there any way to associate some
arbitrary metadata with a packet as it traverses the
netfilter stages without altering a skb or nf_info
structure?  Currently, I think alterations I want to
make to play with packets is limited to ip_queue and
it's private structures.  I would like to be able to
associate  some data, though, with a packet (much like
the netfilter mark) during it's stay in the netfilter
system, but would prefer a method where I do not need
to alter any shared header structure.  For me, this
metadata would only need to be accessible from the
ip_queue.c module.  I could use a private list, but
the only thing is I would not know when to release the
metadata as the packet gets dropped/delivered.
Maybe a way to register a callback when a packet gets
added, dropped or otherwise enters/leave the whole
netfilter thing?  Thanks in advance!!

-Scott


__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
