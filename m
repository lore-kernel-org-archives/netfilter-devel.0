From: Patrick Schaaf <bof@bof.de>
Subject: Re: target for modifying conntrack timeout value
Date: Wed, 1 Dec 2004 08:00:26 +0100
Message-ID: <20041201070025.GD4605@oknodo.bof.de>
References: <200412010920.49048.immidi@spymac.com>
	<EINSTEINAStRc0JFaTi000063f4@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	'Kiran Kumar Immidi' <immidi@spymac.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
Content-Disposition: inline
In-Reply-To: <EINSTEINAStRc0JFaTi000063f4@einstein.systemmetrics.com>
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

Hello Richard,

> This would change the timeout value for all udp conntrack. I'd like to have
> more granular control, e.g. after match of certain ports or other
> conditions.

This does not exist, yet, for all I know.

It would require a new data field for each conntrack, "override_timeout".

And then, there would be the interesting question of what to do for
state changes. UDP is easy, but TCP has a load of states it goes
through when the session comes down. Each state transition is coupled
to a per-new-state timeout value. Now, if you give a specific override_timeout,
what to do with it when the next state transition occurs?

Finally, why do you think you need that? What is so special about your
setup that, after one UDP conntrack times out, the next packet for the
same pair of addresses cannot just create a new, equivalent conntrack?
That would be normal operation - what is different for you?

best regards
  Patrick
