From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TCP match and IP fragmentation
Date: Tue, 17 Feb 2004 11:49:01 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171141540.29541-100000@filer.marasystems.com>
References: <20040217052256.36333.qmail@web14008.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kiran Kumar <immidi_kiran@yahoo.com>
In-Reply-To: <20040217052256.36333.qmail@web14008.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 16 Feb 2004, Kiran Kumar wrote:

>   I need some clarification on how ip fragmentation
> and tcp match interact. The tcp match seems to not
> match any non-first fragments (return 0 if offset is
> non-zero).

Probably correct. One could think that -p tcp without any additional TCP 
matches would match tcp fragments but it does not.

> So, if I have a rule to accept tcp packets
> to a certain port in a chain, and no other rules, does
> that mean that the first fragment is accepted and the
> later ones not accepted?

Yes. When not using conntrack you must manually deal with fragments using 
the the fragment match. The only issue is that you can not match the 
protocol field of fragments.

If you are using conntrack then fragments are not an issue as all traffic 
is defragmented before entering iptables.

Regards
Henrik
