From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Tue, 31 May 2005 19:17:24 +1000
Message-ID: <1117531044.7878.18.camel@localhost.localdomain>
References: <20050402202438.GA2968@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050402202438.GA2968@linuxace.com>
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

On Sat, 2005-04-02 at 12:24 -0800, Phil Oester wrote:
> In adjust_tcp_sequence, we track the sequence number of any adjustments
> in the correction_pos variable.  The seq stored is based upon the left
> side of the window of the NAT box -- not of the original sender.
> 
> Later, in ip_nat_seq_adjust, we compare the correction_pos variable to
> the seq of the original sender to determine whether this is a new packet
> or a retransmission (i.e. should we apply offset_before or offset_after).
> So we are comparing the post-adjustment seq to a pre-adjustment seq.

This is tested in the testsuite, and sure enough, now the patch
resulting from this discussion has been applied, it fails.  Well done:
your fix broke FTP worse than the original problem, it seems.

I *did* ask for a test here, and this is what the testsuite is *for*.
And now it works on x86_64, there's no excuse.

Grrr...
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
