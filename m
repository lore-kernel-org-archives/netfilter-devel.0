From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 23:28:19 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020628232819.H4136@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de> <15644.53466.193145.914415@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15644.53466.193145.914415@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Fri, Jun 28, 2002 at 02:10:50PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 28, 2002 at 02:10:50PM -0700, Don Cohen wrote:
> Patrick Schaaf writes:
>  > I have put a current sample, with ~33000 entries from one of those
>  > proxy boxen, at http://bei.bof.de/ip_conntrack.1.gz
> 
> I started to test and found that I got longer buckets than I expected.
> The problem seems to be that you have a lot of duplicate entries!
> This should not happen in a connection table, right?

I see about 550 duplicates in 33000 entries. This is most likely due to
'cat /proc/net/ip_conntrack' being terminally broken. But that's not news
to me. Sorry I did not check before.

> I predict that when I remove the duplicates I'll get the expected
> distribution.

sort ip_conntrack.1|uniq

regards
  Patrick
