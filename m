From: michal salaban <emes@pld-linux.org>
Subject: QUEUE target: fragmented IP appears in reversed order
Date: Thu, 6 Nov 2003 22:57:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031106215706.GA10641@skunk.one.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

hi!

i'm working on software that reads from netfilter QUEUE using libipq.
while performing some tests i noticed strange thing - all IP fragments
caught on OUTPUT chain appear in reversed order.

is that OK? does kernel IP layer send fragments reversed (don't believe)
or netfilter changes order for some reason?

-- 
michal salaban -|- emes (at) pld-linux.org -|- jabber: emes@jabber.org
