From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 21:39:45 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020628213945.E4136@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020628213520.C4136@oknodo.bof.de>; from bof@bof.de on Fri, Jun 28, 2002 at 09:35:20PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

(I wrote)
> I have put a current sample, with ~33000 entries from one of those
> proxy boxen, at http://bei.bof.de/ip_conntrack.1.gz

I forgot to mention that on this box, I run with the default module
load time calculated hash bucket count of 7168 (much too low, I know),
and ip_conntrack_max at 200000.

best regards
  Patrick
