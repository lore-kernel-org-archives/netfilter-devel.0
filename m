From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Sat, 29 Jun 2002 11:03:32 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020629110332.I4136@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de> <15644.53466.193145.914415@isis.cs3-inc.com> <20020628232819.H4136@oknodo.bof.de> <15644.58258.483223.56527@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15644.58258.483223.56527@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Fri, Jun 28, 2002 at 03:30:42PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Is this "normal" ?  Do you have some idea about all these
> ports 3128 and 3228 ?  

The machine where that ip_conntrack came from, is running two squid
processes, one on each processor, and clients are distributed evenly
over the two processes. 3128 and 3228 are the two listening ports
of those squid processes.

Such a conntrack shape will be the normal case for iptables running
on a server, more extreme than when it's running on a routing firewall.

As you asked for ideas about "better" hashes, could you possibly try
using CRC32 over the concatenation of the key values?

best regards
  Patrick
