From: "Richard" <richard@o-matrix.org>
Subject: RE: target for modifying conntrack timeout value
Date: Tue, 30 Nov 2004 22:13:40 -1000
Message-ID: <EINSTEINLR95CBUzN8I000063f8@einstein.systemmetrics.com>
References: <20041201070025.GD4605@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Patrick Schaaf'" <bof@bof.de>
In-reply-to: <20041201070025.GD4605@oknodo.bof.de>
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

Hi Patrick,

I would expect that the new target will just modify the time left for the
connection. One can 'match' state to see the conditions to change it. So it
is up to the user to decide what value to use for a certain state.

My specific application is for SIP. SIP sends out REGISTER messages to the
outside server. The server would send any call to the inside client via its
NAT address. If the conntrack is no longer there, the inside client can't
receive any SIP message and won't get any call. It needs to keep the
conntrack active far larger than the 3 minutes default.

I am thinking to use "ip_ct_refresh" to change the current value of
conntrack. If it is feasible, the module shouldn't be too hard to write.

Thanks,
Richard

> -----Original Message-----
> From: Patrick Schaaf [mailto:bof@bof.de]
> Sent: Tuesday, November 30, 2004 9:00 PM
> To: Richard
> Cc: 'Kiran Kumar Immidi'; netfilter-devel@lists.netfilter.org
> Subject: Re: target for modifying conntrack timeout value
> 
> Hello Richard,
> 
> > This would change the timeout value for all udp conntrack. I'd like to
> have
> > more granular control, e.g. after match of certain ports or other
> > conditions.
> 
> This does not exist, yet, for all I know.
> 
> It would require a new data field for each conntrack, "override_timeout".
> 
> And then, there would be the interesting question of what to do for
> state changes. UDP is easy, but TCP has a load of states it goes
> through when the session comes down. Each state transition is coupled
> to a per-new-state timeout value. Now, if you give a specific
> override_timeout,
> what to do with it when the next state transition occurs?
> 
> Finally, why do you think you need that? What is so special about your
> setup that, after one UDP conntrack times out, the next packet for the
> same pair of addresses cannot just create a new, equivalent conntrack?
> That would be normal operation - what is different for you?
> 
> best regards
>   Patrick
