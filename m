From: Patrick Schaaf <bof@bof.de>
Subject: Re: cttest-0.3
Date: Sun, 7 Jul 2002 18:10:07 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020707181007.O13116@oknodo.bof.de>
References: <20020707151703.M13116@oknodo.bof.de> <1026054628.1283.170.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1026054628.1283.170.camel@tux>; from gandalf@wlug.westbo.se on Sun, Jul 07, 2002 at 05:10:28PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Now also see:

	http://bei.bof.de/ex3
	http://bei.bof.de/ex3rt
	http://bei.bof.de/ex3abcd
	http://bei.bof.de/ex3crc

This is the same calculations as before, but with a different data set.
These are from a web server farm (a web portal), with the server farm
running on a single virtual IP address [*]. I have accumulated the
/proc/net/ip_conntracks from all servers in the farm. There are
37608 unique conntrack entries, and all but 2385 of them refer
to the virtual service IP and port 80. This dataset is to show
the extreme case of a single-address-and-port server.

best regards
  Patrick

[*] we use Cisco IOS SLB for loadbalancing
