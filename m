From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Sat, 29 Jun 2002 19:22:18 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020629192218.P4136@oknodo.bof.de>
References: <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de> <15644.53466.193145.914415@isis.cs3-inc.com> <20020628232819.H4136@oknodo.bof.de> <15644.58258.483223.56527@isis.cs3-inc.com> <20020629110332.I4136@oknodo.bof.de> <15645.58583.30187.70748@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15645.58583.30187.70748@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Sat, Jun 29, 2002 at 09:48:23AM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>   This version adds a '-b X' option. If you specify that, all TCP conntracks
>   with timeouts less than X get ignored. For example, use "-b 431940" to only
>   count the conntracks active within the last 60 seconds.
> 
> I guess I just don't understand conntrack well enough.
> How does -b 431940 map to active in the last 60 sec?

Whenever a new packet arrives, the timeout of its conntrack is set to
the maximum value. For ESTABLISHED TCP connections, that's 5 days,
i.e. 432000 seconds.

> Also, why does this matter?

When worrying about chain lengths, we are worrying about lookup performance.
By restricting the accounting to conntracks active during the last 60 seconds,
I tried to capture the part of the buckets "where the action was".

My finding is that the really long chain lengths, which also prevail when
I use the crc32 hash, are all for very old inactive (and UNREPLIED)
connections  - which look like portscans from one or two days ago.
And indeed, those show the +n -n pattern on the ports that you observed,
and maybe, just maybe this is a sign of some malicious conntrack attacking
scan tool. If my further analysis below is correct, however, that attack
is almost futile.

> If you use my suggestion to treat a "full
> bucket" like a full table then the issue is whether buckets are full,
> and I don't see how that's affected by how recently used the entries
> are. 

I think my analysis shows a possible problem with your approach: when such
a port scan results in an overly long single bucket list, that list will
prevail for up to 5 days. If N is the number of buckets, and newly arriving
connections are evenly spread over the buckets, then every Nth connection
will fall into that overly long bucket - being blocked if we apply your
cutting logic unmodified.

However, in my observation of those problematic buckets, the connections
are UNREPLIED. Then we can use the same trick that is used when
ip_conntrack_max is reached: recycle one of those UNREPLIED
connections immediately for the new conntrack.

(If you are not aware of that ip_conntrack_max handling, have a look at
the early_drop() logic in ip_conntrack_core.c)

>   Incidentally, this makes the current ip_conntrack hash function look a lot
>   less bad than before. I appears that the "long bucket" packets mostly belong
>   to some kind of port scan. They will time out eventually, and they will NOT
>   contribute significantly to CPU usage, because they will be rarely hit.
> 
> They do contribute to cpu cost because they lengthen the search for
> other connections.

NO. They were "alone in their bucket". In other words, no active connection
fell into the same bucket, so they won't come into play at all during lookup.
And, as each entry has its individual timer, there is no scanning of the
overall table, so they would be really untouched in real life, until they
timeout after 5 days.


At this point, I would like to stop for some time, and await results
from other's real world ip_conntrack setups.

best regards
  Patrick
