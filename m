From: "T. Horsnell (tsh)" <tsh@mrc-lmb.cam.ac.uk>
Subject: Re: /proc/net/ip_conntrack problem
Date: Mon, 16 Feb 2004 16:12:40 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E1AslMO-001TVL-IH@alf1.lmb.internal>
References: <20040215160140.GR15567@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20040215160140.GR15567@sunbeam.de.gnumonks.org> from Harald Welte
 at "Feb 15, 2004 05:01:40 pm"
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Can you point me to any documentation, or should I wait
until the status settles down?

=========
patch-o-matic-20031219::nfnetlink-ctnetlink-0.13.patch.help:
Status: Under development, but stabilizing now.
=========

Thanks,
Terry.


-- Start of PGP signed section.
>On Fri, Feb 06, 2004 at 05:28:51PM +0000, T. Horsnell (tsh) wrote:
>> 
>> I need to maintain a log of SNAT'd connections/disconnections
>> which contain the source/dest ip/port of the host before
>> SNAT'ing. As discussed on this list before, the POSTROUTING -j LOG
>> target doesnt provide this information, so I've written a crude
>> logger of my own.
>> 
>> This logger is a perl script which does the following:
>
>please don't do it.  frequent reading of /proc/net/ip_conntrack is not
>reliable and will slow down your firewall significantly.
>
>I recommend using ctnetlink for this kind of program.
>
>> What happens if the ip_conntrack data is being updated
>> at the instant /proc/net/ip_conntrack is being read?
>> Is there the possibility of a race condition here which
>> might explain what I'm seeing? Any suggestions welcome.
>
>yes, there almost certainly is one.
>
>> Cheers,
>> Terry.
>
>-- 
>- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
>============================================================================
>  "Fragmentation is like classful addressing -- an interesting early
>   architectural error that shows how much experimentation was going
>   on while IP was being designed."                    -- Paul Vixie
-- End of PGP section, PGP failed!
