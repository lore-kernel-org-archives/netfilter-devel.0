From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Fri, 21 May 2004 14:35:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405211423310.8045-100000@blackhole.kfki.hu>
References: <40AD4B36.50202@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <40AD4B36.50202@snapgear.com>
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

On Fri, 21 May 2004, Philip Craig wrote:

> Jozsef Kadlecsik wrote:
> > We could introduce a new silly target for that purpose like NOTRACK or
> > TRACE. However it's pure marking and we do have a interface to mark
> > packets: the MARK target. So if we could tell the system which mark value
> > has got the given special meaning, we wouldn't need a new target and we
> > could even eliminate the NOTRACK/TRACE targets.
>
> I assume this will mean allowing the MARK target to be used in the raw
> table, otherwise you can't mark the packets before conntrack.

Oops.

> Will this mean that only one of these features can be used at a time,
> since a packet cannot have multiple marks?  And use of any of these
> features would preclude current uses of MARK, such as policy routing?
> You could add support for masking bits of the mark, but you would have
> to add this to the policy routing also.

Boom! Bye-bye idea, that won't go.

> What happens when you modify the /proc setting?  This will change the
> state of packets currently being processed, which could cause problems.

The raw table is the very first, so no other parts of netfilter could see
the packets.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
