From: Kiran Kumar <immidi_kiran@yahoo.com>
Subject: TCP match and IP fragmentation
Date: Mon, 16 Feb 2004 21:22:56 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217052256.36333.qmail@web14008.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
  I need some clarification on how ip fragmentation
and tcp match interact. The tcp match seems to not
match any non-first fragments (return 0 if offset is
non-zero). So, if I have a rule to accept tcp packets
to a certain port in a chain, and no other rules, does
that mean that the first fragment is accepted and the
later ones not accepted? Do correct me if I have got
anything wrong.


=====
Regards,
Kiran Kumar Immidi

__________________________________
Do you Yahoo!?
Yahoo! Finance: Get your refund fast by filing online.
http://taxes.yahoo.com/filing.html
