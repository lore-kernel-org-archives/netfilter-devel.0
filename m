From: James Ralston <qralston+ml.netfilter-devel@andrew.cmu.edu>
Subject: Re: separation of sysctl and tcp-window-tracking patch?
Date: Fri, 13 Dec 2002 03:58:59 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212130314131.2834-100000@shieldbreaker.l33tskillz.org>
References: <1039702486.2373.17.camel@pc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1039702486.2373.17.camel@pc>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 12 Dec 2002, Brian J. Murrell wrote:

> I had this problem with the Amanda protocol, but it was with the UDP
> streaming timeout.  It was not long enough to allow an Amanda client
> to go do it's work and still respond to the server when it was done.
> 
> Fortunately (for this situation), the Amanda protocol requires a
> helper, so I just upped the timeout on the connection in the helper.
> But this led me to think about UDP timeouts in general.

Well, the best way to solve this particular problem for DNS traffic
would be to use a helper.  Have the helper use a table to track the
state of DNS queries and replies via the 16-bit identifiers.  That
way, a DNS response that took more than 30 seconds could still be
permitted as RELATED traffic, by matching the ID of reply to the ID of
the query.

> # insmod ip_conntrack.o udp_timeouts="53=60,123=10"
> 
> [...]
> 
> This could be done via proc too however.  Maybe something like:
> 
> # cat /proc/sys/net/ipv4/netfilter/udp_timeout
> default=30
> 53=60
> 123=10
> 
> [...]
> 
> Of course we have two udp timeouts to deal with, initial UDP
> connection setup timeout and the UDP streaming timeout.  Perhaps two
> different /proc nodes.

While this will work, I suspect that a fair number of protocols could
be adequately supported by using helpers.

Failing a helper, I'm unable to come up with anything better than
adjusting timeouts on a per-port basis...

-- 
James Ralston, Information Technology
Software Engineering Institute
Carnegie Mellon University, Pittsburgh, PA, USA
