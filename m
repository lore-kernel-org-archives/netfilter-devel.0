From: "mud dog" <muddogxp@gmail.com>
Subject: Re: "Late REDIRECT"
Date: Thu, 16 Mar 2006 17:14:55 +0800
Message-ID: <24dc5ae90603160114k536c351fq@mail.gmail.com>
References: <44153615.50408@netboxblue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Menno Smits" <menno@netboxblue.com>
In-Reply-To: <44153615.50408@netboxblue.com>
Content-Disposition: inline
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

2006/3/13, Menno Smits <menno@netboxblue.com>:
> Hi,
>
> Just wanted to ask for your opinions on an idea. Please let me know if
> you think this is too difficult or crazy.
>
> We use currently use the REDIRECT target in nat PREROUTING to send
> specific traffic to proxies running on our gateway (http, pop3, dns and
> smtp).
>
> This works ok but we have the following problems:
>
> 1) nat PREROUTING happens before filter FORWARD. If we want to apply
> consistent filter rules to outbound traffic regardless of whether it
> goes via a transparent proxy or directly out then we can't because the
> transproxied traffic never goes thru filter FORWARD. Currently we use a
> horrible system of marks set in mangle PREROUTING to work around this.
> We reject packets in FORWARD or skip the REDIRECTs in nat based on the
> marks set. This is ugly and hard to debug (esp because we also use marks
> for traffic shaping).

You can REJECT packets in PREROUTING , why set marks, let it to pass
FORWARD to see if it must be rejected or not?

>
> 2) Return traffic from the transparent proxy REDIRECTs has the source IP
> and source port of the transparent proxy listener, not the true remote
> site and port. This means that when we do accounting for return traffic
> (using ULOG in mangle POSTROUTING) the remote host and port are incorrect=
.
>
> A possible solution to the above problems is to allow REDIRECTs to occur
> in nat POSTROUTING (a "late redirect" for want of a better term). That
> way all outbound traffic can pass through filter FORWARD before being
> REDIRECTed. The reply NAT for the late REDIRECT would work in a similar
> way, being performed before filter FORWARD so that the true source IP
> and port is seen there.

Hack the REDIRECT target if possible. Malloc a pool in kernel to save
the source ip/port, when in POSTROUTING, fetch them.


>
> Is something like this feasible? How difficult would it be implement? Am
> I barking up the wrong tree?
>
> Regards,
> Menno
>
> Scanned by the NetBox from NetBox Blue
> (http://netboxblue.com/)
>
>
>
>
>
>
