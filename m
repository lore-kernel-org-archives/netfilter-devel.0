From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: cttest-0.1
Date: 05 Jul 2002 17:37:24 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1025883444.28606.80.camel@tux>
References: <20020628082339.I2890@oknodo.bof.de>
	<15644.41633.528107.723418@isis.cs3-inc.com>
	<20020628203624.A4136@oknodo.bof.de>
	<15644.45834.373409.220647@isis.cs3-inc.com>
	<20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com>
	<20020702183242.E7684@oknodo.bof.de> <20020702183547.F7684@oknodo.bof.de>
	<15649.59247.55523.824241@isis.cs3-inc.com>
	<20020702203117.G7684@oknodo.bof.de> <20020702235206.H7684@oknodo.bof.de>
	<20020703041502.GH20570@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Joakim Axelsson <gozem@aaricia.hemmet.chalmers.se>
In-Reply-To: <20020703041502.GH20570@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I've also done some plotting.

about 400 student-machines behind router, it's summer now so there's not
as much traffic as the rest of the year, only ~28k entries.

hashsize is 16384 with default ip_conntrack_max of 131072.

http://gandalf.hjorten.nu/kna-gw/

I added 16384 as size in ctreport as this is what's currently used.

There's a huge diffrence between 16384 and 1638[35], from a maximum
length of 181 down to 9.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
